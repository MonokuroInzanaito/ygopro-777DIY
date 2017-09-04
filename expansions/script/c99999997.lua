--传说之王 英雄王 吉尔伽美什
function c99999997.initial_effect(c)
	c:SetUniqueOnField(1,0,99999997)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c99999997.xyzfilter),8,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c99999997.tg)
	e1:SetOperation(c99999997.op)
	c:RegisterEffect(e1)
    --return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29343734,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99999997.retcon)
	e2:SetTarget(c99999997.rettg)
	e2:SetOperation(c99999997.retop)
	c:RegisterEffect(e2)
    --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99991098,5))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c99999997.descost)
	e3:SetTarget(c99999997.destg)
	e3:SetOperation(c99999997.desop)
	c:RegisterEffect(e3)
    --cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--add setcode
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetValue(0x52e0)
	c:RegisterEffect(e5)
end
function c99999997.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7))
end
function c99999997.filter(c)
	local code=c:GetCode()
	return (code==99998972) and  c:IsAbleToHand()  
end
function c99999997.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999997.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99999997.filter2(c,ft) 
    local code=c:GetCode()
	return (code==99999963) and  (c:IsAbleToHand()  or ft>0)
end
function c99999997.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99999997.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then 
	Duel.ConfirmCards(1-tp,tc)
    if  Duel.IsExistingMatchingCard(c99999997.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ft) and Duel.SelectYesNo(tp,aux.Stringid(999996,5)) then
	local g2=Duel.SelectMatchingCard(tp,c99999997.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ft)
	local tg=g2:GetFirst()
	if ft>0 and  (not tg:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Equip(tp,tg,c)
		else
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
end
function c99999997.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99999997.retfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToDeck() 
end
function c99999997.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999997.retfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c99999997.retfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99999997.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99999997.retfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
function c99999997.sgfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost() 
end
function c99999997.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and  Duel.IsExistingMatchingCard(c99999997.sgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and 
	e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local rg=Duel.SelectMatchingCard(tp,c99999997.sgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,ct1,nil)
	Duel.SendtoGrave(rg,REASON_EFFECT)
	e:SetLabel(rg:GetCount())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c99999997.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local tc=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,tc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,tc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,tc*500,0,1-tp,nil)
end
function c99999997.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end








