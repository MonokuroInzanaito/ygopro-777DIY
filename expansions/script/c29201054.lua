--镜世录 亡我
function c29201054.initial_effect(c)
	c:SetSPSummonOnce(29201054)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29201054,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c29201054.spcost)
	e1:SetTarget(c29201054.sptg)
	e1:SetOperation(c29201054.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_LEAVE_FIELD)
	e12:SetOperation(c29201054.desop)
	c:RegisterEffect(e12)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c29201054.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c29201054.pencon)
	e4:SetTarget(c29201054.pentg)
	e4:SetOperation(c29201054.penop)
	c:RegisterEffect(e4)
	--cannot trigger
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_TRIGGER)
	ea:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetTargetRange(0xa,0xa)
	ea:SetTarget(c29201054.distg)
	c:RegisterEffect(ea)
	local e5=ea:Clone()
	e5:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e5)
	--disable
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_DISABLE)
	eb:SetRange(LOCATION_MZONE)
	eb:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	eb:SetTarget(c29201054.distg)
	c:RegisterEffect(eb)
	local e6=eb:Clone()
	e6:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e6)
	--disable effect
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ec:SetCode(EVENT_CHAIN_SOLVING)
	ec:SetRange(LOCATION_MZONE)
	ec:SetOperation(c29201054.disop)
	c:RegisterEffect(ec)
	local e7=ec:Clone()
	e7:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e7)
	--disable trap monster
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD)
	ed:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	ed:SetRange(LOCATION_MZONE)
	ed:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ed:SetTarget(c29201054.distg)
	c:RegisterEffect(ed)
	local e8=ed:Clone()
	e8:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e8)
	--return hand
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(29201054,0))
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(c29201054.thcon)
	e10:SetTarget(c29201054.thtg)
	e10:SetOperation(c29201054.thop)
	c:RegisterEffect(e10)
end
function c29201054.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c29201054.atkval(e,c)
	return Duel.GetMatchingGroupCount(c29201054.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*200
end
function c29201054.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function c29201054.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
function c29201054.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c29201054.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29201054.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29201054.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c29201054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c29201054.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201054.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x63e0) and c:IsDestructable()
end
function c29201054.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c29201054.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29201054.desfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c29201054.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29201054.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c29201054.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c29201054.efilter(c)
	return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
end
function c29201054.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c29201054.efilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29201054.efilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft>5 then ft=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c29201054.efilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,5,0,0)
end
function c29201054.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		if sg:GetCount()>ft then
			local rg=sg:Select(tp,ft,ft,nil)
			sg=rg
		end
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			c:SetCardTarget(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
			tc=sg:GetNext()
		end
	end
end
function c29201054.desfilter58(c,rc)
	return rc:IsHasCardTarget(c)
end
function c29201054.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29201054.desfilter58,tp,LOCATION_SZONE,LOCATION_SZONE,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end

