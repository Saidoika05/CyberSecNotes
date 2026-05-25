#!/bin/bash
# realtime_api_finder.sh - No stdin conflicts

if [ $# -ne 1 ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

TARGET="$1"
KATANA="$HOME/go/bin/katana"   # adjust if needed

if [ ! -x "$KATANA" ]; then
    echo "ERROR: katana not found at $KATANA"
    exit 1
fi

# Run katana with line buffering, process each URL
stdbuf -oL "$KATANA" -u "$TARGET" -silent -no-color 2>/dev/null | \
while IFS= read -r url; do
    # Skip lines that don't look like URLs
    [[ "$url" != http://* && "$url" != https://* ]] && continue

    echo "[*] Discovered: $url"

    # Get HTTP status
    status=$(curl -L -I -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null || echo "000")

    if [[ "$status" != "200" ]]; then
        echo "[-] HTTP $status - skipping"
        echo "----------------------------------------"
        continue
    fi

    echo "[+] HTTP 200 - scanning for API patterns..."

    # Fetch content and extract API candidates (no inner while read on stdin)
    content=$(curl -s --max-time 5 "$url" 2>/dev/null)
    if [[ -n "$content" ]]; then
        # Use grep + sed, then read into array to avoid subshell issues
        mapfile -t matches < <(echo "$content" | grep -E -i -o "(api|v[0-9]+|graphql|rest|wp-json|\.api)[/:=?&%#]*[^[:space:]\'\`\"]*" | sort -u)
        for match in "${matches[@]}"; do
            echo "    --> API candidate: $match"
        done
    fi

    echo "----------------------------------------"
done

echo "[*] Katana finished."