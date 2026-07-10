using Test
using MicroGPT

@testset "gpt.jl" begin
    # A tiny GPT over a small vocab
    docs = ["abc", "bcd", "abcd"]
    tok = Tokenizer(docs)
    cfg = GPTConfig(vocab_size=tok.vocab_size, n_embd=8,
        n_head=2, n_layer=2, block_size=16)
    model = GPT(cfg, tok)

    # Invalid configurations are rejected early with a clear error
    @test_throws ArgumentError GPTConfig(vocab_size=tok.vocab_size, n_embd=10, n_head=3, n_layer=1, block_size=16)   # n_embd not divisible by n_head
    @test_throws ArgumentError GPTConfig(vocab_size=tok.vocab_size, n_embd=8,  n_head=2, n_layer=0, block_size=16)   # non-positive field
    
    # The error case vocab_size == tokenizer.vocab_size was found and drafter with the help of an AI agent:
    wrong_vocab_size_config = GPTConfig(vocab_size=tok.vocab_size + 1, n_embd=8, n_head=2, n_layer=2, block_size=16)
    @test_throws DimensionMismatch GPT(wrong_vocab_size_config, tok) # Mismatch between config's and tokenizer's vocab_size

    # Check the dimensions
    @test head_dim(cfg) == 4
    @test size(model.state_dict["wte"].data) == (cfg.vocab_size, cfg.n_embd)
    @test length(model.params) == length(model.state_dict)
    for li in 1:cfg.n_layer
        @test haskey(model.state_dict, "layer$li.attn_wq")
    end

    # Forward pass returns one logits AValue of length vocab_size
    keys, values = MicroGPT.kv_cache(cfg), MicroGPT.kv_cache(cfg)
    logits = model(1, 1, keys, values)
    @test length(logits.data) == cfg.vocab_size
    @test all(isfinite, logits.data)

    # Training on an empty corpus fails with a clear error
    @test_throws ArgumentError train!(model, String[]; num_steps=1, verbose=false)

    # A few training steps
    train!(model, docs; num_steps=10, verbose=false)
    @test all(isfinite, model.state_dict["wte"].data)

    # Non-positive temperatures are rejected
    @test_throws ArgumentError generate(model; temperature=0.0)
    @test_throws ArgumentError generate(model; temperature=-1.0)

    # generate returns a decodable String of at most block_size chars
    out = generate(model; temperature=0.5)
    @test out isa String
    @test length(out) <= cfg.block_size
    @test all(c -> c in tok.uchars, out)

    # save_model / load_model
    path = tempname()
    save_model(path, model)
    m2 = load_model(path)
    @test m2.config == model.config
    for (name, t) in model.state_dict
        @test m2.state_dict[name].data ≈ t.data
    end

end
