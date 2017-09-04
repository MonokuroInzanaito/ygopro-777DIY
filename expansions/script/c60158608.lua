--原罪的悸动
function c60158608.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1e0)
    e1:SetCountLimit(1,60158608+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c60158608.cost)
    e1:SetTarget(c60158608.target)
    e1:SetOperation(c60158608.activate)
    c:RegisterEffect(e1)
end
function c60158608.cfilter(c)
    return c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost()
end
function c60158608.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158608.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c60158608.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60158608.filter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158608.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158608.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60158608.thfilter(c)
    return (c:IsCode(60158609) or c:IsCode(60158610)) and c:IsAbleToHand()
end
function c60158608.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158608.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local tc=g:GetFirst()
			local tc2=e:GetLabelObject()
			local g2=Duel.GetMatchingGroup(c60158608.thfilter,tp,LOCATION_DECK,0,nil)
			if g2:GetCount()>0 and tc:GetAttribute()==tc2:GetOriginalAttribute() 
				and Duel.SelectYesNo(tp,aux.Stringid(60158608,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g2:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
    end
end
