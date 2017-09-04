--魔法蓝宝石
function c99991033.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99991033.target)
	e1:SetOperation(c99991033.operation)
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
	e3:SetValue(c99991033.eqlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99991033,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c99991033.con)
	e4:SetTarget(c99991033.tg)
	e4:SetOperation(c99991033.op)
	c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(99991033,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1,99991033)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCost(c99991033.spcost)
    e5:SetTarget(c99991033.sptg)
    e5:SetOperation(c99991033.spop)
    c:RegisterEffect(e5)
end
function c99991033.eqlimit(e,c)
	return c:IsSetCard(0xabb) or c:IsRace(RACE_SPELLCASTER)
end
function c99991033.eqfilter1(c)
	return c:IsFaceup() and (c:IsRace(RACE_SPELLCASTER) or c:IsSetCard(0xabb))
end
function c99991033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99991033.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99991033.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99991033.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99991033.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c99991033.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsSetCard(0xcabb)
end
function c99991033.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99991096,1))
    local g0=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    local tc=g0:GetFirst()
    local seq=tc:GetSequence()
    if tc:IsLocation(LOCATION_MZONE) then
        local g=Group.FromCards(tc)  
        dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
        if dc then g:AddCard(dc) end
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    elseif tc:IsLocation(LOCATION_SZONE) and seq<5 then
        local g=Group.FromCards(tc)
        dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
        if dc then g:AddCard(dc) end
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    else
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
end
function c99991033.op(e,tp,eg,ep,ev,re,r,rp)
	local seq=Duel.GetFirstTarget():GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq)
	if tc then g:AddCard(tc) end
	Duel.Destroy(g,REASON_EFFECT)
end
function c99991033.costfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c99991033.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99991033.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c99991033.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99991033.spfilter(c,e,tp)
	local lv=0
	if e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) then lv=e:GetHandler():GetEquipTarget():GetRank()
	else lv=e:GetHandler():GetEquipTarget():GetLevel() end
	return c:IsSetCard(0xcabb) and e:GetHandler():GetEquipTarget():IsCanBeSynchroMaterial(c) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv+1
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c99991033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99991033.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel()) 
		or Duel.IsExistingMatchingCard(c99991033.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99991033.spop(e,tp,eg,ep,ev,re,r,rp)
	  if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc:IsFacedown()  or tc:IsImmuneToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c99991033.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
        Duel.SendtoGrave(tc,REASON_EFFECT)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)==0 then return end
        Duel.BreakEffect()
		Duel.Equip(tp,e:GetHandler(),sc)
        local e1=Effect.CreateEffect(sc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c99991033.eqlimit)
        e:GetHandler():RegisterEffect(e1)
	end
end
