# vis-parinfer
A small wrapper around  [parinfer-rust] (https://github.com/eraserhd/parinfer-rust)
and  lua library that allows it to be  used from [vis] (https://github.com/martanne/vis editor)

## instructions
#### Easy:
**copy libparinferlua.so to lua 5.3 include folder, usualy /usr/lib/lua/5.3
**place parinfer.lua in ./config/vis/plugins folder
*register events in visrc.lua as follows

    vis:map(vis.modes.NORMAL,  '<your key compination>', parinferToggleMode)
    vis:map(vis.modes.NORMAL,  '<your key compination>',  parinferOff)

AND more imporantly :

*vis.events.subscribe(vis.events.WIN_HIGHLIGHT, invoke_parinfer)

*Enjoy structural editing with vis**

#### Hard
********  When this fails compile the libraries. You probably know much better c
(and rust) than me . You need cargo to compile rust-parinfer with the
[staticlib] cargo.toml option and gcc, liblua5.3-dev (in debian) to compile
libparinferlua.c

***The command i used (and barely understand) is
#### gcc libparinferlua.c libcparinfer.a -shared -o libparinferlua.so -pthread  -fPIC -llua5.3 -I/usr/include/lua5.3/

## License

ISC License

Copyright (c) 2018, Jason Felice and Contributors

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

