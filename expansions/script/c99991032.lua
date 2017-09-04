--魔法红宝石
function c99991032.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99991032.target)
	e1:SetOperation(c99991032.operation)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--def up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	e0:SetValue(400)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c99991032.eqlimit)
	c:RegisterEffect(e3)   
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetCondition(c99991032.con)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(99991032,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1,99991032)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCost(c99991032.spcost)
    e5:SetTarget(c99991032.sptg)
    e5:SetOperation(c99991032.spop)
    c:RegisterEffect(e5)
end
function c99991032.eqlimit(e,c)
	return c:IsSetCard(0xabb) or c:IsRace(RACE_SPELLCASTER)
end
function c99991032.eqfilter1(c)
	return c:IsFaceup() and (c:IsRace(RACE_SPELLCASTER) or c:IsSetCard(0xabb))
end
function c99991032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99991032.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99991032.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99991032.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99991032.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c99991032.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsSetCard(0xcabb)
end
function c99991032.costfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c99991032.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99991032.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c99991032.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99991032.spfilter(c,e,tp)
	local rank=0
	if not e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) then rank=e:GetHandler():GetEquipTarget():GetLevel()
	else rank=e:GetHandler():GetEquipTarget():GetRank() end
	return c:IsSetCard(0xcabb) and e:GetHandler():GetEquipTarget():IsCanBeXyzMaterial(c) and c:GetRank()==rank+1
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99991032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99991032.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel()) 
		or Duel.IsExistingMatchingCard(c99991032.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99991032.spop(e,tp,eg,ep,ev,re,r,rp)
	  if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc:IsFacedown()  or tc:IsImmuneToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c99991032.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)==0 then return end
       Duel.BreakEffect()
    	Duel.Equip(tp,e:GetHandler(),sc)
        local e1=Effect.CreateEffect(sc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c99991032.eqlimit)
        e:GetHandler():RegisterEffect(e1)
	end
end