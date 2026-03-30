#!/usr/bin/env bash
set -euo pipefail

DATA=$(cat)

# Extract fields via single jq call
IFS=$'\t' read -r MODEL MODEL_ID DIR PCT FIVE_HR SEVEN_DAY RESETS_AT < <(
  echo "$DATA" | jq -r '[
        (.model.display_name // "Claude"),
        (try (.model.id // "unknown") catch "unknown"),
        (.cwd // "~" | split("/") | last),
        (try (
    if (.context_window.remaining_percentage // null) != null then
      100 - (.context_window.remaining_percentage | floor)
    elif (.context_window.context_window_size // 0) > 0 then
      (((.context_window.current_usage.input_tokens // 0) +
        (.context_window.current_usage.cache_creation_input_tokens // 0) +
        (.context_window.current_usage.cache_read_input_tokens // 0)) * 100 /
       .context_window.context_window_size) | floor
    else 0 end
  ) catch 0),
        (try (.rate_limits.five_hour.used_percentage // 0 | floor) catch 0),
        (try (.rate_limits.seven_day.used_percentage // 0 | floor) catch 0),
        (try (.rate_limits.five_hour.resets_at // 0) catch 0)
    ] | @tsv'
)

# Persist the reset timestamp when we receive a valid one from the API
RESET_FILE="${HOME}/.claude/usage_reset_time"
if [ "${RESETS_AT:-0}" -gt 0 ] 2>/dev/null; then
  echo "$RESETS_AT" > "$RESET_FILE"
fi

# Compute time-remaining string from stored or live reset timestamp
RESET_STR=""
EFFECTIVE_RESETS_AT="${RESETS_AT:-0}"
if [ "${EFFECTIVE_RESETS_AT}" -le 0 ] && [ -f "$RESET_FILE" ]; then
  EFFECTIVE_RESETS_AT=$(cat "$RESET_FILE" 2>/dev/null || echo 0)
fi
if [ "${EFFECTIVE_RESETS_AT:-0}" -gt 0 ] 2>/dev/null; then
  NOW=$(date +%s)
  DIFF=$(( EFFECTIVE_RESETS_AT - NOW ))
  if [ "$DIFF" -gt 0 ]; then
    HRS=$(( DIFF / 3600 ))
    MINS=$(( (DIFF % 3600) / 60 ))
    if [ "$HRS" -gt 0 ]; then
      RESET_STR="↻ resets in ${HRS}h ${MINS}m"
    else
      RESET_STR="↻ resets in ${MINS}m"
    fi
  else
    # Window has passed; remove stale file
    rm -f "$RESET_FILE"
  fi
fi

# Build gradient bar for any percentage
make_bar() {
  local PCT=$1
  local FILLED=$((PCT * 10 / 100))
  local EMPTY=$((10 - FILLED))
  local BAR=""
  for ((i = 0; i < FILLED; i++)); do
    if [ $i -lt 3 ]; then
      BAR+="\033[38;5;218m▓"
    elif [ $i -lt 6 ]; then
      BAR+="\033[38;5;204m▓"
    else
      BAR+="\033[38;5;162m▓"
    fi
  done
  for ((i = 0; i < EMPTY; i++)); do BAR+="\033[38;5;243m░"; done
  echo -n "$BAR"
}

# Threshold color
pct_color() {
  local PCT=$1
  if [ "$PCT" -gt 80 ]; then
    echo -n "\033[38;5;168m"
  elif [ "$PCT" -gt 50 ]; then
    echo -n "\033[38;5;222m"
  else
    echo -n "\033[38;5;108m"
  fi
}

CTX_BAR=$(make_bar "$PCT")
FIVE_BAR=$(make_bar "$FIVE_HR")
WEEK_BAR=$(make_bar "$SEVEN_DAY")

CTX_CLR=$(pct_color "$PCT")
FIVE_CLR=$(pct_color "$FIVE_HR")
WEEK_CLR=$(pct_color "$SEVEN_DAY")

SEP="\033[2m\033[38;5;243m │ \033[0m"

RESET_SUFFIX=""
if [ -n "$RESET_STR" ]; then
  RESET_SUFFIX="${SEP}\033[38;5;116m${RESET_STR}\033[0m"
fi

echo -e "\033[38;5;183;1m$MODEL\033[0m${SEP}\033[38;5;183m📁 $DIR\033[0m${SEP}\033[38;5;243mCtx \033[0m${CTX_BAR}\033[0m ${CTX_CLR}$PCT%\033[0m${SEP}\033[38;5;243m5h \033[0m${FIVE_BAR}\033[0m ${FIVE_CLR}$FIVE_HR%\033[0m${SEP}\033[38;5;243m7d \033[0m${WEEK_BAR}\033[0m ${WEEK_CLR}$SEVEN_DAY%\033[0m${RESET_SUFFIX}"
