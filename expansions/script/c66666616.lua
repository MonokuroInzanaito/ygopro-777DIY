--六芒星辉
function c66666616.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c66666616.cgcost)
	e1:SetTarget(c66666616.cgtg)
	e1:SetOperation(c66666616.cgop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(66666616,ACTIVITY_SPSUMMON,c66666616.counterfilter)
end
function c66666616.counterfilter(c)
	return c:IsSetCard(0x661)
end
function c66666616.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x661) and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()~=6 and c:GetLevel()>0
end
function c66666616.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x661) and c:IsAbleToRemoveAsCost()
end
function c66666616.cgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666616.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetCustomActivityCount(66666616,tp,ACTIVITY_SPSUMMON)==0 end
	local rt=Duel.GetTargetCount(c66666616.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66666616.cfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66666616.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c66666616.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x661)
end
function c66666616.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66666616.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666616.filter,tp,LOCATION_MZONE,0,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666616.filter,tp,LOCATION_MZONE,0,1,ct,nil)
end
function c66666616.cgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetLevel()~=6 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(6)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
