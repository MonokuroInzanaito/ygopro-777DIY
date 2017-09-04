--深洋之歌
function c60158918.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
    e1:SetTarget(c60158918.target)
    e1:SetOperation(c60158918.activate)
    c:RegisterEffect(e1)
end
function c60158918.filter(c)
    return c:IsFaceup()
end
function c60158918.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60158918.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c60158918.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,0,g,1,0,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local op=Duel.SelectOption(tp,aux.Stringid(60158918,0),aux.Stringid(60158918,1))
    e:SetLabel(op)
end
function c60158918.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if e:GetLabel()==0 then
			local zz=tc:GetRace()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(zz)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		else 
			local ss=tc:GetAttribute()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ss)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp) 
		end
	end
end