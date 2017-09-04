--最终的幻想
function c60150511.initial_effect(c)
	c:SetUniqueOnField(1,1,60150511)
	--xyz summon
	aux.AddXyzProcedure(c,c60150511.mfilter,11,3)
	c:EnableReviveLimit()
	--half damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c60150511.dcon)
	e4:SetOperation(c60150511.dop)
	c:RegisterEffect(e4)
	--Special Summon
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(35952884,1))
	e14:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetCode(EVENT_LEAVE_FIELD)
	e14:SetCountLimit(1,60150512)
	e14:SetCondition(c60150511.sumcon)
	e14:SetTarget(c60150511.sumtg)
	e14:SetOperation(c60150511.sumop)
	c:RegisterEffect(e14)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c60150511.aclimit)
	e1:SetCondition(c60150511.actcon)
	c:RegisterEffect(e1)
end
function c60150511.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150511.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c60150511.actcon(e)
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) 
	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60150510)
end
function c60150511.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and e:GetHandler():GetOverlayCount()==0
end
function c60150511.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c60150511.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60150511.filter(c,e,tp)
	return c:GetRank()>=10 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150511.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c60150511.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150511.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150511.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150511.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end