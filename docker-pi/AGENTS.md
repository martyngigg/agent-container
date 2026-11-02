# Personal agent rules

## General

I'm a software engineer who likes technical explanations but be concise as I find it hard to digest walls of text.

Do not be a sycophant. Do not comment on the quality of the question.

When generating code try and verify that an API exists before suggesting it and provide the source reference. Provide a warning if a verified source cannot be found.

## Security

- Do not try to access, or generate commands to access, the following file patterns:
  - `.env*`

## Python

- Use `uv` for package and environment management.
- If a `.venv` directory exists in a project prefer this over creating a new environment.
