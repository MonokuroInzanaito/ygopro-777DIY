--极乱数 误码
function c21520026.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,3,nil,nil,99)
	--xyz material
	local se1=Effect.CreateEffect(c)
	se1:SetDescription(aux.Stringid(21520026,2))
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetRange(LOCATION_EXTRA)
	se1:SetCondition(c21520026.xyzcondition)
	se1:SetOperation(c21520026.xyzoperation)
	c:RegisterEffect(se1)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520026.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520026,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520026.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520026.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520026,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520026.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520026.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520026.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520026.defval)
	c:RegisterEffect(e8)
	--to hand
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e9:SetDescription(aux.Stringid(21520026,1))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_CHAIN_DISABLED)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c21520026.thcon)
	e9:SetCost(c21520026.thcost)
	e9:SetTarget(c21520026.thtg)
	e9:SetOperation(c21520026.thop)
	c:RegisterEffect(e9)
end
function c21520026.MinValue(...)
	local val=...
	return val or 0
end
function c21520026.MaxValue(...)
	local val=...
	local g=Duel.GetMatchingGroup(c21520026.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetRank()
		tc=g:GetNext()
	end
	if val==nil then val=sum*400 end
	return val
end
function c21520026.vfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c21520026.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493)
end
function c21520026.xyzcondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520026.xyzfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>=3
end
function c21520026.xyzoperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c21520026.xyzfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=mg:Select(tp,3,99,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) then
			local sg=tc:GetOverlayGroup()
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_RULE)
			end
		end
		tc=g:GetNext()
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c21520026.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x493)
end
function c21520026.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520026.MinValue()
	local tempmax=c21520026.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+2)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520026.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520026.MinValue()
	local tempmax=c21520026.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+22360+3)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520026.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsCode(21520026) and e:GetHandler():GetFlagEffect(21520026) < e:GetHandler():GetOverlayCount()
end
function c21520026.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	e:GetHandler():RegisterFlagEffect(21520026,RESET_CHAIN,0,1)
end
function c21520026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local rc=re:GetHandler()
		return Duel.IsExistingMatchingCard(c21520026.thfilter,tp,LOCATION_DECK,0,1,nil,re:GetActiveType(),rc:GetCode()) end
end
function c21520026.thfilter(c,typ,code)
	return c:IsType(typ) and c:IsAbleToHand() and not c:IsCode(code)
end
function c21520026.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ty=re:GetActiveType()
--	local player=re:GetHandler():GetControler()
	local rc=re:GetHandler()
	local tg=Duel.GetMatchingGroup(c21520026.thfilter,tp,LOCATION_DECK,0,nil,ty,rc:GetCode())
	if c:GetOverlayCount()==0 or tg:GetCount()==0 then return end
	local sg=tg:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.BreakEffect()
	local tempmin=c21520026.MinValue()
	local tempmax=c21520026.MaxValue()
	if c:GetAttack()<tempmax/2 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
