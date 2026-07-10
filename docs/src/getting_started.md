```@meta
CurrentModule = MicroGPT
```

# Getting started

## Installation

MicroGPT.jl is not yet registered. Install it directly from GitHub using Julia's
package manager (press `]` in the REPL to enter package mode):

```julia
pkg> add https://github.com/patrickzda/MicroGPT.jl
```

## Training a GPT

The snippet below trains a small character-level GPT on the names dataset,
generates samples, and saves/loads the trained model. It is the same runnable
[`run.jl`](https://github.com/patrickzda/MicroGPT.jl/blob/main/run.jl) script at
the project root, which you can execute with `julia --project=. run.jl`.

Start by loading the dataset and building a tokenizer over it. On the first run
`load_data` downloads the corpus to `input.txt`; the [`Tokenizer`](@ref) then
derives its vocabulary from the characters that appear in the documents.

```julia
using MicroGPT

docs = load_data("input.txt")
tokenizer = Tokenizer(docs)
println("num docs: $(length(docs)) | vocab size: $(tokenizer.vocab_size)")
```

Next, describe the model with a [`GPTConfig`](@ref) and instantiate the
[`GPT`](@ref). The vocabulary size must come from the tokenizer; the remaining
fields control the size of the network.

```julia
config = GPTConfig(
    vocab_size = tokenizer.vocab_size,
    n_embd     = 16,
    n_head     = 4,
    n_layer    = 1,
    block_size = 16,
)
model = GPT(config, tokenizer)
```

Train the model on the documents with [`train!`](@ref):

```julia
train!(model, docs; num_steps = 2000, learning_rate = 0.01)
```

Once trained, sample from the model with [`generate`](@ref). Lower temperatures make the output more conservative, higher temperatures more varied:

```julia
println("\nSamples:")
for _ in 1:20
    println("  ", generate(model; temperature = 0.5))
end
```

Finally, persist the trained model and load it back later:

```julia
save_model("model.jls", model)
new_model = load_model("model.jls")
```

## Running the tests

When MicroGPT.jl is installed as a package, run its test suite through the package manager:

```julia
pkg> test MicroGPT
```

Or, equivalently, from a script or the REPL:

```julia
using Pkg
Pkg.test("MicroGPT")
```

## Where to go next

See the [Tokenizer](@ref), [Autograd](@ref) and [Optimizer](@ref) guides for a deeper look at the building blocks of the [GPT](@ref) model, and the [API reference](@ref) for the full list of exported functions.
