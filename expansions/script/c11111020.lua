--罪恶的编织者 大总管
function c11111020.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),9,3,c11111020.ovfilter,aux.Stringid(11111020,0))
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c11111020.atkval)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetDescription(aux.Stringid(11111020,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11111020)
	e2:SetCost(c11111020.cost)
	e2:SetTarget(c11111020.target)
	e2:SetOperation(c11111020.operation)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c11111020.incon)
	e3:SetValue(c11111020.inval)
	c:RegisterEffect(e3)
end
function c11111020.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==8 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x15d)
end
function c11111020.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c11111020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c11111020.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c11111020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c11111020.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111020.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c11111020.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c11111020.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	    if not Duel.GetControl(tc,tp) then
		    if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			    Duel.Destroy(tc,REASON_EFFECT)
		    end
        else
		    if tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER)
				and Duel.SelectYesNo(tp,aux.Stringid(11111020,2))then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
				if g:GetCount()>0 then
					local og=g:Select(tp,1,1,nil)
					Duel.Overlay(tc,og)
				end	
			end
	    end
	end	
end
function c11111020.infilter(c,p)
	return c:GetOwner()==p
end
function c11111020.incon(e,tp)
    local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c11111020.infilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),1-tp)
end
function c11111020.inval(e,te,tp)
	return tp~=e:GetHandlerPlayer()
end