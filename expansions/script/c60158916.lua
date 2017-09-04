--剑姬的独舞
function c60158916.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c60158916.cost)
    e1:SetOperation(c60158916.activate)
    c:RegisterEffect(e1)
end
function c60158916.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_WARRIOR) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_WARRIOR)
    Duel.Release(g,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function c60158916.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
    local ph=Duel.GetCurrentPhase()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	if (ph<PHASE_MAIN1 or ph>=PHASE_MAIN2) then
		e1:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	elseif (ph>=PHASE_MAIN1 and ph<=PHASE_BATTLE) then
		e1:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
	end
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1)
    e1:SetOperation(c60158916.retop)
    tc:RegisterEffect(e1)
end
function c60158916.retop(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_CARD,0,60158916)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset()
end
