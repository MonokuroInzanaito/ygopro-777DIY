--天辉团-恐厄之蝶 蜜拉贝儿
function c29201128.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c29201128.mfilter1,c29201128.mfilter2,true)
	c:EnableReviveLimit()
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c29201128.spcon)
	e2:SetOperation(c29201128.spop)
	c:RegisterEffect(e2)
	--extra summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	c:RegisterEffect(e5)
	--search
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(29201128,0))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e10:SetTarget(c29201128.thtg)
	e10:SetOperation(c29201128.tgop)
	c:RegisterEffect(e10)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c29201128.thtg2)
	e3:SetOperation(c29201128.thop2)
	c:RegisterEffect(e3)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,29201128)
    e1:SetTarget(c29201128.sptg1)
    e1:SetOperation(c29201128.spop1)
    c:RegisterEffect(e1)
end
function c29201128.filter(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsDestructable()
end
function c29201128.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201128.filter(chkc) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then
        if ft<-1 then return false end
        return e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false)
            and Duel.IsExistingTarget(c29201128.filter,tp,LOCATION_ONFIELD,0,2,nil)
            and (ft>0 or Duel.IsExistingTarget(c29201128.filter,tp,LOCATION_MZONE,0,-ft+1,nil))
    end
    local g=nil
    if ft~=0 then
        local loc=LOCATION_ONFIELD
        if ft<0 then loc=LOCATION_MZONE end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        g=Duel.SelectTarget(tp,c29201128.filter,tp,loc,0,2,2,nil)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        g=Duel.SelectTarget(tp,c29201128.filter,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g2=Duel.SelectTarget(tp,c29201128.filter,tp,LOCATION_ONFIELD,0,1,1,g:GetFirst())
        g:Merge(g2)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201128.spop1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
            Duel.SendtoGrave(c,REASON_RULE)
        end
    end
end
function c29201128.mfilter1(c)
	return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201128.mfilter2(c)
	return c:GetLevel()==8 and c:IsType(TYPE_PENDULUM)
end
function c29201128.spfilter1(c,tp,fc)
	return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c29201128.spfilter2,1,c,fc)
end
function c29201128.spfilter2(c,fc)
	return c:GetLevel()==8 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201128.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c29201128.spfilter1,1,nil,tp,c)
end
function c29201128.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c29201128.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c29201128.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201128.spfilter4(c,e,tp)
	return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsAbleToHand()
end
function c29201128.spfilter3(c)
	return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_PENDULUM)
end
function c29201128.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c29201128.spfilter4,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c29201128.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29201128.spfilter4,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg3=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.ConfirmCards(1-tp,sg1)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local cg=sg1:Select(1-tp,1,1,nil)
        local tc=cg:GetFirst()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        sg1:RemoveCard(tc)
        --Duel.SendtoGrave(sg1,REASON_EFFECT)
		Duel.SendtoExtraP(sg1,nil,REASON_EFFECT)
    end
end
function c29201128.thfilter2(c)
	return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE))
end
function c29201128.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29201128.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c29201128.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29201128.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
