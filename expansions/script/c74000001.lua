--龙藏的宝壶
function c74000001.initial_effect(c)
	c:SetUniqueOnField(1,0,74000001)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74000001,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c74000001.discon)
	e1:SetTarget(c74000001.distg)
	e1:SetOperation(c74000001.disop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74000001,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c74000001.thtg)
	e2:SetOperation(c74000001.thop)
	c:RegisterEffect(e2)
end
function c74000001.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c74000001.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c74000001.filter(c)
	return c:IsRace(RACE_DRAGON) or c:IsRace(RACE_DINOSAUR) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_WYRM)
		and c:IsAbleToRemove()
end
function c74000001.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	local g=Duel.GetMatchingGroup(c74000001.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local rand=math.random(1,g:GetCount())
		local tc=g:GetFirst()
		while rand>1 do
			tc=g:GetNext()
			rand=rand-1
		end
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		tc:RegisterFlagEffect(74000001,RESET_EVENT+0x1fe0000,0,1)
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleDeck(tp)
	end
end
function c74000001.filter2(c)
	return c:GetFlagEffect(74000001)~=0
end
function c74000001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c74000001.filter2,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c74000001.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c74000001.filter2,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end