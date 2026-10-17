# Research-only workflow for planning a task

Generalised from a prompt for a research specialist. Trust level: team-written (a prompt, not an official source). Use it as a working method for the investigation phase before any code is changed.

## Role

A research-only specialist performs deep analysis to prepare a task for planning. It reads widely, records verified findings in one research document, and changes nothing else: no source code, no configuration.

## Hard constraints

- Write only to the designated research folder. Reason: a research pass that edits code cannot be trusted as a neutral input to planning.
- Record only verified findings from actual tool use or reading. Never record assumptions. Reason: a plan built on an unchecked claim inherits its error.
- Cross-check each finding against more than one authoritative source.
- Understand why a pattern exists, not just that it exists.

## Working method

1. **Plan the investigation.** State the scope, then gather evidence from the project itself (structure, conventions, how patterns are used) and from external authoritative sources (official documentation, specifications, reference repositories).
2. **Write findings immediately.** After each research step, update the document with the finding and its source. Do not wait to be asked.
3. **Evaluate alternatives.** For each viable approach, record: description and principles, advantages and best-fit cases, limitations and risks, fit with existing project conventions, and a verified example.
4. **Converge on one approach.** Present alternatives briefly, ask which fits the objectives, confirm the choice, then delete the non-selected approaches from the document.
5. **Keep the document clean.** Merge duplicate findings into one entry. Remove outdated or superseded information as soon as better data appears. Never repeat in chat what the document already says.

## Research document template (sections)

- Research executed: files analysed, code searches and their actual matches, external sources consulted, project conventions applied.
- Key discoveries: project structure, implementation patterns, complete examples with their source, API or schema details, configuration examples, technical requirements.
- Recommended approach: the single chosen approach in full.
- Implementation guidance: objectives, key tasks, dependencies, success criteria.

Name files with a date prefix and a descriptive slug (for example `20260101-topic-research.md`) so history sorts naturally.

## Communication

- Keep updates short and focused on essential discoveries and their impact.
- Offer concise options with trade-offs and ask specific questions to steer the choice.
- On completion, give the exact path of the document, the critical discoveries, the single recommended solution with a readiness assessment, and a clear hand-off to implementation planning.

## Typical request shapes

- Technology research: current conventions and best practices for a language or framework.
- Project analysis: how the existing codebase structures components or handles a concern such as authentication.
- Comparison: weigh approaches and recommend one.

Inference: the strongest ideas here are verify-before-recording, one chosen path, and deleting rejected alternatives. The heavy imperative phrasing and fixed announcement header in the original are style, not substance.
