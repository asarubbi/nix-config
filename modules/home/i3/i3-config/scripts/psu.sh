#!/usr/bin/env bash
set -euo pipefail

# Find the Corsair PSU hwmon path by driver name
HWMON=""
for n in /sys/class/hwmon/*/name; do
  if grep -qi 'corsair' "$n"; then
    HWMON="$(dirname "$n")"
    break
  fi
done
[ -n "$HWMON" ] || {
  echo "PSU n/a"
  exit 0
}

read_val() {
  # Reads first existing file among args
  for f in "$@"; do
    if [ -r "$f" ]; then
      cat "$f"
      return 0
    fi
  done
  echo ""
}

# Resolve power "total" by label
POWER_UW=""
shopt -s nullglob
for p in "$HWMON"/power*_label; do
  lbl="$(tr -d '\n' <"$p" | tr '[:upper:]' '[:lower:]')"
  if [[ "$lbl" == *"total"* ]]; then
    idx="${p##*/power}"
    idx="${idx%_label}"
    POWER_UW="$(read_val "$HWMON/power${idx}_average" "$HWMON/power${idx}_input")"
    break
  fi
done
# Fallback if labels are unavailable: try the common files
if [ -z "${POWER_UW}" ]; then
  POWER_UW="$(read_val "$HWMON/power1_average" "$HWMON/power1_input" "$HWMON/power2_average" "$HWMON/power2_input")"
fi
POWER_W=0
if [ -n "${POWER_UW}" ]; then
  POWER_W=$((POWER_UW / 1000000))
fi

# Temps by label if present
get_temp_c() {
  local want="$1"
  local found=""
  for t in "$HWMON"/temp*_label; do
    lbl="$(tr -d '\n' <"$t" | tr '[:upper:]' '[:lower:]')"
    if [[ "$lbl" == *"$want"* ]]; then
      idx="${t##*/temp}"
      idx="${idx%_label}"
      val="$(read_val "$HWMON/temp${idx}_input")"
      if [ -n "$val" ]; then
        echo $((val / 1000))
        return 0
      fi
    fi
  done
  echo ""
}

VRM="$(get_temp_c "vrm")"
CASE="$(get_temp_c "case")"

# Fallbacks if labels missing
[ -n "$VRM" ] || {
  v="$(read_val "$HWMON/temp1_input")"
  [ -n "$v" ] && VRM=$((v / 1000)) || VRM=0
}
[ -n "$CASE" ] || {
  v="$(read_val "$HWMON/temp2_input")"
  [ -n "$v" ] && CASE=$((v / 1000)) || CASE=0
}

# Fan rpm
FAN="$(read_val "$HWMON/fan1_input")"
[ -n "$FAN" ] || FAN=0

# Output for i3blocks or i3status-rs custom block
echo "${POWER_W}W ${VRM}°C VRM ${CASE}°C case ${FAN}RPM"

# Color line for i3blocks protocol
if [ "$VRM" -ge 70 ] || [ "$CASE" -ge 70 ]; then
  echo "#ff5555"
elif [ "$VRM" -ge 60 ] || [ "$CASE" -ge 60 ]; then
  echo "#ffaa00"
else
  echo "#ffffff"
fi
