--气虚之灵的摧毁者
function c10981445.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c10981445.tfilter,aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10981445,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c10981445.drcon)
	e1:SetOperation(c10981445.operation)
	c:RegisterEffect(e1)			
end
function c10981445.tfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) or c:IsHasEffect(10981145)
end
function c10981445.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c10981445.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
	c:SetHint(CHINT_CARD,ac)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10981445,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10981445.rmcon)
	e1:SetOperation(c10981445.drop)
	e1:SetLabel(ac)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c10981445.filter(c,code)
	return c:IsFaceup() and c:IsCode(code) 
end
function c10981445.filter2(c)
	return c:IsFaceup() and c:IsHasEffect(10981145)
end
function c10981445.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return (eg:IsExists(c10981445.filter,1,nil,e:GetLabel()) or eg:IsExists(c10981445.filter2,1,nil)) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>2
end
function c10981445.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
