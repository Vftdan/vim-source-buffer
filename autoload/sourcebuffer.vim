let s:registry = {}

function! sourcebuffer#source_range(buf, start, end)
	let l:lines = getbufline(a:buf, a:start, a:end)
	if !has_key(s:registry, a:buf)
		if empty(globpath(&rtp, 'sourcebufferfiles/' . a:buf . '.vim'))
			call sourcebuffer#_create_file(a:buf)
		endif
		execute 'runtime sourcebufferfiles/' . a:buf . '.vim'
	endif
	return s:registry[a:buf].call(l:lines)
endfunction

function! sourcebuffer#_create_file(nr)
	if empty(globpath(&rtp, 'sourcebufferfiles/'))
		for l:path in globpath(&rtp, '', v:false, v:true)
			try
				call mkdir(l:path . 'sourcebufferfiles', 'p')
				break
			catch
			endtry
		endfor
	endif
	for l:path in globpath(&rtp, 'sourcebufferfiles/', v:false, v:true)
		try
			call writefile([
				\ 'let s:_sourcebuffer_ = {}',
				\ 'function s:_sourcebuffer_.call(lines)',
				\ '	execute join(a:lines, "\n")',
				\ 'endfunction',
				\ 'call sourcebuffer#_register_file(' . a:nr . ', s:_sourcebuffer_)',
				\ 'unlet s:_sourcebuffer_',
				\ ], l:path . a:nr . '.vim')
			break
		catch
		endtry
	endfor
endfunction

function! sourcebuffer#_register_file(nr, obj)
	let s:registry[a:nr] = a:obj
endfunction
