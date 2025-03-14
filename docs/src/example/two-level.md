## Two-level Columns

```@example 1
using LaTeXTables # hide
a = randn(2)
b = [randn(2) for i = 1:2, j = 1:2]
A = hcat(a, b)
B = hcat(A, A)
print2tex(B, ["r1", "r2"], ["col01", "col02"], subcolnames = ["c1", "c2", "c3"], file="col2.tex")
tex2png("col2.tex")
```

![](col2.png)

!!! tip "Set png background"
    By default, the background of PNG images rendered from `tex2png` is transparent, which may make the table hard to read in some image viewers (e.g., VS Code). As a workaround, you can set the background to "white", but this requires `convert` to be installed.
    ```julia
    tex2png("col2.tex", background = "white")
    ```

```@example 1
a = randn(2)
b = [randn(2) for i = 1:2, j = 1:2]
A = hcat(a, b)
B = hcat(A, A)
C = [B, B]
print2tex(C, ["r01", "r02"], ["col01", "col02"], subcolnames = ["c1", "c2", "c3"], subrownames = ["r1", "r2"], colnames_of_rownames = ["level0", "level1"], file="row2col2.tex")
tex2png("row2col2.tex")
```

![](row2col2.png)

## Share rownames: combine two tables

```@example 1
a = randn(2)
b = [randn(2) for i = 1:2, j = 1:2]
A = hcat(a, b)
A2 = hcat(a, b)
print2tex(A, ["A", "B"], ["col1", "col2", "col3"], A2 = A2, colnames2 = ["COL1", "col2", "col3"], file = "ex02.tex")
tex2png("ex02.tex")
```

![](ex02.png)

## Two-level rows and Two-level columns

```@example 1
μ = [rand(3, 4), rand(3, 4)]
σ = [rand(3, 4), rand(3, 4)]
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex1.tex")
tex2png("ex1.tex")
```

![](ex1.png)

!!! tip "the first level of column can be reduced"
    If there is only one level column, we can pass an empty string `[""]` for the first level column name.

```@example 1
print2tex(μ, σ, ["A", "B"], [""], ["1","2","3"], ["x", "y", "z", "w"], file = "ex1r.tex")
tex2png("ex1r.tex")
```

![](ex1r.png)

!!! tip "superscript"
    We can add superscript, such as the rank, for each cell with the argument `rank_sup`.

```@example 1
rk = [hcat([sortperm(sortperm(x)) for x in eachcol(μ[1])]...),
      hcat([sortperm(sortperm(x)) for x in eachcol(μ[2])]...)]
print2tex(μ, σ, ["A", "B"], [""], ["1","2","3"], ["x", "y", "z", "w"], file = "ex1rank.tex", rank_sup = rk)
tex2png("ex1rank.tex")
```


### Add columns on the left

```@example 1
others = [rand(3, 1), rand(3, 1)]
others_σ = [rand(3, 1), rand(3, 1)]
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex2.tex", other_cols = others, other_col_names = ["other"], other_cols_σ = others_σ)
tex2png("ex2.tex")
```

![](ex2.png)


### Add columns on the right

```@example 1
right = [[rand(3), rand(3)]]
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex3.tex", 
                                                                other_cols = others, 
                                                                other_col_names = ["other"], 
                                                                other_cols_σ = others_σ, 
                                                                right_cols = right, 
                                                                right_col_names = ["right"])
tex2png("ex3.tex")
```

![](ex3.png)

Particularly, if the column is p-value, we can annotate the significance with star symbols, like `?symnum` in R.

```@example 1
pval = [star_pval.(right[1] / 100)]
print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2","3"], ["x", "y"], file = "ex4.tex", 
                                                                other_cols = others, 
                                                                other_col_names = ["other"], 
                                                                other_cols_σ = others_σ, 
                                                                right_cols = pval, right_col_names = ["pval"])
tex2png("ex4.tex")
```

![](ex4.png)

### Reduce to One-Level

```@example 1
μ = [rand(3, 2)]
σ = [rand(3, 2)]
print2tex(μ, σ, [""], [""], ["M1", "M2", "M3"], ["C1", "C2"], colnames_of_rownames = ["Method"], file = "ex5.tex")
tex2png("ex5.tex")
```

![](ex5.png)