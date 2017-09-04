--甘兔庵 桐间纱露
function c410003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c410003.splimit)
	c:RegisterEffect(e1) 
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(410003,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c410003.tgcon)
	e2:SetTarget(c410003.tgtg)
	e2:SetOperation(c410003.tgop)
	c:RegisterEffect(e2)
	c410003[c]=e2
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(410003,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c410003.setcon)
	e3:SetTarget(c410003.settg)
	e3:SetOperation(c410003.setop)
	c:RegisterEffect(e3)
end
function c410003.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c410003.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c410003.tffilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c410003.setop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c410003.tffilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then 
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c410003.tffilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
end
function c410003.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c410003.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c410003.cfilter,1,nil,tp)
end
function c410003.cfilter(c,tp)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and c:GetSummonPlayer()==tp
end
function c410003.tgfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsExistingMatchingCard(c410003.tgfilter2,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalLevel()*3)
end
function c410003.tgfilter2(c,lv)
	return c:IsAbleToGrave() and c:IsLevelBelow(lv)
end
function c410003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c410003.tgfilter(chkc,e,tp) end
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingTarget(c410003.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c410003.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c410003.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c410004.tgfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetOriginalLevel()*3)
	if g:GetCount()>0 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	end
end