#!/usr/bin/env bash
# setup.sh - Otomasi penyiapan & verifikasi aplikasi

set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/common.sh
source "$APP_DIR/lib/common.sh"

VENV_DIR="$APP_DIR/.venv"
PORT="${PORT:-5000}"

log_info "[1/5] Memeriksa prasyarat..."

require_cmd python3
require_cmd curl
require_cmd ss

if ! python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)'; then
    die "dibutuhkan Python 3.10 atau lebih baru."
fi

port_is_free "$PORT" || die "port $PORT sudah dipakai proses lain"

log_info "[2/5] Menyiapkan virtual environment..."

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

log_info "[3/5] Memasang dependensi..."

pip install --quiet --upgrade pip
pip install --quiet -r "$APP_DIR/requirements.txt"

log_info "[4/5] Menjalankan aplikasi pada port $PORT..."

PORT="$PORT" python3 "$APP_DIR/src/app.py" &

APP_PID=$!

cleanup() {
    if kill -0 "$APP_PID" 2>/dev/null; then
        log_info "Menghentikan aplikasi PID $APP_PID."
        kill -TERM "$APP_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT

sleep 3

if ! kill -0 "$APP_PID" 2>/dev/null; then
    die "aplikasi gagal dijalankan."
fi

log_info "[5/5] Melakukan smoke test..."

if curl -fsS "http://127.0.0.1:$PORT/health" >/dev/null; then
    log_info "SUKSES: aplikasi lulus health check (PID $APP_PID)."
else
    log_error "GAGAL: aplikasi tidak merespons health check."
    exit 1
fi

log_info "Aplikasi berjalan. Tekan Ctrl+C untuk menghentikan."

wait "$APP_PID"
