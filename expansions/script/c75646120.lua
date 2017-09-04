--Stella-星珖
function c75646120.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c75646120.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c75646120.damcon)
	e2:SetOperation(c75646120.damop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(0x80200)
	e3:SetType(0x81)
	e3:SetCode(1014)
	e3:SetProperty(0x14010)
	e3:SetCost(c75646120.tgcost)
	e3:SetTarget(c75646120.tgtg)
	e3:SetOperation(c75646120.tgop)
	c:RegisterEffect(e3)
end
function c75646120.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x2,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,0x80+0x4000)
end
function c75646120.regop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsSetCard(0x62c3) then return end
	e:GetHandler():RegisterFlagEffect(75646120,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c75646120.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:GetFlagEffect(75646120)~=0
end
function c75646120.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,75646120)
	Duel.Damage(1-tp,100,0x40)
end
function c75646120.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsType(0x1) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646120.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x10) and c75646120.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingTarget(c75646120.filter,tp,0x10,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectTarget(tp,c75646120.filter,tp,0x10,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,0x200,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646120.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)~=0 then 
			Duel.Damage(1-tp,100,0x40)
		end 
	end
end