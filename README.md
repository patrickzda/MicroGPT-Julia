# MicroGPT

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://patrickzda.github.io/MicroGPT.jl/dev/)
[![CI](https://github.com/patrickzda/MicroGPT.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/patrickzda/MicroGPT.jl/actions/workflows/CI.yml)
[![Coverage](https://codecov.io/gh/patrickzda/MicroGPT.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/patrickzda/MicroGPT.jl)

MicroGPT.jl is a minimal, educational character-level GPT in pure Julia, comprising a
vector/matrix reverse-mode autograd engine, a tokenizer, a dataset loader, an
Adam optimizer, and the GPT model itself. Inspired by Andrej Karpathy's
[microgpt](https://karpathy.github.io/2026/02/12/microgpt/).

**Requirements:** Julia 1.11

## Getting Started (as a User)

Use this guide if you just want to install MicroGPT.jl and call it from your own code.

### Installation

MicroGPT.jl is not yet registered. Install it directly from GitHub using Julia's
package manager (press `]` in the Julia REPL to enter package mode):

```julia
pkg> add https://github.com/patrickzda/MicroGPT.jl
```

### Train your own model

```julia
using MicroGPT

# Define a small training dataset
docs = ["emma", "olivia", "ava", "isabella", "sophia"]

# Instantiate the tokenizer
tok = Tokenizer(docs)

# Configure the MicroGPT model
config = GPTConfig(;
    vocab_size=tok.vocab_size,
    n_embd=16,
    n_head=2,
    n_layer=2,
    block_size=16,
)

# Instantiate the MicroGPT model
model = GPT(config, tok)

# Train the model
train!(model, docs; num_steps=2000, learning_rate=0.01)

# Generate 20 samples
for _ in 1:20
    println("  ", generate(model; temperature=0.5))
end
```

For further details, see the [GPT documentation](https://patrickzda.github.io/MicroGPT.jl/dev/gpt/).

## Getting Started (as a Developer)

Use this guide if you want to work on MicroGPT.jl itself, read the source, run
the tests against a checkout, or contribute changes.

### Clone the repository

```bash
git clone https://github.com/patrickzda/MicroGPT.jl
cd MicroGPT.jl
```

### Set up the environment

From the repository root, start Julia with an activated project environment:

```bash
julia --project=.
```

Switch to package mode, then enter:

```julia
pkg> instantiate
```

### Run the training example

The runnable [`run.jl`](run.jl) script at the project root trains a small character-level GPT on the names dataset, generates samples, and saves/loads the trained model. From the REPL, run it with:

```julia
include("run.jl")
```

For a step-by-step walkthrough of that script, see the
[Getting started](https://patrickzda.github.io/MicroGPT.jl/dev/getting_started/)
guide in the documentation.

### Run the tests

Execute the following command from the package mode to run all available package tests:

```julia
pkg> test
```

### Terminal-only alternative

The steps above can also be performed without the interactive REPL:

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()' # Instantiate dependencies
julia --project=. run.jl                            # Run example
julia --project=. -e 'using Pkg; Pkg.test()'        # Run tests
```

### Project layout

```
src/
  MicroGPT.jl    # module entry point, exports the public API
  autograd.jl    # vector/matrix reverse-mode autograd (AValue, backward!, record!)
  dataloader.jl  # dataset loading (load_data)
  gpt.jl         # gpt model (layers, train, inference)
  optimizer.jl   # Adam optimizer
  tokenizer.jl   # character-level tokenizer (Tokenizer, encode, decode)
test/            # test suite and fixtures, run via test/runtests.jl
docs/            # documentation sources
profiling/       # code for profiling / benchmark + results
```

## AI / LLM usage

Large language models (e.g. ChatGPT / GitHub Copilot / Claude) were used as
assistants during development of this project, for example to draft and refine
documentation, tests, and parts of the source code. All AI-assisted output was
reviewed and edited by the authors.

## Data

The dataset of names used by `load_data` comes from Andrej Karpathy's
[makemore](https://github.com/karpathy/makemore) project and is redistributed
under the MIT License. A copy bundled with the test suite lives at
`test/names.txt`, with the accompanying license at `test/names.LICENSE`.

<!--
Parts of this README were improved with the help of an AI assistant.
-->