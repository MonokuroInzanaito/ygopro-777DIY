--死亡线圈
function c75646312.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x0010)
	e1:SetCode(1002)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x0002)
	e3:SetCode(100)
	e3:SetRange(0x8)
	e3:SetTargetRange(0x4,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x32c3))
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x4)
	e2:SetType(0x201)
	e2:SetProperty(0x14000)
	e2:SetCode(1011)
	e2:SetCondition(c75646312.con)
	e2:SetTarget(c75646312.cointg)
	e2:SetOperation(c75646312.op)
	c:RegisterEffect(e2)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(0x2+0x800)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+0x400)
	e4:SetRange(0x8)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c75646312.recon)
	e4:SetOperation(c75646312.reop)
	c:RegisterEffect(e4)
end
function c75646312.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c75646312.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.IsExistingTarget(Card.IsAbleToRemoveAsCost,tp,0xc,0,1,c)  and Duel.SelectYesNo(tp,aux.Stringid(75646312,0)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,0xc,0,1,1,nil)
		Duel.Remove(g,0x5,0x80)
	else Duel.Remove(c,0x5,0x80) end
end
function c75646312.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(0x5) and e:GetHandler():IsPreviousLocation(0x08)
end
function c75646312.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c75646312.op(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.Hint(3,tp,503)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,0xc,1,1,nil)
	if tc then
		Duel.Remove(tc,0x5,0x40)
	end
	else Duel.Hint(3,tp,503)
	local tc=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0xc,0,1,1,nil)
	if tc then
		Duel.Remove(tc,0x5,0x40)
	end end
end