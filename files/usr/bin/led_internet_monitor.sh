#!/bin/sh
# LED Internet Monitor for JioRouter AX6000 (JIDU6J11 Series)
#
# LED states:
#   Offline / No Internet: Red Solid
#   Internet Connected (WAN / USB): Green Solid
#   Booting: Red Blinking

PATH="${PATH:-/usr/sbin:/usr/bin:/sbin:/bin}"

PING_TARGET="${PING_TARGET:-1.1.1.1}"
PING_TIMEOUT="${PING_TIMEOUT:-2}"
REQUIRED_SUCCESS="${REQUIRED_SUCCESS:-2}"
REQUIRED_FAILURE="${REQUIRED_FAILURE:-2}"
CHECK_INTERVAL="${CHECK_INTERVAL:-3}"
BOOT_TIMEOUT="${BOOT_TIMEOUT:-30}"

LED_RED="${LED_RED:-/sys/class/leds/red:status}"
LED_GREEN="${LED_GREEN:-/sys/class/leds/green:status}"
LED_BLUE="${LED_BLUE:-/sys/class/leds/blue:status}"

log_msg()
{
    logger -t internet-led "$*"
}

led_exists()
{
    [ -d "$1" ] && [ -f "$1/brightness" ]
}

if ! led_exists "$LED_RED" || ! led_exists "$LED_GREEN"; then
    log_msg "ERROR: Required status LEDs (red/green) are missing"
    exit 1
fi

led_trigger_none()
{
    local led="$1"
    if [ -f "$led/trigger" ]; then
        echo none > "$led/trigger" 2>/dev/null || true
    fi
}

led_off()
{
    local led="$1"
    led_trigger_none "$led"
    echo 0 > "$led/brightness" 2>/dev/null || true
}

led_on()
{
    local led="$1"
    led_trigger_none "$led"
    echo 1 > "$led/brightness" 2>/dev/null || true
}

all_off()
{
    led_off "$LED_RED"
    led_off "$LED_GREEN"
    led_exists "$LED_BLUE" && led_off "$LED_BLUE"
}

set_boot()
{
    led_off "$LED_GREEN"
    led_exists "$LED_BLUE" && led_off "$LED_BLUE"

    if [ -f "$LED_RED/trigger" ]; then
        echo timer > "$LED_RED/trigger" 2>/dev/null || true
        [ -f "$LED_RED/delay_on" ] && echo 500 > "$LED_RED/delay_on" 2>/dev/null || true
        [ -f "$LED_RED/delay_off" ] && echo 500 > "$LED_RED/delay_off" 2>/dev/null || true
    else
        led_on "$LED_RED"
    fi
}

set_red()
{
    all_off
    led_on "$LED_RED"
}

set_green()
{
    all_off
    led_on "$LED_GREEN"
}

get_route_device()
{
    local route
    local dev

    route="$(ip -4 route get "$PING_TARGET" 2>/dev/null)"
    [ -n "$route" ] || return 1

    dev="$(echo "$route" | sed -n 's/.* dev \([^ ]*\).*/\1/p' | awk '{print $1}')"
    [ -n "$dev" ] && echo "$dev"
}

check_internet()
{
    local dev="$1"
    [ -n "$dev" ] || return 1

    ping -4 -c 1 -W "$PING_TIMEOUT" -I "$dev" "$PING_TARGET" >/dev/null 2>&1
}

log_msg "Starting JioRouter LED Internet Monitor"
set_boot

BOOT_START="$(awk '{print int($1)}' /proc/uptime 2>/dev/null || echo 0)"
LAST_STATE="BOOTING"
SUCCESS_COUNT=0
FAILURE_COUNT=0

while true; do
    UPTIME="$(awk '{print int($1)}' /proc/uptime 2>/dev/null || echo 0)"
    ROUTE_DEV="$(get_route_device)"

    if [ -n "$ROUTE_DEV" ] && check_internet "$ROUTE_DEV"; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        FAILURE_COUNT=0
    else
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
        SUCCESS_COUNT=0
    fi

    if [ "$SUCCESS_COUNT" -ge "$REQUIRED_SUCCESS" ]; then
        if [ "$LAST_STATE" != "ONLINE" ]; then
            log_msg "Internet Connected via $ROUTE_DEV -> Setting LED GREEN"
            set_green
            LAST_STATE="ONLINE"
        fi
    elif [ "$FAILURE_COUNT" -ge "$REQUIRED_FAILURE" ]; then
        if [ "$UPTIME" -ge "$BOOT_TIMEOUT" ]; then
            if [ "$LAST_STATE" != "OFFLINE" ]; then
                log_msg "Internet Disconnected / No Route -> Setting LED RED"
                set_red
                LAST_STATE="OFFLINE"
            fi
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
