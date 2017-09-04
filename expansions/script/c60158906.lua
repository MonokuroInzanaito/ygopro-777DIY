--抛却情感的恶魔
function c60158906.initial_effect(c)
	c:SetUniqueOnField(1,0,60158906)
	--xyz summon
	aux.AddXyzProcedure(c,c60158906.mfilter,7,3)
	c:EnableReviveLimit()
	--cannot target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
	--battle target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(aux.imval1)
    c:RegisterEffect(e5)
	--replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60158906)
    e1:SetCondition(c60158906.condition)
    e1:SetCost(c60158906.cost)
    e1:SetTarget(c60158906.target)
    e1:SetOperation(c60158906.operation)
    c:RegisterEffect(e1)
	local g=Group.CreateGroup()
    g:KeepAlive()
    e1:SetLabelObject(g)
end
function c60158906.mfilter(c)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60158906.filter(c)
    return true
end
function c60158906.condition(e,tp,eg,ep,ev,re,r,rp)
    if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()==0 then return false end
    local cg=g:Filter(c60158906.filter,nil)
    if cg:GetCount()>0 then
        e:GetLabelObject():Clear()
        e:GetLabelObject():Merge(cg)
        return true
    end
    return false
end
function c60158906.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60158906.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local op=0
    op=Duel.SelectOption(tp,aux.Stringid(60158906,0),aux.Stringid(60158906,1))
    e:SetLabel(op)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c60158906.operation(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==0 then
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	else
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
		end
	end
end