--人偶
function c18781015.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c18781015.target1)
	e2:SetOperation(c18781015.activate1)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,18781015)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c18781015.eqtg2)
	e3:SetOperation(c18781015.eqop2)
	c:RegisterEffect(e3)
end
function c18781015.thfilter(c)
	return c:IsSetCard(0x6abb) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c18781015.filter(c)
	return c:IsSetCard(0x3abb) and c:IsType(TYPE_MONSTER)
end
function c18781015.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18781015.filter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(c18781015.thfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c18781015.activate1(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c18781015.filter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		local tc=g:GetFirst()
		local g2=Duel.SelectMatchingCard(tp,c18781015.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc2=g2:GetFirst()
	if not tc2:IsImmuneToEffect(e) then
		Duel.Overlay(tc2,Group.FromCards(tc))
	end
end
function c18781015.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10100017.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c18781015.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c18781015.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18781015.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c18781015.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local ec=g:GetFirst()
		Duel.Equip(tp,ec,tc)
		--equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e1)
	end
end