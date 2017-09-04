--凋叶棕-幻想浪漫绮行
function c29200100.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --scale change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200100,0))
    e1:SetCategory(CATEGORY_DICE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29200100.sctg)
    e1:SetOperation(c29200100.scop)
    c:RegisterEffect(e1)
	--splimit
    local ed=Effect.CreateEffect(c)
    ed:SetType(EFFECT_TYPE_FIELD)
    ed:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    ed:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    ed:SetRange(LOCATION_PZONE)
    ed:SetTargetRange(1,0)
    ed:SetTarget(c29200100.splimit)
    c:RegisterEffect(ed)
    --extra summon
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_SUMMON_SUCCESS)
    e10:SetOperation(c29200100.sumop)
    c:RegisterEffect(e10)
end
function c29200100.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,29200100)~=0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x53e0))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,29200100,RESET_PHASE+PHASE_END,0,1)
end
function c29200100.splimit(e,c,tp,sumtp,sumpos)
    local seq=e:GetHandler():GetSequence()
    local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
    if tc and not tc:IsSetCard(0x53e0) then
        return true
    else
        return false
    end
end
function c29200100.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetLeftScale()<10 end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c29200100.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local d1,d2=Duel.TossDice(tp,2)
	local sch=d1+d2
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(sch)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
end
