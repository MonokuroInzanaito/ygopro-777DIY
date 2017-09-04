--暗黑雾都
function c99999960.initial_effect(c)  
    c:SetUniqueOnField(1,0,99999960)
	--Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c99999960.actcon)
    c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c99999960.descon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c99999960.cost)
	e3:SetCondition(c99999960.con)
	e3:SetTarget(c99999960.destg)
	e3:SetOperation(c99999960.desop)
	c:RegisterEffect(e3)
	--burn
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c99999960.damcon)
	e4:SetTarget(c99999960.damtg)
	e4:SetOperation(c99999960.damop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c99999960.actfilter(c)
	return c:IsFaceup() and c:IsCode(99999961) 
end
function c99999960.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99999960.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99999960.descon(e)
	return not Duel.IsExistingMatchingCard(c99999960.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c99999960.sfilter(c)
	return c:IsCode(99999961) and  c:IsFaceup()  and c:GetOverlayCount()==0
end
function c99999960.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c99999960.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsCode(99999961) then
	if bc:IsDestructable() or bc:IsSetCard(0xabb) and bc:IsFaceup() and bc:IsControlerCanBeChanged() and  not bc:IsType(TYPE_TOKEN) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
end
function c99999960.destg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
	local bc=e:GetLabelObject()
	if not  bc:IsSetCard(0xabb) and bc:IsFaceup() and bc:IsControlerCanBeChanged() and  not bc:IsType(TYPE_TOKEN) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
end
function c99999960.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() 
	and Duel.IsExistingMatchingCard(c99999960.actfilter,tp,LOCATION_MZONE,0,1,nil) then
	if bc:IsSetCard(0xabb) and bc:IsFaceup() and bc:IsControlerCanBeChanged() and  not bc:IsType(TYPE_TOKEN) then
	 local og=bc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		local tg=Duel.SelectMatchingCard(tp,c99999960.actfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Overlay(tg:GetFirst(),Group.FromCards(bc))
	else
	Duel.Destroy(bc,REASON_EFFECT)
	end
end
end
function c99999960.dafilter(c,sp)
	return c:GetSummonPlayer()==sp and c:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c99999960.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99999960.dafilter,1,nil,1-tp)
end
function c99999960.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c99999960.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c99999960.dafilter,nil,1-tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
end