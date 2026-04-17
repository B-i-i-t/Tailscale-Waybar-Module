# Tailscale-Waybar-Module

A [Waybar](https://github.com/Alexays/Waybar) custom module that displays your [Tailscale](https://tailscale.com/) connection status and IP address.

## Preview

| State | Display | Tooltip |
|-------|---------|---------|
| Connected | `󰒃 100.x.x.x` | Hostname, Tailscale IP, current IP, online peer count |
| Disconnected | `󰒄 192.168.x.x` | Hostname, Tailscale IP, current IP |
| Not running | _(empty)_ | "Tailscale: 起動していません" |

## Requirements

- `tailscale` — Tailscale client
- `python3` — for JSON parsing
- `iproute2` — `ip` command

## Installation

1. Copy `tailscale.sh` to your Waybar scripts directory and make it executable:

```bash
cp tailscale.sh ~/.config/waybar/scripts/tailscale.sh
chmod +x ~/.config/waybar/scripts/tailscale.sh
```

2. Add the module to your Waybar config:

```jsonc
"custom/tailscale": {
    "exec": "~/.config/waybar/scripts/tailscale.sh",
    "return-type": "json",
    "interval": 10,
    "format": "{}",
    "on-click": "tailscale up",
    "tooltip": true
}
```

3. Add `"custom/tailscale"` to your `modules-left`, `modules-center`, or `modules-right`.

## Styling (optional)

```css
#custom-tailscale {
    color: #ffffff;
}

#custom-tailscale.connected {
    color: #a6e3a1;
}

#custom-tailscale.disconnected {
    color: #f38ba8;
}
```

