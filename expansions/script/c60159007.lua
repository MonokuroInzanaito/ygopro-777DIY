--伊裴 飞舞的夜空
function c60159007.initial_effect(c)
	--synchro limit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e12:SetValue(c60159007.synlimit)
    c:RegisterEffect(e12)
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60159007)
    e1:SetCondition(c60159007.drcon)
    c:RegisterEffect(e1)
	--synchro effect
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMING_BATTLE_START)
    e2:SetCountLimit(1,6019007)
    e2:SetCondition(c60159007.sccon)
    e2:SetTarget(c60159007.sctg)
    e2:SetOperation(c60159007.scop)
    c:RegisterEffect(e2)
	--spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,60159097+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c60159007.spcon)
    e3:SetTarget(c60159007.target)
    e3:SetOperation(c60159007.operation)
    c:RegisterEffect(e3)
	if not c60159007.global_check then
        c60159007.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c60159007.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c60159007.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local p1=false
    local p2=false
    while tc do
        if tc:IsLocation(LOCATION_EXTRA) then
            if tc:GetSummonPlayer()==0 then p1=true else p2=true end
        end
        tc=eg:GetNext()
    end
    if p1 then Duel.RegisterFlagEffect(0,60159007,RESET_PHASE+PHASE_END,0,1) end
    if p2 then Duel.RegisterFlagEffect(1,60159007,RESET_PHASE+PHASE_END,0,1) end
end
function c60159007.synlimit(e,c)
    if not c then return false end
    return not ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159007.handfilter(c)
    return c:IsType(TYPE_MONSTER) and not ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159007.drcon(e)
    local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
    return not g:IsExists(c60159007.handfilter,1,nil)
end
function c60159007.sccon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()==tp then return false end
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c60159007.mfilter(c)
    return c:IsFaceup() and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159007.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(c60159007.mfilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60159007.scop(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetMatchingGroup(c60159007.mfilter,tp,LOCATION_MZONE,0,nil)
    local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
    end
end
function c60159007.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFlagEffect(tp,60159007)==0
end
function c60159007.filter1(c,e,tp,lv)
    local clv=c:GetLevel()
    return clv>0 and c:IsType(TYPE_TUNER) and (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)) and c:IsAbleToRemove()
        and Duel.IsExistingMatchingCard(c60159007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c60159007.filter2(c,e,tp,lv)
    return c:GetLevel()==lv and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c60159007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c60159007.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAbleToRemove()
        and Duel.IsExistingTarget(c60159007.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c60159007.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60159007.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
    local lv=c:GetLevel()+tc:GetLevel()
    local g=Group.FromCards(c,tc)
    if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,c60159007.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
        if sg:GetCount()>0 then
            local tc=sg:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
        end
    end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c60159007.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c60159007.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA)
end