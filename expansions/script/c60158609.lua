--要罪凭依
function c60158609.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60158609+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c60158609.target)
    e1:SetOperation(c60158609.activate)
    c:RegisterEffect(e1)
end
function c60158609.filter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158609.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158609.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60158609.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158609.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(60158609,0)) then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			local tg=Duel.SelectOption(tp,aux.Stringid(60158609,1),aux.Stringid(60158609,2))
			if tg==1 then
				local lv=Duel.SelectOption(tp,1,2,3)
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(lv+1)
				tc:RegisterEffect(e1)
			else
				local lv=Duel.SelectOption(tp,1,2,3)
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(-(lv+1))
				tc:RegisterEffect(e1)
			end
		end
    end
end
