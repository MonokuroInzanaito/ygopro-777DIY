--凋叶棕-哎呀到此为止了
function c29200115.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200115,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29200115)
    e1:SetTarget(c29200115.sptg)
    e1:SetOperation(c29200115.spop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200115,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(aux.bdcon)
    e2:SetTarget(c29200115.damtg1)
    e2:SetOperation(c29200115.damop1)
    c:RegisterEffect(e2)
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200115,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCondition(aux.bdcon)
    e3:SetTarget(c29200115.damtg)
    e3:SetOperation(c29200115.damop)
    c:RegisterEffect(e3)
end
function c29200115.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200115.damop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x53e0)) then
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
        Duel.Draw(tp,1,REASON_EFFECT)
    else
        Duel.MoveSequence(tc,1)
	    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
	    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    end
end
function c29200115.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c29200115.damop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,29200116,0x53e0,0x5011,1000,1000,2,0x4,0x10) then return end
    local token=Duel.CreateToken(tp,29200116)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c29200115.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c29200115.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(tp,70,71,72)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
            Duel.SendtoGrave(c,REASON_RULE)
        end
    end
    Duel.BreakEffect()
    Duel.MoveSequence(tc,1)
	Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
	Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c29200115.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c29200115.splimit(e,c)
    return not c:IsSetCard(0x53e0)
end

