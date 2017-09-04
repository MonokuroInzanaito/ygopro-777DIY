--动物朋友 火之鸟
function c33700172.initial_effect(c)
   c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
   --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c33700172.fsplimit)
	c:RegisterEffect(e0)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c33700172.fscondition)
	e1:SetOperation(c33700172.fsoperation)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33700172.splimit)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	 --damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c33700172.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--set
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c33700172.pcon)
	e6:SetTarget(c33700172.ptg)
	e6:SetOperation(c33700172.pop)
	c:RegisterEffect(e6)
   --tohand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(33700172,0))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetCountLimit(1)
	e7:SetCost(c33700172.thcost)
	e7:SetTarget(c33700172.thtg)
	e7:SetOperation(c33700172.thop)
	c:RegisterEffect(e7)
	--special summon rule
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCondition(c33700172.sprcon)
	e8:SetOperation(c33700172.sprop)
	c:RegisterEffect(e8)
end
function c33700172.fsplimit(e,se,sp,st)
	return  bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler()
end
function c33700172.ffilter(c,fc)
	return (c:IsFusionType(TYPE_XYZ) or c:IsFusionType(TYPE_FUSION) or c:IsFusionType(TYPE_SYNCHRO)) and c:IsFusionSetCard(0x442) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c33700172.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return c33700172.ffilter(gc,e:GetHandler()) and g:IsExists(c33700172.ffilter,1,gc,e:GetHandler()) end
	local g1=g:Filter(c33700172.ffilter,nil,e:GetHandler())
	if chkf~=PLAYER_NONE then
		return g1:IsExists(aux.FConditionCheckF,1,nil,chkf) and g1:GetCount()>=3
	else return g1:GetCount()>=3 end
end
function c33700172.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,c33700172.ffilter,3,63,gc,e:GetHandler())
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(c33700172.ffilter,nil,e:GetHandler())
	if chkf==PLAYER_NONE or sg:GetCount()==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,3,63,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,2,63,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c33700172.splimit(e,c,tp,sumtp,sumpos)
	return not  bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c33700172.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c33700172.pcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c33700172.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c33700172.pop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c33700172.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(Card.IsPublic,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c33700172.thfilter(c)
	return c:IsSetCard(0x442)  and c:IsAbleToHand()
end
function c33700172.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700172.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700172.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if not e:GetHandler():IsRelateToEffect(e) or tg:GetClassCount(Card.GetCode)~=tg:GetCount() then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700172.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and  Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	if g:GetFirst():IsType(TYPE_MONSTER) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(33700172,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	g:GetFirst():RegisterEffect(e1)
	end
end
end
function c33700172.spfilter(c)
	return c:IsFusionSetCard(0x442) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c33700172.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c33700172.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,nil) and c:IsFaceup()
end
function c33700172.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33700172.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,99,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end