--星之华的御光者-乌木子
function c66666606.initial_effect(c)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetCondition(c66666606.remcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetTarget(c66666606.sptg)
	e2:SetOperation(c66666606.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c66666606.drcon)
	e3:SetTarget(c66666606.drtg)
	e3:SetOperation(c66666606.drop)
	c:RegisterEffect(e3)
end
function c66666606.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_DECK
end
function c66666606.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x661) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(66666606)
end
function c66666606.cfilter(c,lv)
	return c:IsFaceup() and c:IsSetCard(0x661) and c:IsAbleToRemoveAsCost() and c:GetOriginalLevel()>=lv 
end
function c66666606.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=Duel.GetMatchingGroup(c66666606.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chkc then return sg:IsContains(chkc) and chkc:IsLevelBelow(e:GetLabel()) end
	if sg:GetCount()==0 then return false end
	local mg,mlv=sg:GetMinGroup(Card.GetLevel)
	local elv=e:GetHandler():GetOriginalLevel()
	local lv=(elv>=mlv) and 1 or (mlv-elv)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c66666606.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66666606.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),lv)
	local slv=elv+g:GetFirst():GetLevel()
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	e:SetLabel(slv)
	local g=sg:FilterSelect(tp,Card.IsLevelBelow,1,1,nil,slv)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c66666606.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66666606.drcon(e,tp,eg,ep,ev,re,r,rp)
	return (not re or re:GetHandler()~=e:GetHandler()) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c66666606.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666606.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end