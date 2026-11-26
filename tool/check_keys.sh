#!/usr/bin/env bash
# Reports whether each FuelWise key is configured, WITHOUT printing any value.
# Shows only: missing / placeholder / set (length + first 4 characters' shape).
set -u
cd "$(dirname "$0")/.."

shape() { # prints "set (39 chars, starts AIza)" style info for a value, never the value itself
  local v="$1"
  if [[ -z "$v" ]]; then echo "missing"; return; fi
  if [[ "$v" == your-* || "$v" == optional-* || "$v" == only-for-* ]]; then echo "placeholder"; return; fi
  local prefix="${v:0:4}"
  [[ "$prefix" == "AIza" ]] || prefix="other"
  echo "set (${#v} chars, prefix: $prefix)"
}

json_value() { # file key
  [[ -f "$1" ]] || { echo ""; return; }
  python3 -I -c 'import json,sys; print(json.load(open(sys.argv[1])).get(sys.argv[2],""))' "$1" "$2" 2>/dev/null
}

for f in config/dev.json config/dev.android.json; do
  if [[ -f "$f" ]]; then
    echo "$f"
    for k in GOOGLE_MAPS_API_KEY ANDROID_CERT_SHA1 OCM_API_KEY; do
      printf '  %-22s %s\n' "$k" "$(shape "$(json_value "$f" "$k")")"
    done
  else
    echo "$f: not created"
  fi
done

x=ios/Flutter/Secrets.xcconfig
if [[ -f "$x" ]]; then
  v=$(sed -n 's/^GOOGLE_MAPS_API_KEY *= *//p' "$x" | tr -d '[:space:]')
  printf '%s\n  %-22s %s\n' "$x" GOOGLE_MAPS_API_KEY "$(shape "$v")"
else
  echo "$x: not created"
fi

s=functions/.secret.local
if [[ -f "$s" ]]; then
  v=$(sed -n 's/^GEMINI_API_KEY=//p' "$s" | tr -d '[:space:]')
  printf '%s\n  %-22s %s\n' "$s" GEMINI_API_KEY "$(shape "$v")"
else
  echo "$s: not created"
fi

echo
echo "Git safety:"
for f in config/dev.json config/dev.android.json ios/Flutter/Secrets.xcconfig functions/.secret.local; do
  if git check-ignore -q "$f"; then echo "  ignored   $f"; else echo "  NOT IGNORED  $f  <- do not commit"; fi
done
