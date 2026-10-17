# AGENTS.md

Agent map and standing rules for this repository. Read this file as policy, not suggestions. Every rule carries its reason: when a situation is not covered, generalise from the reason rather than guessing.

## Ground truth

- Never speculate about code or files you have not opened. If asked about a file, read it before answering. Reason: confident claims about unread files are indistinguishable from truth in review.
- File and directory names are not reliable evidence of what something does. Reason: naming drifts; contents do not.
- Documentation describes intent, not implementation state. Verify in the actual files before reporting status. Reason: docs lag behind code in every repo.

## Scope of changes

- Make the smallest correct change that satisfies the task. Reason: every extra line is extra review burden and extra risk. Concretely, do not:
  - Add docstrings, comments, or type annotations to content you did not change.
  - Add error handling, fallbacks, or caveats for scenarios that cannot happen (e.g. already covered by the validator).
  - Create helpers or abstractions for one-time operations, or design for hypothetical requirements.
  - Refactor or "improve" anything beyond what the task asked.
- Prefer editing the source of a rule over editing a restatement of it. Reason: copies drift.

## Accuracy and honesty

- Separate observed fact from inference, and mark anything uncertain.
- If a check cannot be run, say so explicitly instead of reporting success.
- Do not claim completion stronger than the evidence; state exactly what was checked.
- Solve the problem, not the test. Behavioural cases measure quality; they do not define it. If a case or check is wrong, say so rather than working around it.

## Verification

Before reporting any change done, run:

```bash
python scripts/skills_tool.py check
```

Checks: frontmatter, name/folder match, description length and trigger, body under 500 lines, relative links resolve, at least 3 eval cases per skill, catalogue not stale.

- The tool is necessary but not sufficient for content quality. For new or changed skill body text, also re-read the changed SKILL.md end to end. Reason: a validator checks structure; only reading checks that the instructions still make sense.

## Repository map (fill in as this repo takes shape)

- `skills/<name>/SKILL.md`: the only source of skill content. Folder name equals frontmatter `name`.
- `templates/skill-template/SKILL.md`: the authoring template every new skill starts from. `<add repo-specific canonical sources, generated artefacts that must not be hand-edited, and editing rules, each with a reason>`
- Custom to this repo: `<e.g. shared guardrails file paths, router links, doc-source rules>`

## Irreversible and shared actions

- Proceed freely for local, reversible actions: editing files, running checks, regenerating the catalogue.
- Ask first for anything destructive, hard to undo, or visible to others: deleting branches or history, force-pushes, changing repository visibility, pushing to shared sources. Reason: damage in a public repo cannot be recalled.

## Known deliberate states (dated)

- CUT: `<record deliberate temporary states here, each with a date and a reason>`

## Anti-drift close-out

Before reporting done, confirm the change introduced no new local convention (a new section shape, a new file pattern, a divergent description style). If it did, either move it into the shared source or record the approved exception here. Reason: un-owned variations are how a standard silently dissolves.

## Close-out report

Finish every task with these five points, in this order:

1. What changed and why
2. Files changed
3. Validation run, and the result
4. Validation skipped, and why
5. Residual risks

## Writing style

- Short by default; say the thing, then stop.
- Plain language a non-technical reader could follow aloud.
- No padding, no restating the question, no caveats that carry no information.
- No em dashes anywhere in prose or code comments. Use a hyphen, a comma, or rewrite the sentence.
