--露娜卡娜
function c18706019.initial_effect(c)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c18706019.matcheck)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83755611,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c18706019.regcon)
	e2:SetOperation(c18706019.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c18706019.matcheck(e,c)
	local ct=c:GetMaterial():Filter(Card.IsSetCard,nil,0xabb):GetClassCount(Card.GetCode)
	e:SetLabel(ct)
end
function c18706019.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c18706019.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if ct>=1 then
	Duel.SelectOption(tp,aux.Stringid(18706019,0))
	Duel.SelectOption(1-tp,aux.Stringid(18706019,0))
	Duel.Hint(HINT_CARD,0,18144506)
	local ag=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.Destroy(ag,REASON_EFFECT)
	end
	if ct>=2 then
	Duel.Hint(HINT_CARD,0,12580477)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	end
	if ct>=4 then
	Duel.Hint(HINT_CARD,0,18706019)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
end
end