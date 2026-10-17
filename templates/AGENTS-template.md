# AGENTS.md (base template)

Copy this file into any new repository as `AGENTS.md`, fill the `<placeholders>`, and delete nothing else. v1, extracted 2026-10-17 from the conventions proven in this repository and comparable skills repositories.

Standing instructions for AI coding agents working in this repository. Read this file as policy, not suggestions. Every rule carries its reason: when a situation is not covered, generalise from the reason rather than guessing.

## Ground truth

- Never speculate about code or files you have not opened. If asked about a file, read it before answering. Reason: confident claims about unread files are indistinguishable from truth in review.
- File and directory names are not reliable evidence of what something does. Reason: naming drifts; contents do not.
- Documentation describes intent, not implementation state. Verify in the actual files before reporting status. Reason: docs lag behind code in every repo.

## Scope of changes

- Make the smallest correct change that satisfies the task. Reason: every extra line is extra review burden and extra risk.
- Concretely, do not:
  - Add docstrings, comments, or type annotations to code you did not change.
  - Add error handling, fallbacks, or validation for scenarios that cannot happen; validate at system boundaries only.
  - Create helpers or abstractions for one-time operations, or design for hypothetical future requirements.
  - Refactor or "improve" anything beyond what the task asked.
- Prefer editing the source of a rule over editing a restatement of it. Reason: copies drift.

## Accuracy and honesty

- Separate observed fact from inference, and mark anything uncertain.
- If a check cannot be run, say so explicitly instead of reporting success.
- Do not claim completion stronger than the evidence; state exactly what was checked.
- Solve the problem, not the test. Checks and evaluations measure quality; they do not define the solution. If a check is wrong, say so rather than working around it.

## Verification

- Before reporting any change done, run the verification command declared here. This repo: `<fill in the repo's check command>`. Reason: a repo with no mandatory check drifts silently.
- If one check cannot prove the change works, name the second check and run it. Reason: any single check is necessary-but-not-sufficient for something.

## Irreversible and shared actions

- Proceed freely for local, reversible actions (editing files, running checks).
- Ask first for anything destructive, hard to undo, or visible to others: deleting branches or history, force-pushes, changing visibility, pushing code, commenting on issues, sending messages. Reason: damage in a shared or public space cannot be recalled.
- Never bypass safety checks or discard unfamiliar files that may be work in progress. Reason: obstacles do not justify shortcuts.

## Known deliberate states (dated)

- Record deliberate temporary states (disabled checks, placeholder data, config overrides) here, each with a date and the reason. If something breaks and traces back to one, that is the cause, not a new bug. Reason: undocumented temporary states get "fixed" into real problems.

## Anti-drift close-out

- Before reporting done, confirm the change introduced no new local convention. If it did, move it into the shared source or record the approved exception. Reason: un-owned variations are how a standard silently dissolves.

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

## Repository map (repo-specific, fill this in)

- `<canonical sources, generated artefacts that must not be hand-edited, and editing rules, each with its reason>`
