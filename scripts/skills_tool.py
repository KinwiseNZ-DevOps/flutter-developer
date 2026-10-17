#!/usr/bin/env python3
"""Validate skills and keep the README catalogue in sync. Stdlib only.

  python scripts/skills_tool.py validate     # exit 1 on any problem
  python scripts/skills_tool.py catalogue    # rewrite README catalogue block
  python scripts/skills_tool.py check        # validate + fail if catalogue is stale
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"
README = ROOT / "README.md"
EVALS = ROOT / "evals" / "cases.jsonl"
BEGIN, END = "<!-- catalogue:begin -->", "<!-- catalogue:end -->"
NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
LINK_RE = re.compile(r"\]\((?!https?://|#|mailto:)([^)\s]+)\)")
MAX_BODY_LINES, MAX_DESC, MAX_NAME, MIN_EVALS = 500, 1024, 64, 3


def parse(path):
    text = path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    if not m:
        return None, text
    fm, key, folded = {}, None, False
    for line in m.group(1).splitlines():
        top = re.match(r"^([A-Za-z_-]+):\s*(.*)$", line)
        if top and not line.startswith(" "):
            key, val = top.group(1), top.group(2).strip()
            folded = val in (">", "|")
            fm[key] = "" if folded else val.strip("\"'")
        elif key and line.startswith(" "):
            fm[key] = (fm[key] + " " + line.strip()).strip()
    return fm, m.group(2)


def skill_dirs():
    return sorted(p for p in SKILLS.iterdir() if p.is_dir())


def validate():
    errors = []
    names = {p.name for p in skill_dirs()}
    for d in skill_dirs():
        f = d / "SKILL.md"
        if not f.exists():
            errors.append(f"{d.name}: missing SKILL.md")
            continue
        fm, body = parse(f)
        if fm is None:
            errors.append(f"{d.name}: no frontmatter")
            continue
        name, desc = fm.get("name", ""), fm.get("description", "")
        if name != d.name:
            errors.append(f"{d.name}: name '{name}' != folder")
        if not NAME_RE.match(name) or len(name) > MAX_NAME:
            errors.append(f"{d.name}: invalid name")
        if not desc or len(desc) > MAX_DESC:
            errors.append(f"{d.name}: description empty or >{MAX_DESC} chars ({len(desc)})")
        if "<" in desc or ">" in desc:
            errors.append(f"{d.name}: description contains angle brackets")
        if not re.search(r"\bUse\b|\bUse when\b", desc):
            errors.append(f"{d.name}: description lacks a 'Use ...' trigger")
        lines = len(body.splitlines())
        if lines > MAX_BODY_LINES:
            errors.append(f"{d.name}: body {lines} lines > {MAX_BODY_LINES}")
        for md in [f, *d.rglob("references/*.md")]:
            for target in LINK_RE.findall(md.read_text(encoding="utf-8")):
                path = target.split("#")[0]
                if path and not (md.parent / path).resolve().exists():
                    errors.append(f"{md.relative_to(ROOT)}: broken link {target}")
    if EVALS.exists():
        counts = {n: 0 for n in names}
        for i, line in enumerate(EVALS.read_text(encoding="utf-8").splitlines(), 1):
            if not line.strip():
                continue
            try:
                case = json.loads(line)
            except json.JSONDecodeError:
                errors.append(f"evals/cases.jsonl:{i}: invalid JSON")
                continue
            for s in case.get("skills", []):
                if s in counts:
                    counts[s] += 1
                else:
                    errors.append(f"evals/cases.jsonl:{i}: unknown skill {s}")
            if not case.get("query") or not case.get("expected_behavior"):
                errors.append(f"evals/cases.jsonl:{i}: needs query and expected_behavior")
        for n, c in counts.items():
            if c < MIN_EVALS:
                errors.append(f"{n}: {c} eval cases < {MIN_EVALS}")
    else:
        errors.append("evals/cases.jsonl missing")
    return errors


def build_catalogue():
    rows = ["| Skill | Purpose |", "|---|---|"]
    for d in skill_dirs():
        fm, _ = parse(d / "SKILL.md")
        desc = fm["description"]
        first = re.split(r"(?<=\.)\s", desc, maxsplit=1)[0]
        rows.append(f"| [`{d.name}`](skills/{d.name}/SKILL.md) | {first} |")
    return "\n".join(rows)


def catalogue(write):
    text = README.read_text(encoding="utf-8")
    pat = re.compile(re.escape(BEGIN) + r".*?" + re.escape(END), re.S)
    new = f"{BEGIN}\n{build_catalogue()}\n{END}"
    if not pat.search(text):
        return ["README.md: catalogue markers missing"]
    if pat.sub(lambda _: new, text) == text:
        return []
    if write:
        README.write_text(pat.sub(lambda _: new, text), encoding="utf-8")
        return []
    return ["README.md: catalogue stale; run `python scripts/skills_tool.py catalogue`"]


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "check"
    errors = []
    if cmd in ("validate", "check"):
        errors += validate()
    if cmd == "catalogue":
        errors += catalogue(write=True)
    if cmd == "check":
        errors += catalogue(write=False)
    if cmd not in ("validate", "catalogue", "check"):
        print(__doc__)
        return 2
    for e in errors:
        print("ERROR:", e)
    print(f"{cmd}: {'FAILED' if errors else 'ok'} ({len(skill_dirs())} skills)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
