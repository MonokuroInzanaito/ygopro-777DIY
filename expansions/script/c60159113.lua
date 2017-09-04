--八枢罪 浅橘贪念
function c60159113.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60159113.mfilter,5,3,c60159113.ovfilter,aux.Stringid(60159113,0),3,c60159113.xyzop)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60159113.atkcon)
	e1:SetOperation(c60159113.sumsuc)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c60159113.condition)
	e2:SetOperation(c60159113.operation)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(c60159113.poscon)
	e3:SetOperation(c60159113.posop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c60159113.spcon)
	e4:SetTarget(c60159113.sptg)
	e4:SetOperation(c60159113.spop)
	c:RegisterEffect(e4)
end
function c60159113.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60159113.ovfilter(c)
	return c:IsFaceup() and c:GetLevel()==5 and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60159113.cfilter(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c60159113.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159113.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c60159113.cfilter,2,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60159113,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60159113.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetFlagEffect(60159113)>0
end
function c60159113.cfilter2(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c60159113.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60159113.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
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
function c60159113.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c60159113.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW and Duel.GetTurnPlayer()~=tp
end
function c60159113.operation(e,tp,eg,ep,ev,re,r,rp)
	--recover
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
    e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c60159113.condition2)
	e2:SetOperation(c60159113.operation2)
	Duel.RegisterEffect(e2,tp)
end
function c60159113.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60159113)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c60159113.poscon(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetAttacker()
	local lv=e:GetHandler():GetRank()
	if atk:IsType(TYPE_XYZ) then
		local rk=atk:GetRank()
		return e:GetHandler():IsPosition(POS_FACEUP) and rk>lv
	else
		local rk=atk:GetLevel()
		return e:GetHandler():IsPosition(POS_FACEUP) and rk>lv
	end
end
function c60159113.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetAttacker()
		if atk:IsType(TYPE_XYZ) then
			local rk=atk:GetRank()
			local lv=e:GetHandler():GetRank()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(rk*100)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
			c:RegisterEffect(e1)
		else
			local rk=atk:GetLevel()
			local lv=e:GetHandler():GetRank()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(rk*100)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
			c:RegisterEffect(e1)
		end
	end
end
function c60159113.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c60159113.spfilter(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60159113.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159113.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60159113.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159113.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end