using Test
using LaTeXTables

@testset "print2tex" begin
    @testset "simple" begin
        μ = [rand(3, 4), rand(3, 4)]
        σ = [rand(3, 4), rand(3, 4)]
        print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "/tmp/test.tex")
        # run(`make -C $(@__DIR__)/tables`) # test locally
    end
    @testset "other cols" begin
        μ = [rand(3, 4), rand(3, 4)]
        σ = [rand(3, 4), rand(3, 4)]
        others = [rand(3, 1), rand(3, 1)]
        others_σ = [rand(3, 1), rand(3, 1)]
        filepath = "/tmp/test.tex"
        # filepath = "test/tables/table.tex" # use when locally developping
        print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = filepath, other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ)
    end
    @testset "other right cols"  begin
        μ = [rand(3, 4), rand(3, 4)]
        σ = [rand(3, 4), rand(3, 4)]
        others = [rand(3, 1), rand(3, 1)]
        others_σ = [rand(3, 1), rand(3, 1)]
        right = [[rand(3), rand(3)]]
        filepath = "/tmp/test.tex"
        # filepath = "../test/tables/table.tex"
        print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = filepath, other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ, right_cols = right, right_col_names = ["right"])
    end
end