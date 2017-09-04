--凋叶棕-盲目的笑颜
function c29200123.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200123,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c29200123.target)
    e1:SetOperation(c29200123.activate)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200123,3))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c29200123.thcon)
    e2:SetTarget(c29200123.thtg)
    e2:SetOperation(c29200123.thop)
    c:RegisterEffect(e2)
end
function c29200123.filter1(c,e,tp)
    local rk=c:GetRank()
    return c:IsFaceup() and c:IsSetCard(0x53e0) and c:IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c29200123.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c29200123.filter2(c,e,tp,mc,rk)
    return c:GetRank()==rk and c:IsSetCard(0x53e0) and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c29200123.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x53e0)
end
function c29200123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>-1  
		and Duel.IsExistingTarget(c29200123.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(c29200123.filter,tp,LOCATION_MZONE,0,1,nil)	
    if chk==0 then return b1 or b2 end
    local op=0
    if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(29200123,1),aux.Stringid(29200123,2))
    elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(29200123,1))
    else op=Duel.SelectOption(tp,aux.Stringid(29200123,2))+1 end
    e:SetLabel(op)
    if op==0 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c29200123.filter1(chkc,e,tp) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        Duel.SelectTarget(tp,c29200123.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    else
        e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
        if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29200123.filter(chkc) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        Duel.SelectTarget(tp,c29200123.filter,tp,LOCATION_MZONE,0,1,1,nil)
    end
end
function c29200123.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
        local tc=Duel.GetFirstTarget()
        if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c29200123.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
        local sc=g:GetFirst()
        if sc then
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(sc,mg)
            end
            sc:SetMaterial(Group.FromCards(tc))
            Duel.Overlay(sc,Group.FromCards(tc))
            Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
            sc:CompleteProcedure()
        end
    else
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e1:SetValue(tc:GetAttack()*2)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
            e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e2:SetValue(tc:GetDefense()*2)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
            e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
            e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e3:SetCondition(c29200123.rdcon)
            e3:SetOperation(c29200123.rdop)
            tc:RegisterEffect(e3)
        end
	end
end
function c29200123.rdcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c29200123.rdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev/2)
end
function c29200123.thcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.GetDrawCount(tp)>0
end
function c29200123.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    local dt=Duel.GetDrawCount(tp)
    if dt~=0 then
        _replace_count=0
        _replace_max=dt
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_DRAW_COUNT)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_DRAW)
        e1:SetValue(0)
        Duel.RegisterEffect(e1,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c29200123.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    _replace_count=_replace_count+1
    if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end

