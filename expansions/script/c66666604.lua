--星之华的流星-野兔
function c66666604.initial_effect(c)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetCondition(c66666604.remcon)
	c:RegisterEffect(e1)
	--to Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666604,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c66666604.tgcon)
	e2:SetTarget(c66666604.tgtg)
	e2:SetOperation(c66666604.tgop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666604,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCost(c66666604.remcost)
	e3:SetTarget(c66666604.remtg)
	e3:SetOperation(c66666604.remop)
	c:RegisterEffect(e3)
end
function c66666604.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_DECK
end
function c66666604.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND)
end
function c66666604.filter(c)
	return c:IsSetCard(0x661) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_REMOVED) or c:IsAbleToRemove())
end
function c66666604.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and c66666604.filter(chkc) end
	local s1=Duel.IsExistingTarget(c66666604.filter,tp,LOCATION_REMOVED,0,1,nil)
	local s2=Duel.IsExistingTarget(c66666604.filter,tp,LOCATION_GRAVE,0,1,nil)
	local g=Group.CreateGroup()
	local se=0
	if chk==0 then return s1 or s2 end	
	if s1 and not s2 then
		se=1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectTarget(tp,c66666604.filter,tp,LOCATION_REMOVED,0,1,2,nil)
	elseif s2 and not s1 then
		se=2
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectTarget(tp,c66666604.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	else
		se=Duel.SelectOption(tp,aux.Stringid(66666604,1),aux.Stringid(66666604,3))+1
		if se==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g=Duel.SelectTarget(tp,c66666604.filter,tp,LOCATION_REMOVED,0,1,2,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g=Duel.SelectTarget(tp,c66666604.filter,tp,LOCATION_GRAVE,0,1,2,nil)
		end
	end
	e:SetLabel(se)
	Duel.SetOperationInfo(0,c66666604.l[se],g,g:GetCount(),0,0)
end
c66666604.l={[1]=CATEGORY_TOGRAVE,[2]=CATEGORY_REMOVE}
function c66666604.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	local se=e:GetLabel()
	if sg:GetCount()>0 then
		if se==1 then
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		else
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c66666604.remfilter(c)
	return c:IsSetCard(0x661) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c66666604.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666604.remop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66666604.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666604.remfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66666604.remfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end