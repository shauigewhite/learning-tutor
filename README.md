# Learning Tutor - Claude Code Plugin

An AI-powered personal tutor plugin for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Turns Claude into an adaptive learning companion with structured pedagogy, spaced repetition, and persistent learner profiles.

## Features

- **5 learning modes** - System learning, concept explanation, quick review, quiz, and study planning
- **Adaptive teaching** - Automatically adjusts depth and style based on your proficiency level (3 teaching styles: progressive, Socratic, structured)
- **Pre/post testing** - Assesses knowledge before and after each session with generative questions (not multiple choice)
- **Spaced repetition** - Tracks review dates per knowledge point, fights the forgetting curve across sessions
- **Learner profiles** - Persistent memory files track your progress, proficiency levels (1-5), and learning preferences
- **Teaching guardrails** - Hard stops after questions (no accidental hints), anti-rationalization defenses, progressive scaffolding
- **Credibility safeguards** - Confidence labeling, web search verification for low-confidence content
- **Bilingual** - Works in Chinese (default) and English

## Quick Start

### Install

Add the following to your `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "learning-tutor": {
      "source": {
        "source": "settings",
        "name": "learning-tutor",
        "plugins": [
          {
            "name": "learning-tutor",
            "source": {
              "source": "github",
              "repo": "shauigewhite/learning-tutor"
            }
          }
        ],
        "owner": { "name": "shuaige white" }
      }
    }
  },
  "enabledPlugins": {
    "learning-tutor@learning-tutor": true
  }
}
```

Then restart Claude Code. The plugin will be automatically downloaded from GitHub.

### Use

```
> 教我 Python 装饰器
> teach me how attention mechanism works in Transformers
> 复习
> quiz me on Python
> 帮我做机器学习的学习计划
```

You can also invoke it directly:

```
> /learning-tutor Python decorators
```

## How It Works

```
User: "teach me X"

Phase 0: Init      → Read learner profile, create study plan, set up progress tracking
Phase 1: Pre-test  → 3-5 diagnostic questions → WAIT for answers
Phase 2: Teaching   → Targeted explanations for weak areas → WAIT for paraphrase
Phase 3: Post-test → 3-5 generative questions → WAIT for answers
Phase 4: Wrap-up   → Update profile, schedule next review, show progress visualization
```

The tutor **never moves forward without your response** - every question is followed by a hard stop.

## Learner Profiles

The plugin stores your learning data in Claude Code's memory system:

```
memory/
├── learner-profile.md          # Master profile: background, preferences, domain index
└── learn/
    ├── python.md               # Domain profile: knowledge points, proficiency levels
    ├── python-plan.md          # Study plan: curriculum, progress tracking
    ├── machine-learning.md
    └── machine-learning-plan.md
```

Each file uses Claude Code's standard memory format (with frontmatter), so your profiles are automatically loaded into context when you mention a related topic.

### Proficiency Levels

| Level | Meaning | Review Interval |
|-------|---------|-----------------|
| 1 | No knowledge | - |
| 2 | Basic understanding | 3 days |
| 3 | Can explain | 7 days |
| 4 | Can apply | 14 days |
| 5 | Mastered | 30 days |

## Teaching Styles

The tutor automatically selects a style based on your pre-test results:

| Style | When | Approach |
|-------|------|----------|
| **Progressive** | Level 1-2 (beginner) | Step-by-step, analogies, build from basics |
| **Socratic** | Level 2-3 (intermediate) | Guided questions, predict-observe-reflect |
| **Structured** | Level 3-4 (advanced) | Frameworks, systematic overview, deep dives |

## Plugin Structure

```
learning-tutor/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── learning-tutor/
│       ├── SKILL.md                 # Core skill definition
│       ├── teaching-styles.md       # 3 pedagogical approaches
│       ├── teaching-guardrails.md   # Quality control rules
│       ├── credibility.md           # Accuracy safeguards
│       ├── response-formats.md      # Output templates
│       ├── profile-schema.md        # Learner profile format
│       ├── plan-schema.md           # Study plan format
│       └── examples.md              # Full interaction example
├── hooks/
│   ├── hooks.json                   # Post-session reminder hook
│   └── scripts/
│       └── check-learning-update.sh
└── README.md
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI or Desktop App

## License

MIT
