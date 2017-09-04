--6th-改造体之御血少女
function c66600612.initial_effect(c)
	--xyz summon
	 aux.AddXyzProcedure(c,c66600612.matfilter,7,2)
	c:EnableReviveLimit()  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c66600612.con)
	e1:SetTarget(c66600612.tg)
	e1:SetOperation(c66600612.op)
	c:RegisterEffect(e1)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66600612,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c66600612.discon)
	e3:SetCost(c66600612.discost)
	e3:SetTarget(c66600612.distg)
	e3:SetOperation(c66600612.disop)
	c:RegisterEffect(e3)
end
function c66600612.matfilter(c)
	return c:IsSetCard(0x66e)
end
function c66600612.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e)
end
function c66600612.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c66600612.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66600612.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66600612.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66600612.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66600612.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(66600612,3))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_INDESTRUCTABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
function c66600612.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e) and c:GetBaseAttack()>0
end
function c66600612.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)  and rp~=tp
end
function c66600612.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600612.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66600612.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectTarget(tp,c66600612.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(sg:GetFirst():GetBaseAttack())
end
function c66600612.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local val=e:GetLabel()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c66600612.repop(val))
end
function c66600612.repop(val)
return function(e,tp,eg,ep,ev,re,r,rp)
	local s=Duel.SelectOption(tp,aux.Stringid(66600612,1),aux.Stringid(66600612,2))
	if s==0 then
		Duel.Recover(tp,val,REASON_EFFECT)
		Duel.Recover(1-tp,val,REASON_EFFECT)
	else
		Duel.Damage(tp,val,REASON_EFFECT)
		Duel.Damage(1-tp,val,REASON_EFFECT)
	end
end
end