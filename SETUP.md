# Setup checklist

This repo is a scaffold copied from the skills-repo template. Work top to bottom, then delete this file. Nothing below is optional unless marked otherwise.

## 1. Name and identity

- [ ] Update `README.md`, keeping the template's section order and style: render the repo name with FIGlet's ANSI Shadow font only, then add the title and one-liner, badges (set OWNER, REPO and the skill count), principle in the [!IMPORTANT] callout, intro paragraph, "How they fit together" diagram (delete for a single-skill repo), usage phrases, status and footer links. Split long names across lines as needed and centre a shorter line for a balanced banner. Keep local setup files out of the public layout block.
- [ ] Update `LICENSE`: replace `<copyright holder>`
- [ ] `AGENTS.md`: the general rules are identical in every repo by design; do not reword them. Adapt only two sections to the new repo: the **Repository map** (canonical sources, generated artefacts, editing rules, each with a reason) and **Known deliberate states** (delete the placeholder line). The verification command `python scripts/skills_tool.py check` is already correct because the template ships the same validator

## 2. Content

- [ ] In the new repo, add `/templates/` to `.gitignore`. The template repo keeps this folder tracked because it contains the starter skill. Keep `/SETUP.md` and `/reference-content/` ignored as configured. Keep all setup files locally, but remove them from the Git index before the first public commit with `git rm --cached --ignore-unmatch SETUP.md templates reference-content`. The validator fails if they are tracked or not ignored.
- [ ] Build the reference content first (pipeline in `reference-content/README.md`): drop originals into `raw/`, list project-specific names in `strip-terms.txt`, convert each item into a general-purpose file in `sources/`, and fill in `BRIEF.md`
- [ ] Build the skills from `BRIEF.md` and `sources/` only, never from `raw/`
- [ ] Design the skill set first: write the list of skills, their scope boundaries, and which skill owns each nearby topic. Scope discipline beats breadth: prefer curation over accumulation
- [ ] Write the first real skill from `templates/skill-template/SKILL.md`
- [ ] Write its description as a trigger contract: what it does, when to use it, keywords users type, and negative triggers for topics owned by sibling skills
- [ ] If skills share constraints or a "voice", put them in one references file and link it from skills, never copy it
- [ ] Add 3+ behavioural cases per skill to `evals/cases.jsonl` (real queries, expected behaviours, at least one refusal case)
- [ ] Replace the starter cases and delete `skills/example-skill/`
- [ ] Inspect `resources/agents/` after the skills and router names are final. If no definitions were supplied, install none and leave agent folders and dispatch instructions out. Supply at most two native profiles per host: one main workflow agent named `<router-skill>-workflow`, plus one focused helper. Put planning, implementation, testing, and review modes in named sections of the main agent rather than creating one agent per skill. Use a `shared-` helper only when the same definition is reused across repos. Wire the router skill to the main workflow agent and describe when to use the helper. Other hosts receive the skills only. Preserve `resources/agents/` in the shipped repo so the installer can copy profiles into a project.

## 3. Register

```bash
python scripts/skills_tool.py catalogue   # refreshes the README table
python scripts/skills_tool.py check       # must end: ok (N skills), with no "ship checks skipped" note
```

## 4. Ship

- [ ] `git init`, commit, add the origin remote, push (repo name per 1)
- [ ] Make the repository **public**: CI minutes are free on public repos and billed on private ones
- [ ] Enable Actions in Settings; the workflow runs on pushes to `main` and PRs
- [ ] Set the GitHub "About" description and add topics (`agent-skills` at minimum)
- [ ] Keep the setup files on your computer for future maintenance. Confirm `python scripts/skills_tool.py check` passes before publishing; it confirms setup-only files are ignored and absent from the Git index.

## 5. Do not

- Do not hand-edit the README catalogue between the markers
- Do not add per-platform manifests until a platform needs one
- Do not import project-specific facts into skills; skills read a project's own architecture at runtime
