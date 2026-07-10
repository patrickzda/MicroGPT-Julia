using Test
using MicroGPT
using Random: Xoshiro

# THE FOLLOWING TESTS ARE AI ASSISTED

@testset "Dataloader.jl" begin
    # Work in a scratch directory so the files created here (input.txt,
    # empty.txt, oneline.txt) don't accumulate in the repository.
    mktempdir() do dir
        cd(dir) do
            # Use the dataset bundled with the test suite (test/names.txt, redistributed
            # under test/names.LICENSE) instead of downloading
            cp(joinpath(@__DIR__, "names.txt"), "input.txt"; force=true)
            touch("empty.txt")
            open("oneline.txt", "w") do f
                println(f, "name")
            end
            @testset "Output" begin
                doc, doc_empty, doc_noshuffle, doc_oneline = (load_data(), load_data("empty.txt"), load_data(do_shuffle=false), load_data("oneline.txt"))

                @testset "empty path" begin
                    @test_throws SystemError load_data("") # Test if the function throws an error if the input path doesn't exist
                end

                @testset "doc type" begin
                    @test typeof(doc) == Vector{String} # test if the output is an array of type string
                    @test eltype(doc) == String # test if each element in the output array is a string
                end

                @testset "doc shape" begin
                    @test length(doc) > 0 # test if the output length is > 0
                    @test doc_empty == [] # test if the output size = 0 for an empty input file
                    @test length(doc_oneline) == 1 # test if  output size = 1 for an empty input file
                    @test length(doc) == length(readlines("input.txt")) # test if  output is equal to the number of elements in the dataset
                end

                @testset "doc content" begin
                    # Shuffling must permute the documents, not add/drop/alter any
                    @test sort(doc) == sort(doc_noshuffle)
                    @test readlines("input.txt") == doc_noshuffle # test if the order and content of elements is the same as in the textfile (knowing that the dataset contains no whitespaces or \n)
                    @test readlines("oneline.txt") == doc_oneline # test the same with one line
                end

                @testset "doc values" begin
                    @test all(s -> length(s) > 0, doc)         # test if there are empty strings
                    @test all(s -> s == strip(s), doc)         # test if there are whitespaces in strings
                    @test all(s -> !occursin("\n", s), doc)    # test if there are linebreaks in strings
                end

                @testset "shuffling" begin
                    # With a pinned RNG the shuffle is deterministic, so the order-change check cannot fail by coincidence.
                    shuffled = load_data(rng=Xoshiro(42))
                    @test shuffled == load_data(rng=Xoshiro(42))  # deterministic for equal seeds
                    @test shuffled != doc_noshuffle               # and a real permutation of the file order
                    @test sort(shuffled) == sort(doc_noshuffle)
                end

                @testset "repeated calls" begin
                    @test load_data(do_shuffle=false) == load_data(do_shuffle=false)    # test if the output is consistent with repeated calls
                end
            end
        end
    end
end
