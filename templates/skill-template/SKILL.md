---
name: <skill-name>
description: >
  <What it does, third person.> Use when <trigger conditions and keywords users
  would type>. Do not use for <nearby topics owned by another skill>.
---

# Title

One-paragraph stance: what is frozen, what is flexible.

## Gate

| Situation | Action |
|---|---|
| Not worth acting on | Leave it alone, say why |
| Real, evidenced case | Continue |

## Steps

1. **Detect** (concrete search patterns or tool output)
2. **Fix** (least invasive option first; minimal code example)
3. **Verify** (what to measure, compared like for like)

## Agent dispatch (include only when agent profiles are installed)

Use the repo's main `<router-skill>-workflow` agent when available. It selects a named mode for this request and follows this skill alongside the router's workflow. Use the optional helper only for its stated focused task. If no profile is available or the host cannot delegate, follow this skill directly.

## Hard rules

- Rule. Mechanism: symptom, cause, fix.

## References

Link reference files one level deep, e.g. [topic.md](references/topic.md) when this folder gains a references/ file.

## Next

Link sibling skills by relative path when they exist: `[sibling-name](../sibling-name/SKILL.md)`.

Do not link a sibling that does not exist in this repository; the validator fails on dangling links.
