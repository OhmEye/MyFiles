-- postprocess.lua
-- -- KISSlicer example code

-- open files
collectgarbage()  -- ensure unused files are closed
local fin = assert( io.open( arg[1] ) ) -- reading
local fout = assert( io.open( arg[1] .. "-kiss.g", "wb" ) ) -- writing must be binary

-- read lines
for line in fin:lines() do
  local m = line:match( "M104" ) or line:match( "M140" ) or line:match( "M109" ) -- find target mcodes
    if m then
        fout:write( "\r\n" ) -- replace target lines with endline
          else
              fout:write( line .. "\n" )
                end
                end

                -- done
                fin:close()
		fout:write( "M104 S0\r\n" )
		fout:write( "M140 S0\r\n" )
                fout:close()
		os.remove( arg[1] ) -- delete input file
                print "done"

