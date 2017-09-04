--德莉莎·彼岸樱
function c75646517.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646517.spcon)
	e1:SetOperation(c75646517.spop)
	c:RegisterEffect(e1)
	--eq
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c75646517.target)
	e2:SetOperation(c75646517.operation)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c75646517.chcon)
	e3:SetTarget(c75646517.chtg)
	e3:SetOperation(c75646517.chop)
	c:RegisterEffect(e3)
end
function c75646517.spfilter(c)
	return c:IsCode(75646509) and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,75646508)
end
function c75646517.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c75646517.spfilter,1,nil)
end
function c75646517.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c75646517.spfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c75646517.filter(c,e,tp,ec)
	return c:IsCode(75646508)
end
function c75646517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646517.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local g=Duel.GetMatchingGroup(c75646517.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c75646517.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646510,0))
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c75646517.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	Duel.Equip(tp,tc,c,true)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c75646517.eqlimit)
	e1:SetLabelObject(c)
	tc:RegisterEffect(e1)
	tc:AddCounter(0x1b,3)
end
function c75646517.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c75646517.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsCode(75646508) and rc:GetEquipTarget()==e:GetHandler() 
end
function c75646517.filter1(c)
	return c:IsAbleToRemove()
end
function c75646517.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c75646517.chlimit)
end
function c75646517.chlimit(e,ep,tp)
	return tp==ep
end
function c75646517.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c75646517.repop)
end
function c75646517.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646517.filter1,tp,0,LOCATION_MZONE,1,1,nil)   
	local tc=c:GetEquipTarget()
	if not tc then return false end
	local rec=g:GetFirst()
	local atk=rec:GetBaseAttack()
	c:RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	if rec and Duel.Remove(rec,POS_FACEUP,REASON_EFFECT)~=0 and rec:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end