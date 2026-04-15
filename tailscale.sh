#!/usr/bin/env bash
# Waybar Tailscale Status Indicator

STATUS=$(tailscale status --json 2>/dev/null)

if [ -z "$STATUS" ]; then
    echo '{"text": "", "tooltip": "Tailscale: 起動していません", "class": "disconnected", "alt": "disconnected"}'
    exit 0
fi

BACKEND=$(echo "$STATUS" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('BackendState',''))" 2>/dev/null)

HOSTNAME=$(echo "$STATUS" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('Self',{}).get('HostName','?'))" 2>/dev/null)
TAILSCALE_IP=$(ip -4 addr show tailscale0 2>/dev/null | awk '/inet /{print $2}' | cut -d'/' -f1)
CURRENT_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')

if [ "$BACKEND" = "Running" ]; then
    PEER_COUNT=$(echo "$STATUS" | python3 -c "import json,sys; d=json.load(sys.stdin); peers=d.get('Peer',{}); online=[v for v in peers.values() if v.get('Online',False)]; print(len(online))" 2>/dev/null)
    echo "{\"text\": \"󰒃 $TAILSCALE_IP\", \"tooltip\": \"Tailscale: 接続中\\nホスト名: $HOSTNAME\\nTailscale IP: $TAILSCALE_IP\\n現在のIP: $CURRENT_IP\\nオンラインのピア数: $PEER_COUNT\", \"class\": \"connected\", \"alt\": \"connected\"}"
else
    echo "{\"text\": \"󰒄 $CURRENT_IP\", \"tooltip\": \"Tailscale: 切断中\\nホスト名: $HOSTNAME\\nTailscale IP: $TAILSCALE_IP\\n現在のIP: $CURRENT_IP\", \"class\": \"disconnected\", \"alt\": \"disconnected\"}"
fi
