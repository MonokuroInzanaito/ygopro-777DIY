--幻想的童话王国
function c80100011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80100011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80100011.target)
	e1:SetOperation(c80100011.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	--lp recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80100011,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c80100011.chcon)
	e3:SetOperation(c80100011.lpop)
	c:RegisterEffect(e3)
	--cannot set/activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SSET)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c80100011.setlimit)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(1,0)
	e7:SetValue(c80100011.actlimit)
	c:RegisterEffect(e7)
	--spsummon limit
	local ee=Effect.CreateEffect(c)
	ee:SetType(EFFECT_TYPE_FIELD)
	ee:SetRange(LOCATION_FZONE)
	ee:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ee:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ee:SetTargetRange(1,1)
	ee:SetCondition(c80100011.sdcon)
	ee:SetTarget(c80100011.sumlimit)
	c:RegisterEffect(ee)
end
function c80100011.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x3400)
end
function c80100011.sdcon(e)
	return not Duel.IsExistingMatchingCard(c80100011.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80100011.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	--[[return se:IsActiveType(TYPE_MONSTER) and se:IsHasType(EFFECT_TYPE_ACTIONS) 
		and c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)]]
	return not c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA)
end
function c80100011.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c80100011.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80100011.chcon(e,tp,eg,ep,ev,re,r,rp)
	--[[local rc=re:GetHandler()
	return rc:GetType()==TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE)]]
	local tpe=re:GetActiveType()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tpe==TYPE_QUICKPLAY+TYPE_SPELL and rp==tp
		and e:GetHandler():GetFlagEffect(1)>0 
end
function c80100011.lpop(e,tp,eg,ep,ev,re,r,rp)
	--[[Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Recover(tp,800,REASON_EFFECT)]]
	local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_QUICKPLAY) then
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
		Duel.Recover(e:GetHandlerPlayer(),800,REASON_EFFECT)
	end
end
function c80100011.filter(c)
	return c:IsSetCard(0x3400) and c:IsAbleToHand()
end
function c80100011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80100011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80100011.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80100011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
