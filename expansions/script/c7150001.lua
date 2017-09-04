--超越人生
function c7150001.initial_effect(c)
	 local a=Effect.CreateEffect(c)
	a:SetType(EFFECT_TYPE_ACTIVATE)
	a:SetCode(EVENT_FREE_CHAIN)
	a:SetTarget(c7150001.tga)
	a:SetOperation(c7150001.opa)
	a:SetCategory(CATEGORY_DRAW)
	c:RegisterEffect(a)
	if c7150001[0] then return end
	c7150001[0]=0
	c7150001[1]=0
	a=Effect.CreateEffect(c)
	a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	a:SetCode(EVENT_CHAINING)
	a:SetOperation(c7150001.opb)
	Duel.RegisterEffect(a,0)
end
function c7150001.f(c)return(c:GetAttack()==2200 or c:GetAttack()>2999)and c:IsFaceup()end
function c7150001.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7150001.f,tp,0,LOCATION_MZONE,1,nil)and c7150001[1-tp]<Duel.GetTurnCount()and Duel.IsPlayerCanDraw(tp,1)end
	local a=Effect.CreateEffect(e:GetHandler())
	a:SetType(EFFECT_TYPE_FIELD)
	a:SetCode(EFFECT_CANNOT_ACTIVATE)
	a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	a:SetTargetRange(1,0)
	a:SetReset(RESET_PHASE+PHASE_END)
	a:SetValue(function(e,r)return bit.band(r:GetActivateLocation(),LOCATION_ONFIELD)~=0 end)
	Duel.RegisterEffect(a,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c7150001.opa(e,tp)Duel.Draw(tp,1,REASON_EFFECT)end
function c7150001.opb(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)==0 then return end
	c7150001[ep]=Duel.GetTurnCount()
end
