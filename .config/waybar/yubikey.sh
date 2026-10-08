#!/bin/sh
socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/yubikey-touch-detector.socket" - | while IFS= read -r -n5 ev; do
    case "$ev" in
        *_1) printf '{"text":"","class":"touch","tooltip":"YubiKey: Berührung erforderlich"}\n' ;;
        *_0) printf '{"text":"","class":"idle"}\n' ;;
    esac
done
