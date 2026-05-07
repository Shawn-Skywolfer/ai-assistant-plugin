# AI Assistant Plugin for Super Productivity

An OpenAI-powered AI assistant plugin that lets you manage tasks, projects, and tags via natural language chat.

## Features

- 🤖 Chat with AI to manage your tasks
- 📋 Create, update, delete tasks
- 📁 Manage projects and tags
- ⏱️ Start/stop timers, set current task
- 🔄 Agentic tool calling — AI auto-executes operations
- ⚙️ Configurable: API key, base URL, model, temperature

## Installation

1. Download the latest `ai-assistant-plugin.zip` from Releases
2. Open Super Productivity → Settings → Plugins → Load unpacked
3. Select the zip file
4. Click the ⚙️ button in the plugin panel to configure your API key

## Configuration

Click the ⚙️ button in the top-right corner of the plugin panel:

| Field | Default | Description |
|-------|---------|-------------|
| API Key | *(required)* | Your OpenAI API key |
| Base URL | `https://api.openai.com/v1` | OpenAI-compatible endpoint |
| Model | `gpt-4o` | Model name |
| Max Tokens | `4096` | Max response tokens |
| Temperature | `0.7` | Response creativity (0-2) |

Supports any OpenAI-compatible API (DeepSeek, Claude via proxy, local models, etc.)

## Supported Operations

| Category | Actions |
|----------|---------|
| Tasks | Create, update, delete, list, set as current, start timer |
| Projects | Create, update, list, switch context |
| Tags | Create, update, list |
| Layout | Show add task bar, toggle notes |

## Development

```
packages/
├── manifest.json        # Plugin metadata
├── config-schema.json   # Config schema for host UI
├── plugin.js            # Background: register buttons/shortcuts
├── index.html           # Chat UI + OpenAI integration
└── icon.svg             # Plugin icon
```

## Requirements

- Super Productivity v13.0.0+
- OpenAI-compatible API key

## License

MIT
