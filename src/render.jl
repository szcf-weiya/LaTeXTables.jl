using HTTP
"""
    tex2png(file::String; background::String)

Render a latex table source `file` into an image via <https://quicklatex.com/js/quicklatex.js>

By default, the ouput PNG image is transparent, which may make the table hard to read in some image viewers (e.g., VS Code). 
As a workaround, you can pass `background = "white"`, but this requires `convert` to be installed.
"""
function tex2png(file::String; url = "https://quicklatex.com/latex3.f", background = "transparent")
    preamble = raw"""
    \usepackage{amsmath}
    \usepackage{amsfonts}
    \usepackage{amssymb}
    \usepackage{multirow}
    \usepackage{booktabs}
    """
    content = String(read(file))
    if VERSION >= v"1.7.0"
        content = replace(content, "&"=>"%26", "%"=>"%25")
        preamble = replace(preamble, "&"=>"%26", "%"=>"%25")
    else
        content = replace(replace(content, "%"=>"%25"), "&"=>"%26") # NB: first replace %
        preamble = replace(replace(preamble, "%"=>"%25"), "&"=>"%26")
    end
    post_data = "formula=" * content * "&mode=0&out=1&preamble=" * preamble
    r = HTTP.request("POST", url, [], post_data)
    ret = String(r.body)
    imgurl = split(ret)[2]
    output = replace(file, ".tex" => ".png")
    HTTP.download(imgurl, output)
    if background == "white"
        # make sure `convert`` has been installed
        run(`convert $output -background white -flatten $output`)
    end
end