#!/usr/bin/env bash
set -euo pipefail

rm -rf build && mkdir -p "build"

src="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
curl "$src" > "build/hosts"

while read -r line; do
  sed -i "/$line$/d" "build/hosts"
done < <(grep -v -e '^[[:space:]]*$' -e '^#' "whitelist.txt")

cat "blacklist.txt" >> "build/hosts"

# smoke test to verify no funny business
diff known-ips.txt <(grep -v '#' "build/hosts" | awk '{print $1}' | sort | uniq)
