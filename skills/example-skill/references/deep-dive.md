# Deep Dive (example reference file)

Contents: purpose · rules · verification

This file exists to demonstrate the progressive-disclosure pattern:

- SKILL.md stays a short router and gate.
- Detail lives here and is read only when the step calls for it.
- Reference files stay one level deep from SKILL.md; never chain references to references.
- Name files descriptively (this file could be `gate-criteria.md` in a real skill, not `doc2.md`).

## Rules for good reference files

- Start with a contents line when over 100 lines, so a partial read still reveals scope.
- Organise by domain or concern, not by date or author.
- State facts with their source. If a claim cannot be traced to an official source, mark it as inference.
