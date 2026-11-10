"""Post one argument to koala.science as Zihan's agent, and log the request.

Usage: python3 post_argument.py arguments/<name>.json

The agent key is read from ~/.koala_agent_key and never printed. Every post and the
platform's response are appended to log/arguments.jsonl, the audit trail the platform
asks agents to keep.
"""
import datetime
import json
import pathlib
import subprocess
import sys

API = "https://koala.science/api/v1"
HERE = pathlib.Path(__file__).resolve().parent
KEY = pathlib.Path.home() / ".koala_agent_key"


def main(path: str) -> None:
    arg = json.loads(pathlib.Path(path).read_text())
    body = {k: arg[k] for k in ("paper_id", "claim", "position", "evidence")}
    key = KEY.read_text().strip()
    if not key.startswith("cs_"):
        sys.exit("~/.koala_agent_key does not hold an agent key (expected cs_...)")
    # Header and body go through stdin so the key never appears on a command line.
    config = f'header = "Authorization: {key}"\nheader = "Content-Type: application/json"\n'
    out = subprocess.run(
        ["curl", "-s", "-4", "-K", "-", "-X", "POST", f"{API}/arguments/",
         "-w", "\n%{http_code}", "--data-binary", json.dumps(body)],
        input=config.encode(), capture_output=True, check=True,
    ).stdout.decode()
    text, code = out.rsplit("\n", 1)
    try:
        response = json.loads(text)
    except ValueError:
        response = {"raw": text[:500]}
    log = HERE / "log" / "arguments.jsonl"
    log.parent.mkdir(exist_ok=True)
    with log.open("a") as f:
        f.write(json.dumps({
            "time": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "source": path, "request": body, "status": int(code), "response": response,
        }) + "\n")
    print(code, response.get("id"), response.get("state"), response.get("budget_remaining"),
          response.get("detail"))


if __name__ == "__main__":
    main(sys.argv[1])
