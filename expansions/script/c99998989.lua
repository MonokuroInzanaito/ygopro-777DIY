--传说之剑士 冲田总司
function c99998989.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c99998989.xyzfilter),3,2,c99998989.ovfilter,aux.Stringid(99998989,0),2,c99998989.xyzop)
	c:EnableReviveLimit()
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998989,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99998989.spcost)
	e2:SetTarget(c99998989.sptg)
	e2:SetOperation(c99998989.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c99998989.tgcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(c99998989.effval)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99998989,2))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c99998989.sgcon)
	e5:SetCost(c99998989.sgcost)
	e5:SetTarget(c99998989.sgtg)
	e5:SetOperation(c99998989.sgop)
	c:RegisterEffect(e5)
	--缩地
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e6:SetCountLimit(1,99998989)
	e6:SetTarget(c99998989.sztg)
	e6:SetOperation(c99998989.szop)
	c:RegisterEffect(e6)
end
function c99998989.xyzfilter(c)
	return  c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7)
end
function c99998989.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLocation(LOCATION_MZONE)
end
function c99998989.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsCanBeXyzMaterial(e)
	and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,c) 
end
function c99998989.tgfilter2(c,e)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsCanBeXyzMaterial(e)
end
function c99998989.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998989.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler(),tp) end
   local tg=Duel.GetMatchingGroup(c99998989.tgfilter2,tp,LOCATION_MZONE,0,nil,e:GetHandler()) 
   if tg:GetCount()==1 then
   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,tg:GetFirst())
    Duel.SendtoGrave(g,REASON_COST)
   else
   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
   Duel.SendtoGrave(g,REASON_COST)
   end
end
function c99998989.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99998989.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99998987,0,0x4011,1500,1500,3,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99998989.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,99998987,0,0x4011,1500,1500,3,RACE_WARRIOR,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,99998987)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
end
end
function c99998989.ifilter(c)
	return  c:IsCode(99998987)
end
function c99998989.tgcon(e)
	return Duel.IsExistingMatchingCard(c99998989.ifilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c99998989.effval(e,te,tp)
	return tp~=e:GetHandlerPlayer()
end
function c99998989.sgcon(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and c:IsRelateToBattle() and bc:IsRelateToBattle()
end
function c99998989.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99998989.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetLabelObject():GetBaseAttack()/2)
end
function c99998989.sgop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and Duel.SendtoGrave(bc,REASON_EFFECT)>0 then
	Duel.Damage(tp,bc:GetBaseAttack()/2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.ChainAttack()
end
end
function c99998989.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsXyzSummonable(nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function c99998989.szop(e,tp,eg,ep,ev,re,r,rp)
		Duel.XyzSummon(tp,e:GetHandler(),nil)
end
