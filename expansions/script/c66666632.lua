--星辉碎梦
function c66666632.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(c66666632.thtg)
	e1:SetOperation(c66666632.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c66666632.indtg)
	e2:SetValue(c66666632.indval)
	c:RegisterEffect(e2)
end
function c66666632.spfilter(c,e,tp)
	return c:IsSetCard(0x661) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66666632.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666632.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c66666632.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(66666632,0)) then 
		local g=Duel.SelectMatchingCard(tp,c66666632.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c66666632.indtg(e,c)
	return c:IsSetCard(0x663) and c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c66666632.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end