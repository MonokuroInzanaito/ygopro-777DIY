--英灵少女 宫本武藏
function c18700357.initial_effect(c)
	c:EnableReviveLimit()
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18700357,4))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c18700357.rmop)
	c:RegisterEffect(e4)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755502,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c18700357.dbcon)
	e2:SetOperation(c18700357.dbop)
	c:RegisterEffect(e2)
end
function c18700357.rmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(18700357,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18700357.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c18700357.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c18700357.dbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c18700357.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	Duel.SelectOption(tp,aux.Stringid(18700357,0))
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c18700357.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(18700357,5))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c18700357.atcon)
	e3:SetTarget(c18700357.thtg)
	e3:SetOperation(c18700357.thop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18700357,6))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c18700357.atcon2)
	e4:SetOperation(c18700357.thop2)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
	end
end
function c18700357.damval(e,re,val,r,rp,rc)
	return val/2
end
function c18700357.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c18700357.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and c:GetFlagEffect(187003570)>0
end
function c18700357.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c18700357.filter(chkc) and chkc~=e:GetHandler() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c18700357.filter,tp,0,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c18700357.filter,tp,0,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18700357.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetHandler():GetAttack()
	if atk<0 then atk=0 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_CARD,0,42945701)
	Duel.Hint(HINT_CARD,0,79333300)
	if Duel.Destroy(g,REASON_EFFECT) and c:IsFaceup()  then
	Duel.SelectOption(tp,aux.Stringid(18700357,3))
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c18700357.atcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
end
function c18700357.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(18700357)==0  then
	Duel.SelectOption(tp,aux.Stringid(18700357,1))
	Duel.Hint(HINT_CARD,0,70156997)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	c:RegisterFlagEffect(18700357,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else if c:GetFlagEffect(18700357)>0  then
	Duel.SelectOption(tp,aux.Stringid(18700357,2))
	Duel.Hint(HINT_CARD,0,06540606)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	c:RegisterFlagEffect(187003570,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else if c:GetFlagEffect(187003570)>0  then
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
end
end