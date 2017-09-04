--凋叶棕-devastator
function c29200125.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c29200125.target)
    e1:SetOperation(c29200125.activate)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetDescription(aux.Stringid(29200125,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(c29200125.spcost)
    e2:SetTarget(c29200125.sptarget)
    e2:SetOperation(c29200125.spoperation)
    c:RegisterEffect(e2)
end
function c29200125.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c29200125.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.SortDecktop(tp,tp,5)
    if Duel.GetFlagEffect(tp,14513016)~=0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x53e0))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,14513016,RESET_PHASE+PHASE_END,0,1)
end
function c29200125.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c29200125.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200125.spoperation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x53e0)) then
	    if Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0x53e0,0x11,0,2200,4,RACE_FAIRY,ATTRIBUTE_EARTH)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            --[[tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_EARTH,RACE_FAIRY,4,0,2200)
            tc:AddMonsterAttributeComplete()
            Duel.SpecialSummonComplete()]]
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_BASE_ATTACK)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetValue(0)
            --e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetReset(RESET_EVENT+0x47c0000)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_SET_BASE_DEFENSE)
            e2:SetValue(2200)
            tc:RegisterEffect(e2)
            local e3=e1:Clone()
            e3:SetCode(EFFECT_CHANGE_LEVEL)
            e3:SetValue(4)
            tc:RegisterEffect(e3)
            local e4=e1:Clone()
            e4:SetCode(EFFECT_CHANGE_RACE)
            e4:SetValue(RACE_FAIRY)
            tc:RegisterEffect(e4)
            local e5=e1:Clone()
            e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
            e5:SetValue(ATTRIBUTE_EARTH)
            tc:RegisterEffect(e5)
            local e6=e1:Clone()
            e6:SetCode(EFFECT_CHANGE_TYPE)
            e6:SetValue(0x11)
            tc:RegisterEffect(e6)
            Duel.SpecialSummonComplete()
        else
            Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
		end
    else
        Duel.MoveSequence(tc,1)
	    --Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
	    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    end
end



