--妖刀 罪歌
function c11200013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c11200013.target)
	e1:SetOperation(c11200013.operation)
	c:RegisterEffect(e1)
	--Atk&disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetValue(11200094)
	c:RegisterEffect(e4)
	--Equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c11200013.eqlimit)
	c:RegisterEffect(e5)
	--must
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_MUST_ATTACK)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c11200013.ftarget)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_EP)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,1)
	e7:SetCondition(c11200013.becon)
	c:RegisterEffect(e7)
	--ind
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(11200013,0))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_START)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(c11200013.incon)
	e8:SetTarget(c11200013.intg)
	e8:SetOperation(c11200013.inop)
	c:RegisterEffect(e8)
	--contorl
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(11200013,1))
	e9:SetCategory(CATEGORY_CONTROL)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e9:SetCondition(c11200013.ctcon)
	e9:SetTarget(c11200013.cttg)
	e9:SetOperation(c11200013.ctop)
	c:RegisterEffect(e9)
end
function c11200013.eqlimit(e,c)
	return c:IsFaceup()
end
function c11200013.filter(c)
	return c:IsFaceup() 
end
function c11200013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11200013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c11200013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c11200013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c11200013.ftarget(e,c)
	return c:IsSetCard(0xbab) 
end
function c11200013.cep(c,tc)
	return c:IsSetCard(0xbab) and c:IsControler(tc) and c:IsAttackable()
end
function c11200013.becon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTurnPlayer()
	return Duel.IsExistingMatchingCard(c11200013.cep,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc) 
end
function c11200013.incon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return tc and bc  and ((tc:IsFaceup() and tc:IsCode(11200094)) or (bc:IsFaceup() and bc:IsCode(11200094)))
end
function c11200013.intg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget() 
 if not tc:IsControler(tp) then
	tc=Duel.GetAttackTarget()
	bc=Duel.GetAttacker()
	end
	local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	 local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local fc1=0
	 local fc2=0
	 if (tc:IsFaceup() and tc:IsCode(11200094)) and ft2>0 then
	 fc1=1
end
   if (bc:IsFaceup() and tc:IsCode(11200094)) and ft1>0 then
	 fc2=1
end
   if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,11200013) and
(fc1 >0 or fc2>0)
 end
end
function c11200013.ftarget(e,c)
	return c:IsSetCard(0xbab) 
end
function c11200013.inop(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget() 
	if not e:GetHandler():IsRelateToEffect(e) or not(tc or bc) then return end
	if tc then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(1)
	tc:RegisterEffect(e1)
end
	if bc then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e2:SetValue(1)
	bc:RegisterEffect(e2)
end
 local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	 local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
local fc1=0
local fc2=0
	 if (tc and tc:IsFaceup() and tc:IsCode(11200094)) and ft2>0 then
	 fc1=1
end
   if (bc and bc:IsFaceup() and tc:IsCode(11200094)) and ft1>0 then
	 fc2=1
end
if fc1==1 and fc2==2 then
	local gc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,11200013)
   if gc:GetFirst() then 
	local fc=Duel.Select(Group.FromCards(tc,bc),1,1,nil)
	Duel.Equip(tp,gc:GetFirst(),fc:GetFirst())
end
elseif fc1==1 and fc2~=1 then
	 local gc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,11200013)
   if gc:GetFirst() then 
	Duel.Equip(tp,gc:GetFirst(),bc)
end
elseif fc2==1 and fc1~=1 then
	 local gc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,11200013)
   if gc:GetFirst() then 
	Duel.Equip(tp,gc:GetFirst(),tc)
end
end
end
function c11200013.ctcon(e,tp,eg,ep,ev,re,r,rp)
	   local ph=Duel.GetCurrentPhase()
   return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and not e:GetHandler():GetEquipTarget():IsDisabled()
end
function c11200013.ct(c)
	return c:IsControlerCanBeChanged() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,11200013)
end
function c11200013.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200013.ct,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c11200013.ct,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c11200013.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200013.ct,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	Duel.GetControl(g,tp,PHASE_END,1)
	end
end