--缘结的巫女 浅坂游
function c10981094.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10981094.target)
	e1:SetOperation(c10981094.operation)
	c:RegisterEffect(e1)	
end
function c10981094.filter(c)
	return c:IsFaceup()
end
function c10981094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10981094)==0 and Duel.IsExistingTarget(c10981094.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10981094.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c10981094.operation(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetFirstTarget()
	if gc:IsRelateToEffect(e) and gc:IsFaceup() then
		Duel.RegisterFlagEffect(tp,10981094,0,0,0)
		local e1=Effect.CreateEffect(gc)
	    e1:SetDescription(aux.Stringid(10981094,1))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCategory(CATEGORY_CONTROL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCost(c10981094.cost)
		e1:SetTarget(c10981094.cttg)
		e1:SetOperation(c10981094.ctop)
		gc:RegisterEffect(e1)
	end
end
function c10981094.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c10981094.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,FACE_UP) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,FACE_UP)
        Duel.HintSelection(g)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c10981094.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and c10981094.filter(tc) then
        c:SetCardTarget(tc)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_CONTROL)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(tp)
        e1:SetLabel(0)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetCondition(c10981094.ctcon)
        tc:RegisterEffect(e1)
		local a=c:GetAttack()
		local b=tc:GetAttack()
		if a<b then 
		local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(a)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(b)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c10981094.ctcon(e)
    local c=e:GetOwner()
    local h=e:GetHandler()
    return c:IsHasCardTarget(h)
end