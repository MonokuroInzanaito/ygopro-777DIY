--瓦里安·乌瑞恩
function c60158917.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(Card.IsType,TYPE_TUNER,aux.NonTuner(c60158917.sprfilter1),2,2))
	e1:SetTarget(aux.SynTarget(Card.IsType,TYPE_TUNER,aux.NonTuner(c60158917.sprfilter1),2,2))
	e1:SetOperation(aux.SynOperation(Card.IsType,TYPE_TUNER,aux.NonTuner(c60158917.sprfilter1),2,2))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c60158917.effcon)
	e2:SetTarget(c60158917.drtg)
	e2:SetOperation(c60158917.effop)
	c:RegisterEffect(e2)
end
function c60158917.sprfilter1(c)
	return c:IsRace(RACE_WARRIOR) and not c:IsType(TYPE_TOKEN)
end
function c60158917.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60158917.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60158917.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsPublic()
end
function c60158917.effop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.Draw(p,d,REASON_EFFECT)
	if ct==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct2=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,ct2)
	local g=ct2:Filter(c60158917.filter,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.ShuffleHand(tp)
	end
end