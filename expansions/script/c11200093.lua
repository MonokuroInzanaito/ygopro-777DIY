--传说之狂战士 罪歌
function c11200093.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c11200093.ffilter,c11200093.ffilter2,true)
	--cannot disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(0)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,11200093)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c11200093.tg)
	e2:SetOperation(c11200093.op)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c11200093.becon)
	c:RegisterEffect(e4)
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27346636,1))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c11200093.sprcon)
	e5:SetOperation(c11200093.sprop)
	c:RegisterEffect(e5)
	--sp
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11200093,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,11200093+EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(c11200093.spcon)
	e6:SetTarget(c11200093.sptg)
	e6:SetOperation(c11200093.spop)
	c:RegisterEffect(e6)
end
function c11200093.ffilter(c)
	return   c:IsFusionAttribute(ATTRIBUTE_DARK) 
end
function c11200093.ffilter2(c)
	return   (c:IsFusionSetCard(0xbab)  or c:IsFusionSetCard(0x2e0)
   or c:IsFusionSetCard(0x2e1) or c:IsFusionSetCard(0x2e7))  and c:IsType(TYPE_MONSTER)
end
function c11200093.filter(c)
	local code=c:GetCode()
	return (code==11200013) and c:IsAbleToHand()
end
function c11200093.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200093.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11200093.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c11200093.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	 if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Equip(tp,tc,c)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
function c11200093.becon(e)
	return e:GetHandler():IsAttackable()
end
function c11200093.spfilter0(c,tp,fc)
	return  c:IsFusionAttribute(ATTRIBUTE_DARK)  and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
	and Duel.IsExistingMatchingCard(c11200093.spfilter1,tp,LOCATION_MZONE,0,1,c,tp,fc)
end
function c11200093.spfilter1(c,tp,fc)
	return  (c:IsFusionSetCard(0xbab)  or c:IsFusionSetCard(0x2e0)
   or c:IsFusionSetCard(0x2e1) or c:IsFusionSetCard(0x2e7))  and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
end
function c11200093.spfilter2(c)
	return c:IsType(TYPE_EQUIP)  and c:IsAbleToGraveAsCost()
end
function c11200093.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c11200093.spfilter0,tp,LOCATION_MZONE,0,1,nil,tp,c)
		and Duel.IsExistingMatchingCard(c11200093.spfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c11200093.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c11200093.spfilter0,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c11200093.spfilter1,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c)
	local g3=Duel.SelectMatchingCard(tp,c11200093.spfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c11200093.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not tc:IsControler(tp) then
	tc=Duel.GetAttackTarget()
	bc=Duel.GetAttacker()
	end
	return (tc and tc:IsFaceup() and tc:IsCode(11200094)) and bc
end
function c11200093.tgfilter(c,e,tp)
	return  c:IsCode(11200093) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c11200093.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	local g1=Duel.GetAttackTarget()
	local g2=Duel.GetAttacker()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,FromCards(g1,g2),2,0,LOCATION_MZONE)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11200093.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local g1=Duel.GetAttackTarget()
	local g2=Duel.GetAttacker()
	if (g1 or g2) and Duel.SendtoGrave(FromCards(g1,g2),REASON_EFFECT)>0  then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c11200093.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end