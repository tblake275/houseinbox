"""Parse City of Austin Master Comment Reports into one row per comment.

Usage:
    python scripts/parse_mcr.py data/raw/AUS-0001/mcr/U0.pdf > out.csv
    python scripts/parse_mcr.py data/raw/*/mcr/*.pdf --csv data/processed/mcr_comments.csv

Needs: pip install pypdf
Status: stub. Comment pattern is based on one public example (RZ03. ...).
Tune it on the first 20 real MCRs until 95%+ of comments parse.
"""
import csv
import re
import sys
from pathlib import Path

from pypdf import PdfReader

# 'RZ03. Outdoor kitchen cannot be in setback.'  -> prefix RZ, number 03
COMMENT_START = re.compile(r"^\s*(?P<prefix>[A-Z]{1,4})\s?(?P<num>\d{1,3})\s*[.:)]\s+(?P<body>.*)")
CYCLE = re.compile(r"\bU(?:PDATE)?\s*:?\s*U?(?P<n>\d+)\b", re.I)
STATUS_CLEARED = re.compile(r"comment cleared", re.I)
STATUS_REMAINS = re.compile(r"comment remains", re.I)
CITATION = re.compile(r"\b(?:LDC\s*)?25-\d{1,2}-\d{1,4}(?:\.[A-Z0-9.]+)?\b|\bR\d{3}(?:\.\d+)*\b")


def pdf_text(path: Path) -> str:
    return "\n".join(page.extract_text() or "" for page in PdfReader(str(path)).pages)


def parse(text: str):
    comments, current = [], None
    for line in text.splitlines():
        m = COMMENT_START.match(line)
        if m:
            if current:
                comments.append(current)
            current = {
                "comment_ref": f"{m['prefix']}{m['num']}",
                "prefix": m["prefix"],
                "body": m["body"].strip(),
            }
        elif current and line.strip():
            current["body"] += " " + line.strip()
    if current:
        comments.append(current)

    for c in comments:
        body = c["body"]
        c["status"] = "cleared" if STATUS_CLEARED.search(body) else "remains" if STATUS_REMAINS.search(body) else "new"
        cite = CITATION.search(body)
        c["code_citation"] = cite.group(0) if cite else ""
    return comments


def main(argv):
    out_path = None
    if "--csv" in argv:
        i = argv.index("--csv")
        out_path = argv[i + 1]
        argv = argv[:i] + argv[i + 2:]

    fields = ["file", "cycle_hint", "comment_ref", "prefix", "status", "code_citation", "body"]
    out = open(out_path, "w", newline="") if out_path else sys.stdout
    w = csv.DictWriter(out, fieldnames=fields)
    w.writeheader()
    for arg in argv:
        path = Path(arg)
        text = pdf_text(path)
        cycle = CYCLE.search(path.stem) or CYCLE.search(text)
        for c in parse(text):
            w.writerow({"file": str(path), "cycle_hint": cycle["n"] if cycle else "", **c})
    if out_path:
        out.close()


if __name__ == "__main__":
    main(sys.argv[1:])
