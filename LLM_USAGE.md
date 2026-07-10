
# LLM Usage Overview

LLMs and coding assistants were used for selected research, drafting, generation, and review during development. All AI-assisted output was reviewed, edited, and validated by the authors before being included in the project.

## Task categories

- **RESEARCH:** Conceptual or technical investigation, including mathematical derivations.
- **DRAFTING:** Suggestions or preliminary drafts subsequently implemented or substantially edited by the authors.
- **GENERATION:** Direct generation of code or documentation subsequently reviewed and validated by the authors.

## Usage record

| Tool | Task | Files | Description | Reference |
| ---- | ---- | ----- | ----------- | --------- |
| ChatGPT | DRAFTING | README.md | Improvement ideas for the README | https://chatgpt.com/share/6a510b7c-7114-83eb-a88c-626a1ad05485 |
| ChatGPT | GENERATION | autograd.jl | Generated docstrings for `linear`, `softmax` and `rmsnorm` | https://chatgpt.com/share/6a3fcb2d-0ecc-83eb-9e40-c00c1661c295 |
| ChatGPT | RESEARCH | autograd.jl | Calculated rmsnorm derivation | https://chatgpt.com/share/6a3d41a0-445c-83eb-ba53-876e591115d8 |
| Claude Code | GENERATION | optimizer_tests.jl | `adam_reference` test generation | No public transcript |
| OpenAI Codex | DRAFTING | gpt.jl, gpt_tests.jl | Found dimension_mismatch error case | No public transcript |
| OpenAI Codex | DRAFTING | LLM_USAGE.md | Partially helped compiling the project's LLM usage | No public transcript |

## Attribution scope

The entries above document directly identifiable uses of LLMs and coding assistants. OpenAI Codex / Claude Code was additionally used for project-wide review after code review milestones. Suggestions from these review sessions were evaluated and, where appropriate and not otherwise stated, implemented manually by the authors.