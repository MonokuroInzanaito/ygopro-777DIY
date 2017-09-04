--爱之试练
function c18706065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(269012,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c18706065.damcon)
	e4:SetTarget(c18706065.damtg)
	e4:SetOperation(c18706065.damop)
	c:RegisterEffect(e4)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(269012,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c18706065.reccon)
	e4:SetTarget(c18706065.rectg)
	e4:SetOperation(c18706065.recop)
	c:RegisterEffect(e4)
end
function c18706065.damfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()==tp and c:IsSetCard(0xabb)
end
function c18706065.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18706065.damfilter,1,nil,tp)
end
function c18706065.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb) and c:IsType(TYPE_MONSTER)
end
function c18706065.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706065.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c18706065.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetCard(g)
end
function c18706065.damop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c18706065.filter,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(400)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c18706065.reccon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
	return des:IsType(TYPE_MONSTER) and rc:IsRelateToBattle() and rc:IsSetCard(0xabb) and rc:GetControler()==tp
end
function c18706065.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetMatchingGroupCount(c18706065.filter,tp,LOCATION_GRAVE,0,nil)*300
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c18706065.recop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(c18706065.filter,tp,LOCATION_GRAVE,0,nil)*300
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,val,REASON_EFFECT)
	if val>=2000 then 
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end