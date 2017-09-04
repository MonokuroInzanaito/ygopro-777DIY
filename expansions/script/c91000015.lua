--天印-白招拒
function c91000015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--Extra spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c91000015.spcost)
	e1:SetTarget(c91000015.sptg)
	e1:SetOperation(c91000015.spop)
	c:RegisterEffect(e1)
	--Grave spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000015,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,91000015)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c91000015.sgtg)
	e2:SetOperation(c91000015.sgop)
	c:RegisterEffect(e2)
end
function c91000015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and e:GetHandler():GetFlagEffect(91000015)==0 end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(91000015,RESET_CHAIN,0,1)
end
function c91000015.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xe10) and c:GetCode()~=91000015 and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c91000015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c91000015.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c91000015.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c91000015.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c91000015.sgfilter1(c,e,tp)
	return (c:IsControler(tp) or c:IsAbleToChangeControler()) and c:IsFaceup() and c:GetOverlayCount()==0 and c:GetRank()>0 and c~=e:GetHandler() and not c:IsImmuneToEffect(e)
		and Duel.IsExistingTarget(c91000015.sgfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetRank(),e)
end
function c91000015.sgfilter2(c,rk,e)
	return c:GetRank()==rk and c~=e:GetHandler() and not c:IsImmuneToEffect(e)
end
function c91000015.sgfilter3(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c91000015.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c91000015.sgfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c91000015.sgfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c91000015.sgfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc1,tc1:GetRank(),e)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c91000015.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c91000015.sgfilter3,nil,e)
	if tg:GetCount()~=2 or ft<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
		local g=tc:GetOverlayGroup()
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_RULE)
		end
		Duel.Overlay(c,tg)
	end
end
