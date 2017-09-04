--巨怪工厂 过载巨虫
function c20322001.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c20322001.splimit)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(c20322001.spcon)
	e2:SetOperation(c20322001.spop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c20322001.tgcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetTarget(c20322001.destg)
	e4:SetOperation(c20322001.desop)
	c:RegisterEffect(e4)
end
function c20322001.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x282)
end
function c20322001.spfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x282) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c20322001.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c20322001.spfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsReleasable()
end
function c20322001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c20322001.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c20322001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c20322001.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c20322001.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c20322001.tgcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() or ph<PHASE_MAIN1 or ph>PHASE_MAIN2
end
function c20322001.filter(c,atk)
	return c:GetDefense()<=atk/2 and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c20322001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c20322001.filter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	local num=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,num,1-tp,LOCATION_MZONE)
end
function c20322001.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20322001.filter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	if g:GetCount()<=0 then return end
	Duel.Destroy(g,REASON_EFFECT)
end