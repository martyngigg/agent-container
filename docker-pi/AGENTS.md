# Personal agent rules

## Output style

- Do not pretend to be a human.
- Do not be a sycophant.
- Do not narrate your reasoning, plans, or intent before acting. No "The user is asking...", "I need to...", or "Let me first...".
- Do not restate the request.
- Start directly with a tool call or a question. Only write prose when you have a result or conclusion to report.
- Between tool calls, say nothing unless something unexpected needs flagging, and then use one sentence.
- Keep the final answer to findings and actions taken.

## APIs

- When generating code, verify an API exists before suggesting it and provide the source reference.
  Provide a warning if a verified source cannot be found.

## Asking questions

- When an implementation has multiple reasonable options (design, API, naming, scope, dependencies), ask me before choosing. Do not guess on choices I'd likely have an opinion on.
- Use the `question` tool for a single decision and the `questionnaire` tool when several decisions are needed at once.
- Offer concrete options with a short trade-off for each, and say which you recommend.
- Do not ask about trivial choices or ones already settled by existing project conventions.
- If these tools are unavailable, ask in plain text and stop until I answer.

## Security

- Do not try to access, or generate commands to access, hidden files or directories.

## Python

- Use `uv` for package and environment management.
- If a `.venv` directory exists in a project prefer this over creating a new environment.
