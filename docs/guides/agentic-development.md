# Agentic Development

AI-assisted development is now part of most Flutter teams, but quality depends heavily on context and guardrails.

The kit includes an agent-ready setup designed to keep generated code aligned with your architecture, naming, and testing standards.

## What Agentic Development Means Here

In practice, this means your prompts are backed by repository-native guidance so the agent can make better choices by default:

- architecture and conventions live in `agents.md`
- editor-specific context can live in `.cursor/rules/*.mdc`
- reusable workflows and templates live in `.claude/skills/`

## Structure

```text
├── .cursor/
│   └── rules/
│       ├── architecture.mdc
│       ├── conventions.mdc
│       └── test.mdc
├── .claude/
│   └── skills
└── agents.md
```

## Why This Is Better Than Tool-Only Rules

Tool-specific rules are useful, but they are not enough on their own.

By keeping your core standards in `agents.md` and your repeatable workflows in skills, you can get similar behavior across Cursor, Claude, and Copilot-style agents without rewriting all your guidance for each tool.

## Flutter's Official AI Rules

Flutter also provides official AI rules at [docs.flutter.dev/ai/ai-rules](https://docs.flutter.dev/ai/ai-rules). They are a good baseline and can be layered with the Flutter Kit patterns when you need team-specific constraints.

## Learn more

- MVVM Architecture
