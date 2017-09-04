--爱丽丝·利德尔
function c10981028.initial_effect(c)
	c:SetUniqueOnField(1,1,10981028)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10981028.xyzcon)
	e0:SetOperation(c10981028.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10981028.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c10981028.defval)
	c:RegisterEffect(e2)   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10981028,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10981028.sptg)
	e3:SetOperation(c10981028.spop)
	c:RegisterEffect(e3) 
end
function c10981028.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc)
end
function c10981028.xyzfilter1(c,g)
	return g:IsExists(c10981028.xyzfilter2,1,c,c:GetRank())
end
function c10981028.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c10981028.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c10981028.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c10981028.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and (not min or min<=2 and max>=2)
		and mg:IsExists(c10981028.xyzfilter1,1,nil,mg)
end
function c10981028.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	local sg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=nil
		if og then
			mg=og:Filter(c10981028.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c10981028.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c10981028.xyzfilter1,1,1,nil,mg)
		local tc1=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c10981028.xyzfilter2,1,1,tc1,tc1:GetRank())
		local tc2=g2:GetFirst()
		g:Merge(g2)
		sg:Merge(tc1:GetOverlayGroup())
		sg:Merge(tc2:GetOverlayGroup())
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c10981028.atkfilter(c)
	return c:IsRace(RACE_FAIRY) and c:GetAttack()>=0
end
function c10981028.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10981028.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c10981028.deffilter(c)
	return c:IsRace(RACE_FAIRY) and c:GetDefense()>=0
end
function c10981028.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10981028.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c10981028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10981029,0,0x4011,-2,0,4,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10981028.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetHandler():GetOverlayCount()
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10981029,0,0x4011,-2,0,4,RACE_MACHINE,ATTRIBUTE_DARK) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,10981029)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10981028,2)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
