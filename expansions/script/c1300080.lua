--虚拟歌姬 心势军
function c1300080.initial_effect(c)
	c:SetSPSummonOnce(1300080)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
--  e1:SetDescription(aux.Stringid(1300080,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c1300080.spcon)
	e1:SetTarget(c1300080.sptg)
	e1:SetOperation(c1300080.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(function(e)
		return Duel.GetCustomActivityCount(1300080,1-e:GetHandlerPlayer(),ACTIVITY_CHAIN)>=2 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
		--return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and c1300080[1-e:GetHandlerPlayer()]>=2
	end)
	e3:SetValue(function(e,re,tp)
		return not re:GetHandler():IsImmuneToEffect(e)
	end)
	c:RegisterEffect(e3)
	--[[if not c1300080.gchk then
		c1300080.gchk=true
		c1300080[0]=0
		c1300080[1]=0
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c1300080[ep]=c1300080[ep]+1
			Debug.ShowHint(c1300080[ep])
		end)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c1300080[ep]=math.max(c1300080[ep]-1,0)
		end)
		Duel.RegisterEffect(e2,0)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c1300080[0]=0
			c1300080[1]=0
		end)
		Duel.RegisterEffect(e1,0)
	end]]
	Duel.AddCustomActivityCounter(1300080,ACTIVITY_CHAIN,aux.FALSE)
end
function c1300080.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function c1300080.spfilter(c,player)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()==1300030 and c:GetPreviousControler()==player
end
function c1300080.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1300080.spfilter,1,nil,tp)
end
function c1300080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsFaceup() 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c1300080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) then
			local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
			if g:GetCount()>0 and g:GetFirst():IsAbleToRemove() then
				Duel.BreakEffect()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end