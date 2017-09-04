--凋叶棕-胎儿之梦
function c29200109.initial_effect(c)
    --deck check
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200109,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29200109.target)
    e1:SetOperation(c29200109.operation)
    c:RegisterEffect(e1)
    --sort
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,29200109)
    e2:SetTarget(c29200109.sdtg)
    e2:SetOperation(c29200109.sdop)
    c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29200109,1))
	e3:SetType(0x0081)
	e3:SetCode(29200000)
	e3:SetProperty(0x14000)
	e3:SetTarget(c29200109.tdtg)
	e3:SetOperation(c29200109.tdop)
	c:RegisterEffect(e3)
end
function c29200109.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
function c29200109.sdop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
    Duel.SortDecktop(tp,tp,3)
end
function c29200109.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200109.operation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x53e0)) then
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
        Duel.Draw(tp,1,REASON_EFFECT)
    else
        Duel.MoveSequence(tc,1)
	    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
	    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    end
end
function c29200109.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200109.tdop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    Duel.DisableShuffleCheck()
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
end
