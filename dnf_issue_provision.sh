#!/usr/bin/env bash
#
# provision.sh â€” Fix TLS 1.3 "decode_error" handshake failures against
# Rocky/RHEL mirror CDNs caused by OpenSSL 3.5's default post-quantum
# hybrid key-share groups (MLKEM768-X25519, P256-MLKEM768, etc).
#
# Root cause: some CDNs/middleboxes fronting mirror services can't parse
# the larger TLS 1.3 ClientHello that includes PQ hybrid groups, and
# respond with `SSL routines::tlsv1 alert decode error`.
#
# Fix: add a crypto-policies subpolicy module that removes the PQ hybrid
# groups from the TLS scope only (SSH, IKE, etc. are untouched), then
# activate DEFAULT:NO-PQ-TLS. This is persistent â€” it survives package
# updates and future `update-crypto-policies` runs, unlike editing the
# generated /etc/crypto-policies/back-ends/opensslcnf.config directly.
#
# Usage:
#   sudo ./provision.sh            # apply the fix
#   sudo ./provision.sh --revert   # remove the module, restore DEFAULT
#   sudo ./provision.sh --check    # report current state, change nothing
#
# Safe to re-run (idempotent).

set -euo pipefail

MODULE_NAME="NO-PQ-TLS"
MODULE_DIR="/etc/crypto-policies/policies/modules"
MODULE_FILE="${MODULE_DIR}/${MODULE_NAME}.pmod"
BASE_POLICY="DEFAULT"
TARGET_POLICY="${BASE_POLICY}:${MODULE_NAME}"
TEST_URL="https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-10"

log()  { echo "[provision] $*"; }
err()  { echo "[provision] ERROR: $*" >&2; }

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        err "Must be run as root (use sudo)."
        exit 1
    fi
}

show_status() {
    log "Current crypto policy: $(update-crypto-policies --show 2>/dev/null || echo 'unknown')"
    if [[ -f "${MODULE_FILE}" ]]; then
        log "Module file present: ${MODULE_FILE}"
    else
        log "Module file absent: ${MODULE_FILE}"
    fi
}

write_module() {
    mkdir -p "${MODULE_DIR}"
    cat > "${MODULE_FILE}" << 'EOF'
# NO-PQ-TLS.pmod
#
# Disables post-quantum hybrid key-exchange groups for TLS only.
# Workaround for CDNs/load-balancers that reject the larger TLS 1.3
# ClientHello these groups produce (symptom: "tlsv1 alert decode error"
# during the TLS handshake, immediately after ClientHello is sent).
#
# Managed by provision.sh â€” do not edit by hand; re-run the script instead.
group@TLS = -MLKEM768-X25519 -P256-MLKEM768 -P384-MLKEM1024 -MLKEM1024-X448
EOF
    log "Wrote ${MODULE_FILE}"
}

apply_fix() {
    require_root

    if [[ ! -f "${MODULE_FILE}" ]]; then
        write_module
    else
        log "Module already exists at ${MODULE_FILE}, leaving as-is."
    fi

    current_policy="$(update-crypto-policies --show 2>/dev/null || echo '')"
    if [[ "${current_policy}" == "${TARGET_POLICY}" ]]; then
        log "Policy already set to ${TARGET_POLICY}, nothing to do."
    else
        log "Setting crypto policy to ${TARGET_POLICY} (was: ${current_policy:-unset})"
        update-crypto-policies --set "${TARGET_POLICY}"
    fi

    log "Verifying PQ groups are no longer in the active TLS group list..."
    if grep -q "^group = " /etc/crypto-policies/state/CURRENT.pol 2>/dev/null; then
        active_groups="$(grep "^group = " /etc/crypto-policies/state/CURRENT.pol)"
        if echo "${active_groups}" | grep -qE "MLKEM768-X25519|P256-MLKEM768|P384-MLKEM1024|MLKEM1024-X448"; then
            err "PQ groups still present in active policy â€” check ${MODULE_FILE} and re-run."
            echo "${active_groups}"
            exit 1
        else
            log "Confirmed: PQ hybrid groups removed from active TLS group list."
        fi
    else
        log "Could not read /etc/crypto-policies/state/CURRENT.pol to verify; proceeding anyway."
    fi

    if command -v curl >/dev/null 2>&1; then
        log "Testing TLS handshake against ${TEST_URL} ..."
        if curl -fsS -o /dev/null "${TEST_URL}"; then
            log "Success: TLS handshake and download completed cleanly."
        else
            err "curl still failed against ${TEST_URL}."
            err "Consider a reboot â€” Red Hat recommends restarting so all"
            err "already-running services pick up the new policy."
            exit 1
        fi
    fi

    log "Done. New shells/processes (including dnf) will use ${TARGET_POLICY} immediately."
    log "For full effect on already-running long-lived services, a reboot is recommended."
}

revert_fix() {
    require_root
    log "Reverting to ${BASE_POLICY} and removing ${MODULE_FILE}..."
    update-crypto-policies --set "${BASE_POLICY}"
    if [[ -f "${MODULE_FILE}" ]]; then
        rm -f "${MODULE_FILE}"
        log "Removed ${MODULE_FILE}"
    fi
    log "Reverted. Current policy: $(update-crypto-policies --show)"
}

case "${1:-}" in
    --revert)
        revert_fix
        ;;
    --check)
        show_status
        ;;
    "")
        apply_fix
        ;;
    *)
        echo "Usage: $0 [--revert|--check]"
        exit 1
        ;;
esac
