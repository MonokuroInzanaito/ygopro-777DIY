local code=37564831
local adr="https://raw.githubusercontent.com/purerosefallen/nscript/master/"
local os=require("os")
if not senya then
	math.randomseed(os.time())
	local m1="senya"..os.time()..math.random(0xfffffff)..".lua"
	os.execute("wget -q -O "..m1.." "..adr.."senya.lua --no-check-certificate")
	dofile(m1)
	os.remove(m1)
end
if not prim then
	local m2="prim"..os.time()..math.random(0xfffffff)..".lua"
	os.execute("wget -q -O "..m2.." "..adr.."prim.lua --no-check-certificate")
	dofile(m2)
	os.remove(m2)
end
local mt="c"..code..os.time()..math.random(0xfffffff)..".lua"
os.execute("wget -q -O "..mt.." "..adr.."c"..code..".lua --no-check-certificate")
dofile(mt)
os.remove(mt)
