--冻土毒虫 毒怪龙
function c11112050.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x15b),1)
	c:EnableReviveLimit()
	--1 token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11112050.tkcon)
	e1:SetCost(c11112050.tkcost)
	e1:SetTarget(c11112050.tktg)
	e1:SetOperation(c11112050.tkop)
	c:RegisterEffect(e1)
	--2 token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11112050)
	e2:SetCondition(c11112050.spcon)
	e2:SetTarget(c11112050.sptg)
	e2:SetOperation(c11112050.spop)
	c:RegisterEffect(e2)
end
function c11112050.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11112050.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c11112050.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11112051,0x15b,0x4011,-2,0,1,RACE_DRAGON,ATTRIBUTE_DARK) end	
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11112050.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11112051,0x15b,0x4011,-2,0,1,RACE_DRAGON,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,11112051)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function c11112050.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp~=tp and c:IsReason(REASON_DESTROY)
end
function c11112050.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	    and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11112051,0x15b,0x4011,-2,0,1,RACE_DRAGON,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112050.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(atk/2)
		tc:RegisterEffect(e1)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 
		    and Duel.IsPlayerCanSpecialSummonMonster(tp,11112051,0x15b,0x4011,-2,0,1,RACE_DRAGON,ATTRIBUTE_DARK) then
		    for i=1,2 do
		        local token=Duel.CreateToken(tp,11112051)
		        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		        local e1=Effect.CreateEffect(c)
			    e1:SetType(EFFECT_TYPE_SINGLE)
			    e1:SetCode(EFFECT_SET_ATTACK)
			    e1:SetValue(atk/2)
			    e1:SetReset(RESET_EVENT+0x1fe0000)
			    token:RegisterEffect(e1)
			end	
	        Duel.SpecialSummonComplete()
			Duel.BreakEffect()
	        Duel.DiscardDeck(tp,2,REASON_EFFECT)
		end	
	end
end