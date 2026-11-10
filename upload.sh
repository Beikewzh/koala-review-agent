#!/bin/bash
# Upload the papers in papers.json to koala.science through the admin endpoint
# POST /papers/ (no paper allowance needed, but the account must be a superuser).
#
# You type the email and password. They are never printed, written to disk, or
# passed on a command line. The script stops before posting if the account is
# not a superuser, skips papers whose title is already on the platform, and asks
# for a final y/N before anything is posted.
set -euo pipefail

API="https://koala.science/api/v1"
HERE="$(cd "$(dirname "$0")" && pwd)"
PAPERS="${1:-$HERE/papers.json}"

read -r -p "Koala admin email: " KOALA_EMAIL
read -r -s -p "Password: " KOALA_PASS
echo
export KOALA_EMAIL KOALA_PASS

login_body() {
  python3 -c 'import json, os; print(json.dumps({"email": os.environ["KOALA_EMAIL"], "password": os.environ["KOALA_PASS"]}))'
}

TOKEN="$(login_body | curl -s -4 -X POST "$API/auth/login" \
  -H 'Content-Type: application/json' --data-binary @- \
  | python3 -c 'import json, sys
d = json.load(sys.stdin)
t = d.get("access_token")
if not t:
    sys.exit("Login failed: " + str(d.get("detail", d)))
print(t)')"
unset KOALA_PASS

auth() { printf 'Authorization: Bearer %s' "$TOKEN"; }

ME="$(curl -s -4 "$API/users/me" -H @<(auth))"
python3 -c 'import json, sys
me = json.loads(sys.argv[1])
print("Logged in as", me.get("name"), "| superuser:", me.get("is_superuser"))
if not me.get("is_superuser"):
    sys.exit("This account is not a superuser, so POST /papers/ will refuse it. Nothing was posted.")' "$ME"

EXISTING="$(curl -s -4 "$API/papers/?limit=500")"
TODO="$(python3 -c 'import json, sys
papers = json.load(open(sys.argv[1]))
have = {p["title"].strip().lower() for p in json.loads(sys.argv[2])}
todo = [p for p in papers if p["title"].strip().lower() not in have]
for p in papers:
    print(("  post  " if p in todo else "  skip (already there)  ") + p["arxiv_id"] + "  " + p["title"], file=sys.stderr)
print(json.dumps(todo))' "$PAPERS" "$EXISTING")"

N="$(python3 -c 'import json, sys; print(len(json.loads(sys.argv[1])))' "$TODO")"
if [ "$N" = "0" ]; then echo "Nothing to post."; exit 0; fi

read -r -p "Post these $N paper(s) publicly on koala.science? [y/N] " OK
[ "$OK" = "y" ] || { echo "Cancelled. Nothing was posted."; exit 0; }

python3 -c 'import json, sys
for p in json.loads(sys.argv[1]):
    print(json.dumps({"title": p["title"], "abstract": p["abstract"], "domain": p["domain"], "pdf_url": p["pdf_url"]}))' "$TODO" \
| while IFS= read -r BODY; do
    RESP="$(printf '%s' "$BODY" | curl -s -4 -w '\n%{http_code}' -X POST "$API/papers/" \
      -H 'Content-Type: application/json' -H @<(auth) --data-binary @-)"
    CODE="${RESP##*$'\n'}"
    python3 -c 'import json, sys
code, body = sys.argv[1], sys.argv[2]
try:
    d = json.loads(body)
except ValueError:
    d = {"detail": body[:200]}
if code == "201":
    print("  posted", d.get("id"), d.get("title"))
else:
    print("  FAILED", code, d.get("detail"))' "$CODE" "${RESP%$'\n'*}"
  done
