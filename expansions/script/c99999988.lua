--传说之暗杀者 佐佐木小次郎
function c99999988.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991094,8))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c99999988.target)
	e1:SetOperation(c99999988.operation)
	c:RegisterEffect(e1)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c99999988.tgcon)
	e3:SetValue(c99999988.tgvalue)
	c:RegisterEffect(e3)
	--[[--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(c99999988.aihtarget)
	c:RegisterEffect(e4)--]]
end
function c99999988.filter(c)
	return c:IsAbleToRemove()
end
function c99999988.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99999988.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99999988.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99999988.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c99999988.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
   if g:IsRelateToEffect(e) and g:IsType(TYPE_MONSTER) then
   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
end
function c99999988.tgcon(e)
	return  Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c99999988.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and  re:IsActiveType(TYPE_MONSTER)
end
--[[function c99999988.aihtarget(e,c)
	return c:GetType()==TYPE_TRAP and c:IsCode(99999978)
end--]]
