--八枢罪 绯色怒火
function c60159115.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60159115.mfilter,5,3,c60159115.ovfilter,aux.Stringid(60159115,0),3,c60159115.xyzop)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60159115.atkcon)
	e1:SetOperation(c60159115.sumsuc)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(c60159115.indval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c60159115.indval2)
	c:RegisterEffect(e3)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCountLimit(2)
	e5:SetCondition(c60159115.condition)
	e5:SetTarget(c60159115.target)
	e5:SetOperation(c60159115.activate)
	c:RegisterEffect(e5)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c60159115.spcon)
	e4:SetTarget(c60159115.sptg)
	e4:SetOperation(c60159115.spop)
	c:RegisterEffect(e4)
end
function c60159115.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60159115.ovfilter(c)
	return c:IsFaceup() and c:GetLevel()==5 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60159115.cfilter(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c60159115.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159115.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c60159115.cfilter,2,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60159115,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60159115.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetFlagEffect(60159115)>0
end
function c60159115.cfilter2(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c60159115.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60159115.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc2=g:GetFirst()
		while tc2 do
			if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
			tc2=g:GetNext()
		end
		Duel.Remove(g,POS_FACEUP,REASON_RULE)
	end
end
function c60159115.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_EFFECT) and aux.TRUE(e,re,rp)
end
function c60159115.indval2(e,re,tp)
	return tp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_EFFECT)
end
function c60159115.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:GetHandler():IsOnField()
end
function c60159115.filter(c,rc)
	return c~=rc and c:IsDestructable()
end
function c60159115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159115.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),re:GetHandler()) end
	local g=Duel.GetMatchingGroup(c60159115.filter,tp,0,LOCATION_ONFIELD,e:GetHandler(),re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60159115.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c60159115.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),re:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c60159115.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c60159115.spfilter(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60159115.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159115.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60159115.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159115.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end