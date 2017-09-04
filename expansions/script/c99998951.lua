--传说之骑兵 玛丽・安托瓦内特
function c99998951.initial_effect(c)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c99998951.slevel)
	c:RegisterEffect(e2)
	--xyzlv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99998951.xyzlv)
	c:RegisterEffect(e3)
end
function c99998951.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 8*65536+lv
end
function c99998951.xyzlv(e,c,rc)
	return 0x50000+e:GetHandler():GetLevel()
end