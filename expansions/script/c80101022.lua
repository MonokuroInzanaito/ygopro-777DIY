--刀魂-三日月宗近
function c80101022.initial_effect(c)
    c:EnableCounterPermit(0x3)
    c:EnableReviveLimit()
    --synchro summon
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c80101022.syncon)
    e1:SetOperation(c80101022.synop)
    e1:SetValue(SUMMON_TYPE_SYNCHRO)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101022,0))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c80101022.rmcon)
    e2:SetTarget(c80101022.rmtg)
    e2:SetOperation(c80101022.rmop)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c80101022.discon)
    e3:SetTarget(c80101022.distg)
    e3:SetOperation(c80101022.disop)
    c:RegisterEffect(e3)
    --multi attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetValue(c80101022.val)
    c:RegisterEffect(e4)
end
function c80101022.val(e,c)
    return c:GetEquipCount()
end
function c80101022.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
end
function c80101022.filter(c,e,tp,ec)
    return c:IsSetCard(0x6400) and c:IsType(TYPE_EQUIP) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c80101022.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetHandler():GetMaterialCount()
    if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80101022.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c80101022.rmop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetHandler():GetMaterialCount()
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48370501,1))
    local g=Duel.SelectMatchingCard(tp,c80101022.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,ct,nil,e,tp,c)
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,true,true)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
end
function c80101022.matfilter1(c,syncard)
    return c:IsType(TYPE_TUNER) and c:IsSetCard(0x5400) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c80101022.matfilter2(c,syncard)
    return c:IsNotTuner() and c:IsSetCard(0x5400) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c80101022.synfilter1(c,syncard,lv,g1,g2,g3,g4)
    local f1=c.tuner_filter
    if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
        return g3:IsExists(c80101022.synfilter2,1,c,syncard,lv,g2,g4,f1,c)
    else
        return g1:IsExists(c80101022.synfilter2,1,c,syncard,lv,g2,g4,f1,c)
    end
end
function c80101022.synfilter2(c,syncard,lv,g2,g4,f1,tuner1)
    if c==tuner1 then return false end
    local f2=c.tuner_filter
    if f1 and not f1(c) then return false end
    if f2 and not f2(tuner1) then return false end
    if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not c:IsLocation(LOCATION_HAND)) or c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
        return g4:IsExists(c80101022.synfilter3,1,nil,syncard,lv,f1,f2,g2,tuner1,c)
    else
        local mg=g2:Filter(c80101022.synfilter4,nil,f1,f2)
        Duel.SetSelectedCard(Group.FromCards(c,tuner1))
        return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,62,syncard)
    end
end
function c80101022.synfilter3(c,syncard,lv,f1,f2,g2,tuner1,tuner2)
    if c==tuner1 or c==tuner2 then return false end
    if not (not f1 or f1(c)) and not (not f2 or f2(c)) then return false end
    local mg=g2:Filter(c80101022.synfilter4,nil,f1,f2)
    Duel.SetSelectedCard(Group.FromCards(c,tuner1,tuner2))
    return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,0,61,syncard)
end
function c80101022.synfilter4(c,f1,f2)
    return (not f1 or f1(c)) and (not f2 or f2(c))
end
function c80101022.syncon(e,c,tuner,mg)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
    local g1=nil
    local g2=nil
    local g3=nil
    local g4=nil
    if mg then
        g1=mg:Filter(c80101022.matfilter1,nil,c)
        g2=mg:Filter(c80101022.matfilter2,nil,c)
        g3=g1:Clone()
        g4=g2:Clone()
    else
        g1=Duel.GetMatchingGroup(c80101022.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
        g2=Duel.GetMatchingGroup(c80101022.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
        g3=Duel.GetMatchingGroup(c80101022.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
        g4=Duel.GetMatchingGroup(c80101022.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
    end
    local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
    local lv=c:GetLevel()
    if tuner then
        local f1=tuner.tuner_filter
        if not pe then
            return g1:IsExists(c80101022.synfilter2,1,tuner,c,lv,g2,g4,f1,tuner)
        else
            return c80101022.synfilter2(pe:GetOwner(),c,lv,g2,nil,f1,tuner)
        end
    end
    if not pe then
        return g1:IsExists(c80101022.synfilter1,1,nil,c,lv,g1,g2,g3,g4)
    else
        return c80101022.synfilter1(pe:GetOwner(),c,lv,g1,g2,g3,g4)
    end
end
function c80101022.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
    local g=Group.CreateGroup()
    local g1=nil
    local g2=nil
    local g3=nil
    local g4=nil
    if mg then
        g1=mg:Filter(c80101022.matfilter1,nil,c)
        g2=mg:Filter(c80101022.matfilter2,nil,c)
        g3=g1:Clone()
        g4=g2:Clone()
    else
        g1=Duel.GetMatchingGroup(c80101022.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
        g2=Duel.GetMatchingGroup(c80101022.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
        g3=Duel.GetMatchingGroup(c80101022.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
        g4=Duel.GetMatchingGroup(c80101022.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
    end
    local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
    local lv=c:GetLevel()
    if tuner then
        g:AddCard(tuner)
        local f1=tuner.tuner_filter
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local tuner2=nil
        if not pe then
            local t2=g1:FilterSelect(tp,c80101022.synfilter2,1,1,tuner,c,lv,g2,g4,f1,tuner)
            tuner2=t2:GetFirst()
        else
            tuner2=pe:GetOwner()
            Group.FromCards(tuner2):Select(tp,1,1,nil)
        end
        g:AddCard(tuner2)
        local f2=tuner2.tuner_filter
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        if tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
            local m3=g4:FilterSelect(tp,c80101022.synfilter3,1,1,nil,c,lv,f1,f2,g2,tuner,tuner2)
            g:Merge(m3)
            local mg2=g2:Filter(c80101022.synfilter4,nil,f1,f2)
            Duel.SetSelectedCard(g)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
            local m4=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,0,61,c)
            if m4 and m4:GetCount()>0 then
                g:Merge(m4)
            end
        else
            local mg2=g2:Filter(c80101022.synfilter4,nil,f1,f2)
            Duel.SetSelectedCard(g)
            local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,62,c)
            g:Merge(m3)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local tuner1=nil
        if not pe then
            local t1=g1:FilterSelect(tp,c80101022.synfilter1,1,1,nil,c,lv,g1,g2,g3,g4)
            tuner1=t1:GetFirst()
        else
            tuner1=pe:GetOwner()
            Group.FromCards(tuner1):Select(tp,1,1,nil)
        end
        g:AddCard(tuner1)
        local f1=tuner1.tuner_filter
        local tuner2=nil
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        if tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
            local t2=g3:FilterSelect(tp,c80101022.synfilter2,1,1,tuner1,c,lv,g2,g4,f1,tuner1)
            tuner2=t2:GetFirst()
        else
            local t2=g1:FilterSelect(tp,c80101022.synfilter2,1,1,tuner1,c,lv,g2,g4,f1,tuner1)
            tuner2=t2:GetFirst()
        end
        g:AddCard(tuner2)
        local f2=tuner2.tuner_filter
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not tuner2:IsLocation(LOCATION_HAND))
            or tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
            local m3=g4:FilterSelect(tp,c80101022.synfilter3,1,1,nil,c,lv,f1,f2,g2,tuner1,tuner2)
            g:Merge(m3)
            local mg2=g2:Filter(c80101022.synfilter4,nil,f1,f2)
            Duel.SetSelectedCard(g)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
            local m4=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,0,61,c)
            if m4 and m4:GetCount()>0 then
                g:Merge(m4)
            end
        else
            local mg2=g2:Filter(c80101022.synfilter4,nil,f1,f2)
            Duel.SetSelectedCard(g)
            local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,63,c)
            g:Merge(m3)
        end
    end
    c:SetMaterial(g)
    Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c80101022.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c80101022.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c80101022.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
        if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
        e:GetHandler():AddCounter(0x3,1)
        if e:GetHandler():GetCounter(0x3)==4 then
            Duel.SetLP(tp,Duel.GetLP(tp)-9000)
		end
    end
end

