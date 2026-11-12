# Build with LuaLaTeX and shell escape (minted calls latexminted).
# latexmk reruns until the page positions settle, which the spiral needs.
$pdf_mode = 4;
$lualatex = 'lualatex -shell-escape -interaction=nonstopmode -file-line-error %O %S';
