using HTTP
"""
    tex2png()

Render a latex table source file into an image via https://quicklatex.com/js/quicklatex.js
"""
function tex2png(file::String, url = "https://quicklatex.com/latex3.f")
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
end