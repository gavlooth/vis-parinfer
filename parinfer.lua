local parinfer = require("libparinferlua")
local json = require("json")
require('vis')

local parinfer_mode = "smart"

local build_parinfer_json = function ()
  local the_table={mode = parinfer_mode,
  text = vis.win.file:content(0, vis.win.file.size),
  options =  {cursorX = vis.win.selection.pos}
}
return json.encode(the_table)
end

local operate_on_lines = function (old_lines, parinfer_response)
  local changed_lines = {}
  local n=1
  if parinfer_response["success"] == true then
    for s in parinfer_response["text"]:gmatch("([^\n]*)\n?") do
      if old_lines[n]~=s  then
        table.insert(changed_lines, {n, s})
      end
      n=n+1
    end
    local i,v = next(changed_lines,nil)
    if v~= nil then
      if vis.mode == vis.modes.NORMAL then
        vis:feedkeys('u')
      elseif vis.mode == vis.modes.INSERT then
        vis:feedkeys('<C-w>')
      else  vis:feedkeys('u')
      end
      while i do
        old_lines[v[1]] = v[2]
        i,v = next(changed_lines,i)
      end
      vis.win.selection.pos = parinfer_response["cursorX"]
    end
  end
end




      -- if response["success"] == true then
      --   for s in response["text"]:gmatch("([^\n]*)\n?") do
      --     if old_lines[n]~=s    then
      --       old_lines[n]=s
      --     end
      --     n=n+1
      --   end
      --   vis.win.selection.pos = response["cursorX"]
      -- end

local flag = 0
invoke_parinfer = function (win)
  if parinfer_mode ~= "off" then
    local is_modified = false
    local old_lines = {}
    pcall (function () old_lines = vis.win.file.lines end)
    pcall(function () is_modified = vis.win.file.modified end)
    if is_modified == true and flag == 0  then
      local  parinfer_response = json.decode(parinfer.runParinfer(build_parinfer_json()))
      operate_on_lines (old_lines, parinfer_response)
    end
    flag = flag + 1
    if flag < 2 then
      vis.events.emit(vis.events.WIN_HIGHLIGHT, win)
    else flag = 0
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
