local lp = require("lp")

local function usage()
  print('\nUsage: lua lptest.lua [filename] [keyword=val...]\n')
  print('Valid keywords are :')
  print(
     '  host=remote host or IP address (default "localhost")\n' ..
     '  queue=remote queue or printer name (default "printer")\n' ..
     '  port=remote port number (default 515)\n' ..
     '  user=sending user name\n' ..
     '  format=["binary" | "text" | "ps" | "pr" | "fortran"] (default "binary")\n' ..
     '  banner=true|false\n' ..
     '  indent=number of columns to indent\n' ..
     '  mail=email of address to notify when print is complete\n' ..
     '  title=title to use for "pr" format\n' ..
     '  width=width for "text" or "pr" formats\n' ..
     '  class=\n' ..
     '  job=\n' ..
     '  name=\n' ..
     '  localbind=true|false\n'
     )
  return nil
end

if not arg or not arg[1] then
  return usage()
end

do
    local s="opt = {"
    for i = 2 , table.getn(arg), 1 do
      s = s .. string.gsub(arg[i],"[%s%c%p]*([%w]*)=([\"]?[%w%s_!@#$%%^&*()<>:;]+[\"]\?\.?)","%1%=\"%2\",\n")
    end
    s = s .. "};\n"
    assert(loadstring(s))();
    if not arg[2] then
      return usage()
    end

    if arg[1] ~= "query" then
        r,e=lp.send(arg[1],opt)
        io.stdout:write(tostring(r or e),'\n')
    else
        r,e=lp.query(opt)
        io.stdout:write(tostring(r or e), '\n')
    end
end

-- trivial tests
--lua lp.lua lp.lua queue=default host=localhost
--lua lp.lua lp.lua queue=default host=localhost format=binary localbind=1
--lua lp.lua query queue=default host=localhost