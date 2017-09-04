--传说之狂战士 朗尼·特纳普
function c18700342.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c18700342.code)
	e1:SetValue(0xab0)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c18700342.atlimit)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15146890,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c18700342.target)
	e4:SetOperation(c18700342.operation)
	c:RegisterEffect(e4)
end
function c18700342.code(e,c)
	return c~=e:GetHandler()
end
function c18700342.atlimit(e,c)
	return c:IsFacedown() or not c:IsSetCard(0xab0)
end
function c18700342.cfilter(c)
	return c:IsAbleToGrave()
end
function c18700342.filter(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsSetCard(0xab0)
end
function c18700342.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18700342.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c18700342.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c18700342.tgfilter(c)
	return c:IsCode(18700343) and c:IsAbleToHand()
end
function c18700342.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c18700342.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
	local g2=Duel.SelectMatchingCard(tp,c18700342.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g2:GetFirst():GetTextAttack()
		Duel.Destroy(g2,REASON_EFFECT)
	if g1:GetFirst():IsSetCard(0x2e4) then
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
		else
		local tg=Duel.GetFirstMatchingCard(c18700342.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		end
	end
	end
end