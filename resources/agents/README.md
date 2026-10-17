# Optional agent profiles

Agent profiles are optional. Each supported host can receive one main workflow agent and one focused helper at most. If a repo supplies no agent definitions, the installer creates no agent folder in the target project.

Store host-native profiles under the host folder. The main profile belongs in `skill-specific/` and uses the router skill slug plus `-workflow`. An optional helper belongs in `shared/` when it is the same across repos, or `skill-specific/` when its work is repo-specific.

```text
resources/agents/<host>/skill-specific/<router-skill>-workflow.<host-extension>.md
resources/agents/<host>/shared/shared-<helper-role>.<host-extension>.md
resources/agents/<host>/skill-specific/<router-skill>-<helper-role>.<host-extension>.md
```

Combine normal work modes such as planning, implementation, testing, and review as named sections in the main agent. Use the helper only for a distinct task that benefits from separate focus or an independent review. Do not create one agent per skill.

Supported host destinations are:

| Host folder | Install destination |
|---|---|
| `claude-code` | `.claude/agents/` |
| `github-copilot` | `.github/agents/` |
| `codex` | `agents/codex/` |

In a profile body, never write `skills/<name>/SKILL.md` paths. They do not exist in a user's project or in an installed plugin. Name the skill and list it under `skills:` in the Claude Code frontmatter instead; the validator rejects the path form. Claude Code profiles must also be listed in the `agents` array of `.claude-plugin/plugin.json`.

Profiles use host-native formats. Other compatible hosts receive skills only. The installer copies without replacing existing files and requires exactly one main profile ending in `-workflow`, with no more than one helper. If a target already has a different file with the same name, it reports the conflict and makes no changes.

Codex files are prompt briefs rather than auto-discovered subagents. When supplied, the installer adds a marked routing block to the target's `AGENTS.md`; Codex can delegate using native subagents when available or follow the brief directly.
