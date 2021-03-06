--布洛妮娅 扎伊切克
function c75646502.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646502.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(c75646502.xyzlimit)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,75646502)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c75646502.descost)
	e3:SetTarget(c75646502.destg)
	e3:SetOperation(c75646502.desop)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c75646502.con)
	e4:SetValue(c75646502.aclimit)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c75646502.con1)
	e5:SetTarget(c75646502.tg)
	e5:SetOperation(c75646502.op)
	c:RegisterEffect(e5)
end
function c75646502.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c5) and c:IsType(TYPE_MONSTER)
end
function c75646502.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c75646502.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c75646502.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2c5)
end
function c75646502.filter2(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c75646502.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():IsExists(c75646502.filter2,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,c75646502.filter2,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646502.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c75646502.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c75646502.filter4(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP)
end
function c75646502.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetEquipGroup():FilterCount(c75646502.filter4,nil)>0 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c75646502.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_EQUIP) and re:GetHandler():IsOnField()
		and re:GetHandler():IsSetCard(0x2c5) and re:GetHandler():GetEquipTarget()==e:GetHandler()
		and not re:GetHandler():IsImmuneToEffect(e)
end
function c75646502.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c75646502.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP) and c:GetEquipTarget()==ec
end
function c75646502.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c75646502.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646500,0))
	local g=Duel.SelectTarget(tp,c75646502.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
end
function c75646502.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c75646502.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
	end
end
function c75646502.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end