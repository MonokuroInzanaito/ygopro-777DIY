--招荡的黄金剧场
function c99999950.initial_effect(c)  
    c:SetUniqueOnField(1,0,99999950)
	--Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c99999950.actcon)
    c:RegisterEffect(e1)  
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE) 
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e2:SetTarget(c99999950.target)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_SZONE) 
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e4:SetTarget(c99999950.target)
	c:RegisterEffect(e4)
    --material(grave)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99991098,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c99999950.matcost)
	e5:SetTarget(c99999950.mattg1)
	e5:SetOperation(c99999950.matop1)
	c:RegisterEffect(e5)
	--material(mzone)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99991098,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c99999950.matcost)
	e5:SetTarget(c99999950.mattg2)
	e5:SetOperation(c99999950.matop2)
	c:RegisterEffect(e5)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetCondition(c99999950.descon)
	c:RegisterEffect(e6)
end
function c99999950.actfilter(c)
	return c:IsFaceup() and c:IsCode(99999952) 
end
function c99999950.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99999950.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99999950.target(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c99999950.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(99999950)==0 end
	e:GetHandler():RegisterFlagEffect(99999950,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99999950.matfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function c99999950.mattg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99999950.actfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c99999950.actfilter,tp,LOCATION_MZONE,0,1,nil) and
	Duel.IsExistingMatchingCard(c99999950.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99999950.actfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99999950.matop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c99999950.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		    else return end
	end
end
function c99999950.matfilter2(c)
	return  c:IsType(TYPE_MONSTER)
end
function c99999950.mattg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99999950.actfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c99999950.actfilter,tp,LOCATION_MZONE,0,1,nil) and
	Duel.GetOverlayCount(tp,0,1)~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99999950.actfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99999950.matop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetOverlayGroup(tp,0,1)
	local g2=Duel.GetFirstTarget()
	if g1:GetCount()==0  then return end
	local mg=g1:Select(tp,1,1,nil)
	local oc=mg:GetFirst():GetOverlayTarget()
	Duel.Overlay(g2,mg)
	Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
end
function c99999950.descon(e)
	return not Duel.IsExistingMatchingCard(c99999950.actfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
