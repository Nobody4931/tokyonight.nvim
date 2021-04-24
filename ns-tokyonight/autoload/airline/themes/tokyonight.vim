let s:tn_black      = [ "#32344a", 237 ]
let s:tn_red        = [ "#f7768e", 210 ]
let s:tn_green      = [ "#9ece6a", 149 ]
let s:tn_yellow     = [ "#e0af68", 179 ]
let s:tn_blue       = [ "#7aa2f7", 111 ]
let s:tn_magenta    = [ "#ad8ee6", 140 ]
let s:tn_cyan       = [ "#449dab", 73 ]
let s:tn_white      = [ "#9699a8", 247 ]

let s:tn_bblack     = [ "#444b6a", 240 ]
let s:tn_bred       = [ "#ff7a93", 210 ]
let s:tn_bgreen     = [ "#b9f27c", 156 ]
let s:tn_byellow    = [ "#ff9e64", 215 ]
let s:tn_bblue      = [ "#7da6ff", 111 ]
let s:tn_bmagenta   = [ "#bb9af7", 141 ]
let s:tn_bcyan      = [ "#0db9d7", 38 ]
let s:tn_bwhite     = [ "#acb0d0", 146 ]

let s:tn_swhite     = [ "#ffffff", 231 ]
let s:tn_sgray1     = [ "#262626", 235 ]
let s:tn_sgray2     = [ "#4f5b66", 59 ]
let s:tn_sgray3     = [ "#151515", 233 ]
let s:tn_sgray4     = [ "#666666", 243 ]

let s:al_b = [ s:tn_swhite[0], s:tn_sgray1[0], s:tn_swhite[1], s:tn_sgray1[1] ]
let s:al_c = [ s:tn_sgray2[0], s:tn_sgray3[0], s:tn_sgray2[1], s:tn_sgray3[1] ]
let s:al_m = { "airline_c": [ s:tn_bcyan[0], "", s:tn_bcyan[1], "" ] }

let g:airline#themes#tokyonight#palette = {}

" Normal mode
let g:airline#themes#tokyonight#palette["normal"] = airline#themes#generate_color_map(
	\ [ s:tn_swhite[0], s:tn_magenta[0], s:tn_swhite[1], s:tn_magenta[1] ],
	\ s:al_b, s:al_c)
let g:airline#themes#tokyonight#palette["normal_modified"] = s:al_m

" Insert mode
let g:airline#themes#tokyonight#palette["insert"] = airline#themes#generate_color_map(
	\ [ s:tn_swhite[0], s:tn_blue[0], s:tn_swhite[1], s:tn_blue[1] ],
	\ s:al_b, s:al_c)
let g:airline#themes#tokyonight#palette["insert_modified"] = s:al_m

" Visual mode
let g:airline#themes#tokyonight#palette["visual"] = airline#themes#generate_color_map(
	\ [ s:tn_swhite[0], s:tn_green[0], s:tn_swhite[1], s:tn_green[1] ],
	\ s:al_b, s:al_c)
let g:airline#themes#tokyonight#palette["visual_modified"] = s:al_m

" Replace mode
let g:airline#themes#tokyonight#palette["replace"] = airline#themes#generate_color_map(
	\ [ s:tn_swhite[0], s:tn_red[0], s:tn_swhite[1], s:tn_red[1] ],
	\ s:al_b, s:al_c)
let g:airline#themes#tokyonight#palette["replace_modified"] = s:al_m

" Inactive mode
let g:airline#themes#tokyonight#palette["inactive"] = airline#themes#generate_color_map(
	\ [ s:tn_sgray4[0], s:tn_sgray1[0], s:tn_sgray4[1], s:tn_sgray1[1] ],
	\ s:al_c, s:al_c)
let g:airline#themes#tokyonight#palette["inactive_modified"] = { "airline_c": [ s:tn_cyan[0], "", s:tn_cyan[1], "" ] }
