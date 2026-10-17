# <Repo Name>

**<One line: what these skills do, for whom>**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Format](https://img.shields.io/badge/format-SKILL.md-orange)](https://agentskills.io/specification)
[![Tooling](https://img.shields.io/badge/tooling-stdlib_only-success)](scripts/skills_tool.py)

> [!IMPORTANT]
> **Principle: <the single sentence every skill in this repo must obey.>**

<Two or three sentences: what problems the skills solve, what they are grounded in (official docs / authoritative sources), and that they follow the open [Agent Skills](https://agentskills.io/specification) format. Note which agents they work in.>

## 🧩 Skills

<!-- catalogue:begin -->
| Skill | Purpose |
|---|---|
| [`example-skill`](skills/example-skill/SKILL.md) | Placeholder skill demonstrating this repository's skill format: the gate, steps, hard rule phrasing and reference layout. |
<!-- catalogue:end -->

## 🚀 Usage

> [!TIP]
> **You never need to memorise skill names.** Just describe the problem in plain words; the router (if you have one) or the descriptions route automatically.

| Just say… | What you get |
|---|---|
| `<short plain phrase>` | <what happens> |

## 📦 Install

> [!TIP]
> Install the router skill **plus every sibling skill it links to**; routers reference siblings by relative path.

Copy or symlink the `skills/` subfolders you want into your agent's skills directory (for Claude Code: `~/.claude/skills/` or a project's `.claude/skills/`; other agents: their own SKILL.md discovery path).

## ✅ Validate

```bash
python scripts/skills_tool.py check
```

Checks: frontmatter, name/folder match, description length and trigger, body under 500 lines, relative links resolve, at least 3 eval cases per skill, and catalogue freshness. Stdlib only, no dependencies.

## 🗂️ Layout

<details>
<summary>Repository layout</summary>

```
skills/<name>/SKILL.md      one folder per skill (+ references/ where needed)
templates/skill-template/   authoring template; templates/AGENTS-template.md is the base agent rules
evals/cases.jsonl           3+ behavioural cases per skill
scripts/skills_tool.py      validate, regenerate catalogue (stdlib only)
.github/workflows/          CI runs `skills_tool.py check` (free on public repos)
AGENTS.md                   agent-facing rules for this repo
SETUP.md                    fill-in checklist; delete when done
```

</details>

## 📌 Status and limits

> [!NOTE]
> - <Known limits, each dated, mirroring the "Known deliberate states" section of AGENTS.md.>
> - Licensed under MIT (see [LICENSE](LICENSE)).

---

<div align="center">

**⚡ Built on the [Agent Skills](https://agentskills.io) open format**

</div>
