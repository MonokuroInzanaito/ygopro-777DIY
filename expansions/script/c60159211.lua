--澄 暮空
function c60159211.initial_effect(c)
	--only 1 can exists
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e21:SetCondition(c60159211.excon)
	c:RegisterEffect(e21)
	local e31=e21:Clone()
	e31:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e31)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD)
	e41:SetRange(LOCATION_MZONE)
	e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e41:SetTargetRange(1,0)
	e41:SetCode(EFFECT_CANNOT_SUMMON)
	e41:SetTarget(c60159211.sumlimit)
	c:RegisterEffect(e41)
	local e51=e41:Clone()
	e51:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e51)
	local e61=e41:Clone()
	e61:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e61)
	local e81=Effect.CreateEffect(c)
	e81:SetType(EFFECT_TYPE_FIELD)
	e81:SetCode(EFFECT_SELF_DESTROY)
	e81:SetRange(LOCATION_MZONE)
	e81:SetTargetRange(LOCATION_MZONE,0)
	e81:SetTarget(c60159211.destarget)
	c:RegisterEffect(e81)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5b25),4,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60159211,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60159211)
	e1:SetCost(c60159211.cost)
	e1:SetTarget(c60159211.target)
	e1:SetOperation(c60159211.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159211,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6019211)
	e2:SetCost(c60159211.cost)
	e2:SetTarget(c60159211.target2)
	e2:SetOperation(c60159211.operation2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c60159211.condition)
	e3:SetTarget(c60159211.target3)
	e3:SetOperation(c60159211.operation3)
	c:RegisterEffect(e3)
end
function c60159211.sumlimit(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_XYZ)
end
function c60159211.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_XYZ)
end
function c60159211.excon(e,tp)
	return Duel.IsExistingMatchingCard(c60159211.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159211.destarget(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_XYZ) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c60159211.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60159211.filter(c)
	return c:IsFaceup() and c:GetCounter(0x1137)>0
end
function c60159211.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c60159211.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60159211.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60159211.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c60159211.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c60159211.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c60159211.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c60159211.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER)
end
function c60159211.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60159211.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60159211.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c60159211.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60159211,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c60159211.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159211.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159211.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60159211.filter3(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60159211.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60159211.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end