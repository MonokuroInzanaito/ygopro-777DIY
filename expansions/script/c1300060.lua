--虚拟歌姬 愈绫军
function c1300060.initial_effect(c)
	c:SetSPSummonOnce(1300060)
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
--  e1:SetDescription(aux.Stringid(1300060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c1300060.spcon)
	e1:SetTarget(c1300060.sptg)
	e1:SetOperation(c1300060.spop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c1300060.actlimit)
	c:RegisterEffect(e2)
end
function c1300060.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function c1300060.spfilter(c,player)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()==1300020 and c:GetPreviousControler()==player
end
function c1300060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1300060.spfilter,1,nil,tp)
end
function c1300060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsFaceup() 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c1300060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c1300060.indtg(e,c)
	return c:IsSetCard(0x130) and c~=e:GetHandler()
end
function c1300060.actlimit(e,re,tp)
	return (Duel.GetCurrentPhase()>=0x08 and Duel.GetCurrentPhase()<=0x80) and not re:GetHandler():IsImmuneToEffect(e)
end
