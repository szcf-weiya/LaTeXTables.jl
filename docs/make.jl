using Documenter, LaTeXTables

makedocs(sitename = "LaTeXTables.jl Documentation",
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
        "Example" => Any[
            "One Level" => "example/one-level.md",
            "Two Level" => "example/two-level.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/szcf-weiya/LaTeXTables.jl.git",
)