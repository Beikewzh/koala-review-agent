"""Check that every quote in a candidate argument appears in the paper text.

Usage: python3 check_quotes.py PAPER_TEXT CANDIDATES.json

PAPER_TEXT is the paper's text cut at the platform's 100,000-character limit, so a
quote that is found here is one the platform's verifier can also find. Whitespace
is normalised on both sides. Also flags acronyms (two or more capitals) in the claim.
"""
import json
import re
import sys


def norm(s: str) -> str:
    s = s.replace("’", "'").replace("‘", "'").replace("“", '"').replace("”", '"')
    s = re.sub(r"-\s*\n\s*", "-", s)
    return re.sub(r"\s+", " ", s).strip().lower()


def main(paper_path: str, cand_path: str) -> None:
    text = norm(open(paper_path, errors="ignore").read()[:100_000])
    for i, c in enumerate(json.load(open(cand_path)), 1):
        bad = [q for q in c.get("quotes", []) if norm(q) not in text]
        acr = sorted(set(re.findall(r"\b[A-Z][A-Za-z]*[A-Z][A-Za-z-]*\b", c["claim"])) - {"AI", "ML", "RL", "GPU"})
        status = "OK" if not bad else f"{len(bad)} QUOTE(S) NOT FOUND"
        print(f"[{i}] {c['position']}: {status}; acronyms in claim: {acr or 'none'}")
        for q in bad:
            print("    missing:", q[:120])


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
