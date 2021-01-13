command! -range=% SourceBuffer call sourcebuffer#source_range(bufnr(), <line1>, <line2>)
