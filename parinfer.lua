local parinfer = require("libparinferlua")
local json = require("json")
require('vis')

local parinfer_mode = "smart"

build_parinfer_json = function ()
  local the_table={mode = parinfer_mode,
  text = vis.win.file:content(0, vis.win.file.size),
  options =  {cursorX = vis.win.selection.pos}
}
  return json.encode(the_table)
end


invoke_parinfer = function ()
 if parinfer_mode ~= "off" then
  local is_modified = false
  local old_lines = {}
  local n=1
  pcall (function () old_lines = vis.win.file.lines end  )
  local new_lines = {}
  pcall(function () is_modified = vis.win.file.modified end)
  if is_modified == true then
    local the_json = build_parinfer_json()
    local response = json.decode (parinfer.runParinfer(the_json))
    if response["success"] == true then
      for s in response["text"]:gmatch("([^\n]*)\n?") do
        if old_lines[n]~=s    then
           old_lines[n]=s
        end
          n=n+1
      end
      vis.win.selection.pos = response["cursorX"]
    else return 0
    end
    return 0
  end
  end
 return 0
end

function _parinferOff ()
parinfer_mode = "off"
vis:info ( "Parinfer is Off" )
return 0
end

function _parinferToggleMode ()
  if  parinfer_mode == "smart"  then
   parinfer_mode = "indent"
   vis:info  ("Parinfer indent mode is now On")
 elseif parinfer_mode == "indent"  then
   parinfer_mode = "paren"
   vis:info  ("Parinfer paren mode is now On")
  else  parinfer_mode = "smart"
   vis:info  ("Parinfer smart mode is now On")
 end
return 0
end

 parinferOff = vis:action_register("parinferOff", _parinferOff)
 parinferToggleMode = vis:action_register("parinferToggleMode",_parinferToggleMode )


vis.events.subscribe(vis.events.WIN_HIGHLIGHT, invoke_parinfer)
