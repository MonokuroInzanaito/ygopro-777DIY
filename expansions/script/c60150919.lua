--幻想曲T致命旋律 诱惑之摩纳
function c60150919.initial_effect(c)
    c:EnableReviveLimit()
	--synchro summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60150917,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(aux.SynCondition(c60150919.tfilter,aux.NonTuner(c60150919.tfilter),1,99))
    e1:SetTarget(aux.SynTarget(c60150919.tfilter,aux.NonTuner(c60150919.tfilter),1,99))
    e1:SetOperation(aux.SynOperation(c60150919.tfilter,aux.NonTuner(c60150919.tfilter),1,99))
    e1:SetValue(SUMMON_TYPE_SYNCHRO)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetDescription(aux.Stringid(60150917,1))
    e2:SetCondition(c60150919.spcon2)
    e2:SetOperation(c60150919.spop2)
    e2:SetValue(SUMMON_TYPE_SYNCHRO)
    c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150932,0))
	e4:SetCategory(CATEGORY_CONTROL+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,60150919)
	e4:SetCost(c60150919.cost)
	e4:SetCondition(c60150919.negcon)
	e4:SetTarget(c60150919.target)
	e4:SetOperation(c60150919.negop)
	c:RegisterEffect(e4)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60150919.condition)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c60150919.condition)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--e target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60150919.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(60150917,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c60150919.spcon)
	e6:SetTarget(c60150919.sptg)
	e6:SetOperation(c60150919.spop)
	c:RegisterEffect(e6)
end
function c60150919.tfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c60150919.sprfilter1(c,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and c:IsSetCard(0x6b23) and c:IsCanBeSynchroMaterial()
		and Duel.IsExistingMatchingCard(c60150919.sprfilter2,tp,LOCATION_MZONE,0,1,nil,lv) 
end
function c60150919.sprfilter2(c,lv)
	return c:IsFaceup() and c:GetLevel()~=lv and c:GetLevel()+lv==9 and c:IsType(TYPE_TOKEN)
	and c:IsSetCard(0x6b23) and c:IsCanBeSynchroMaterial()
end
function c60150919.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c60150919.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c60150919.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c60150919.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c60150919.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c60150919.cfilter(c,tp)
	return c:IsSetCard(0x6b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c60150919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150919.cfilter,tp,LOCATION_HAND,LOCATION_DECK,1,nil,tp) end
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150919.cfilter,tp,LOCATION_HAND,LOCATION_DECK,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60150919.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60150919.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c60150919.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	 local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c60150919.cfilter2(c)
	return c:IsFaceup()
end
function c60150919.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60150919.cfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c60150919.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2 and e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60150919.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
end
function c60150919.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6b23) and c:IsFaceup()
end
function c60150919.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c60150919.spfilter,tp,0,LOCATION_DECK,1,nil) end
end
function c60150919.spop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150917,3))
	local g=Duel.SelectMatchingCard(tp,c60150919.spfilter,tp,0,LOCATION_DECK,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(1-tp,1)
	end
end