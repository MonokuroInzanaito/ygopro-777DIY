--澄 心之守护者
function c60159210.initial_effect(c)
	--only 1 can exists
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e21:SetCondition(c60159210.excon)
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
	e41:SetTarget(c60159210.sumlimit)
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
	e81:SetTarget(c60159210.destarget)
	c:RegisterEffect(e81)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5b25),aux.NonTuner(Card.IsSetCard,0x5b25),1)
	c:EnableReviveLimit()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c60159210.imcon)
	e2:SetTarget(c60159210.imtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60159210)
	e1:SetCondition(c60159210.condition)
	e1:SetTarget(c60159210.target)
	e1:SetOperation(c60159210.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159210,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,6019210)
	e2:SetCondition(c60159210.condition2)
	e2:SetTarget(c60159210.sptg)
	e2:SetOperation(c60159210.spop)
	c:RegisterEffect(e2)
end
function c60159210.sumlimit(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_SYNCHRO)
end
function c60159210.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_SYNCHRO)
end
function c60159210.excon(e,tp)
	return Duel.IsExistingMatchingCard(c60159210.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159210.destarget(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_SYNCHRO) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c60159210.imcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCounter(tp,1,1,0x1137)>2
end
function c60159210.imtg(e,c)
	return c:IsSetCard(0x5b25) and not c:IsCode(60159210)
end
function c60159210.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if eg:GetCount()==1 and tc:GetPreviousControler()==tp and tc:IsSetCard(0x5b25) and tc:IsType(TYPE_MONSTER) then
		e:SetLabel(tc:GetCode())
		return true
	else return false end
end
function c60159210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60159210.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and eg:GetCount()==1 then
		if Duel.SendtoHand(eg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,eg)
			Duel.BreakEffect()
			local c=e:GetHandler()
			if c:IsFaceup() and c:IsRelateToEffect(e) then
				c:AddCounter(0x1137,2)
			end
		end
	end
end
function c60159210.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159210.filter(c,e,tp)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159210.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c60159210.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60159210.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60159210.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60159210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c60159210.efilter)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetOwnerPlayer(tp)
		tc:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
function c60159210.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
