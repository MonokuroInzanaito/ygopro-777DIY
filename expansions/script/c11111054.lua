--加油大魔王 死亡的帝穆斯
function c11111054.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,11111054)
	e1:SetCondition(c11111054.spcon)
	e1:SetOperation(c11111054.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--race change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111054.rccon)
	e2:SetOperation(c11111054.rcop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--remove & draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11111054,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,111110540)
	e3:SetCondition(c11111054.rmcon)
	e3:SetTarget(c11111054.rmtg)
	e3:SetOperation(c11111054.rmop)
	c:RegisterEffect(e3)
end
function c11111054.spfilter(c)
	return (c:GetLevel()>=8 or c:GetRank()>=8) and c:IsRace(RACE_SPELLCASTER+RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c11111054.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111054.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,c)
end
function c11111054.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111054.spfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetRace())
end
function c11111054.rccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c11111054.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(e:GetLabelObject():GetLabel())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c11111054.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c11111054.rmfilter(c,tp)
	return c:IsSetCard(0x15d) and not c:IsCode(11111054) and c:IsAbleToRemove() 
	    and Duel.IsExistingMatchingCard(c11111054.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c11111054.tgfilter(c,code)
	return c:IsSetCard(0x15d) and not c:IsCode(code) and c:IsAbleToGrave()
end
function c11111054.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11111054.rmfilter(chkc,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
	    and Duel.IsExistingTarget(c11111054.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11111054.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11111054.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c11111054.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end	
	end
end