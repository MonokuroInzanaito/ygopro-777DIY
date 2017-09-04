--KV-瓦萝尔
function c10957773.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c10957773.mfilter,4,4,c10957773.ovfilter,aux.Stringid(10957773,0),3,c10957773.xyzop)
	c:EnableReviveLimit()	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c10957773.aclimit)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c10957773.rmlimit)
	c:RegisterEffect(e4)
	--attach
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetDescription(aux.Stringid(10957773,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c10957773.condition)
	e5:SetTarget(c10957773.target)
	e5:SetOperation(c10957773.operation)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c10957773.value)
	c:RegisterEffect(e6)
end
function c10957773.mfilter(c)
	return c:IsRace(RACE_FAIRY) 
end
function c10957773.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x239) and c:IsType(TYPE_XYZ)
end
function c10957773.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10957773)==0 end
	Duel.RegisterFlagEffect(tp,10957773,RESET_PHASE+PHASE_END,0,1)
end
function c10957773.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_REMOVED and not re:GetHandler():IsImmuneToEffect(e)
end
function c10957773.rmlimit(e,c,p)
	return c:IsLocation(LOCATION_GRAVE)
end
function c10957773.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>1
end
function c10957773.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c10957773.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c10957773.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local og=c:GetOverlayGroup()
	if og:GetCount()==0 then return end
	Duel.SendtoGrave(og,REASON_EFFECT)
	Duel.Overlay(c,Group.FromCards(tc))
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c10957773.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10957773,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c10957773.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.Destroy(g,REASON_EFFECT+REASON_REVEAL)
	end
end
end
function c10957773.atkfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c10957773.value(e,c)
	return Duel.GetMatchingGroupCount(c10957773.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end
