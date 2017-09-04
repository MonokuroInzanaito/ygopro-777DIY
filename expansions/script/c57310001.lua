--ENS·绯色月下、狂咲之绝
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c57310001.initial_effect(c)
	senya.ens(c,57310001)
	senya.neg(c,1,57310001,senya.serlcost,c57310001.con,senya.ensop(57310001))
end
function c57310001.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end