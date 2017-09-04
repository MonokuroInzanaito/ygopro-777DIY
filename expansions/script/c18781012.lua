--影刺
function c18781012.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18781012,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c18781012.target2)
	e2:SetOperation(c18781012.activate2)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetRange(LOCATION_HAND)
	c:RegisterEffect(e4)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,18781012)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c18781012.tgtg)
	e3:SetOperation(c18781012.tgop)
	c:RegisterEffect(e3)
end
function c18781012.thfilter(c)
	return c:IsSetCard(0x6abb) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c18781012.filter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c18781012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and Duel.IsExistingMatchingCard(c18781012.thfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c18781012.tgop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(1-tp,c18781012.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		local g2=Duel.SelectMatchingCard(tp,c18781012.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc2=g2:GetFirst()
	if not tc2:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc2,Group.FromCards(tc))
	end
end
function c18781012.filter2(c,e,tp)
	return c:IsSetCard(0x6abb) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c18781012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18781012.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c18781012.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectMatchingCard(tp,c18781012.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g2:GetFirst()
		if not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end