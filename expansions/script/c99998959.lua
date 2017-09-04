--第六天魔王波旬 织田信长
function c99998959.initial_effect(c)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99998959+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c99998959.tgcon)
	e1:SetTarget(c99998959.tgtg)
	e1:SetOperation(c99998959.tgop)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(c99998959.sumlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTarget(c99998959.distg)
	c:RegisterEffect(e4)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9999110,12))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,99998959+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(c99998959.con)
	e5:SetCost(c99998959.cost)
	e5:SetTarget(c99998959.tg)
	e5:SetOperation(c99998959.op)
	c:RegisterEffect(e5)
end
function c99998959.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c99998959.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c99998959.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c99998959.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLevelAbove(e:GetHandler():GetLevel()) or c:IsRankAbove(e:GetHandler():GetLevel())
end
function c99998959.distg(e,c)
	return (c:IsLevelAbove(e:GetHandler():GetLevel()) or c:IsRankAbove(e:GetHandler():GetLevel()))
end
function c99998959.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c99998959.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local sg=g:Select(tp,1,2,nil)
	Duel.SendtoGrave(sg,REASON_COST)
	local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	e:SetLabel(ct)
	Duel.RegisterFlagEffect(tp,99998959,RESET_EVENT+0x1fe0000,0,1)
end
function c99998959.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFlagEffect(tp,99998959)==0  end
end
function c99998959.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 and e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
