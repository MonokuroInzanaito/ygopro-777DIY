--骗术，虚伪or幸福？
function c66612316.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66612316,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66612316)
	e1:SetTarget(c66612316.target)
	e1:SetOperation(c66612316.activate)
	c:RegisterEffect(e1)
end
function c66612316.filter1(c)
	return c:IsSetCard(0x660) and c:IsAbleToRemove()   and c:IsType(TYPE_MONSTER)
end
function c66612316.filter2(c)
	return c:IsSetCard(0x660) and  c:IsAbleToGrave()   and c:IsType(TYPE_MONSTER)
end
function c66612316.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and 
	(Duel.IsExistingMatchingCard(c66612316.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) or 
	Duel.IsExistingMatchingCard(c66612316.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c66612316.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>1 then
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c66612316.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then t[p]=aux.Stringid(66612316,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c66612316.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then t[p]=aux.Stringid(66612316,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66612316,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(66612316,0)
	local sg=nil
	if opt==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	sg=Duel.SelectMatchingCard(tp,c66612316.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif opt==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	sg=Duel.SelectMatchingCard(tp,c66612316.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end