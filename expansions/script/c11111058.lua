--加油大魔王 妒忌的伽勒斯
function c11111058.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111058,2))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11111058.xyzcon)
	e1:SetOperation(c11111058.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111058,3))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c11111058.discon)
	e2:SetCost(c11111058.discost)
	e2:SetTarget(c11111058.distg)
	e2:SetOperation(c11111058.disop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(c11111058.indcon1)
	e3:SetValue(c11111058.efilter1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c11111058.indcon2)
	e4:SetValue(c11111058.efilter2)
	c:RegisterEffect(e4)
end
function c11111058.spfilter1(c,tp,xyzcard)
	if c:GetRank()==8 and c:IsSetCard(0x15d) and not c:IsCode(11111058) and not c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL) and c:IsFaceup() then
	    return Duel.IsExistingMatchingCard(c11111058.spfilter2,tp,LOCATION_MZONE,0,1,nil)
	elseif (c:GetLevel()==8 or c:IsHasEffect(11111053)) and c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard) then
	    return Duel.IsExistingMatchingCard(c11111058.spfilter3,tp,LOCATION_MZONE,0,3,nil)
	else return false end	
end
function c11111058.spfilter2(c,xyzcard)
	return (c:GetLevel()==8 or c:IsHasEffect(11111053)) and c:IsSetCard(0x15d) and c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard)
end
function c11111058.spfilter3(c,xyzcard)
	return (c:GetLevel()==8 or c:IsHasEffect(11111053)) and c:IsFaceup() and c:IsCanBeXyzMaterial(xyzcard)
end
function c11111058.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c11111058.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c11111058.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11111058,0))
	local g1=Duel.SelectMatchingCard(tp,c11111058.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11111058,1))
	if tc:IsType(TYPE_XYZ) then
	    local g=Duel.GetMatchingGroup(c11111058.spfilter2,tp,LOCATION_MZONE,0,nil)
		g2=g:Select(tp,1,1,nil)
	    local sg=tc:GetOverlayGroup()
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_RULE)
		end	
	else
	    local g=Duel.GetMatchingGroup(c11111058.spfilter3,tp,LOCATION_MZONE,0,tc)
	    g2=g:Select(tp,2,2,nil)
	end	
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c11111058.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():GetSummonLocation()==LOCATION_EXTRA
		and Duel.IsChainNegatable(ev)
end
function c11111058.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11111058.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11111058.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11111058.indfilter1(c)
	return c:IsSetCard(0x15d) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_FIEND)
end
function c11111058.indcon1(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c11111058.indfilter1,1,nil)
end
function c11111058.efilter1(e,re)
	return re:IsActiveType(TYPE_EFFECT)
end
function c11111058.indfilter2(c)
	return c:IsSetCard(0x15d) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_FAIRY)
end
function c11111058.indcon2(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c11111058.indfilter2,1,nil)
end
function c11111058.efilter2(e,re,rp)
	return re:IsActiveType(TYPE_EFFECT) and aux.TRUE(e,re,rp)
end