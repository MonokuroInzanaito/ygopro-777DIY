--魔王少女
function c18787002.initial_effect(c)
	c:SetSPSummonOnce(18787002)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3abb),4,2)
	c:EnableReviveLimit()
	--TOGRAVE
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(44505297,0))
	--e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	--e1:SetCategory(CATEGORY_EQUIP)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCondition(c18787002.tgcon)
	--e1:SetTarget(c18787002.tgtg)
	--e1:SetOperation(c18787002.tgop)
	--c:RegisterEffect(e1)
	--EQ
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetDescription(aux.Stringid(69610924,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c18787002.cost)
	e1:SetTarget(c18787002.eqtg)
	e1:SetOperation(c18787002.eqop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18787002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c18787002.spcon)
	e2:SetCost(c18787002.Scost)
	e2:SetTarget(c18787002.sptg)
	e2:SetOperation(c18787002.spop)
	c:RegisterEffect(e2)
end
function c18787002.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c18787002.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb) and c:IsAbleToGrave()
end
function c18787002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18787002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c18787002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18787002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c18787002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c18787002.filter(c)
	return c:IsSetCard(0x3abb) and c:IsType(TYPE_MONSTER)
end
function c18787002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c18787002.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_HAND)
end
function c18787002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c18787002.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c18787002.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c18787002.eqlimit(e,c)
	return e:GetOwner()==c
end
function c18787002.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c18787002.filter,c:GetControler(),LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c18787002.Scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(18787002,0))
	Duel.SelectOption(1-tp,aux.Stringid(18787002,0))
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c18787002.spfilter(c,e,tp)
	return c:IsCode(18787003) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
end
function c18787002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,18787002)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18787002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.RegisterFlagEffect(tp,18787002,0,0,0)
end
function c18787002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(c18787002.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc then
		local cg=Group.FromCards(c)
		tc:SetMaterial(cg)
		Duel.Overlay(tc,cg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
