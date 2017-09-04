--单身二十年
function c5012614.initial_effect(c)
	--fusion material
	c:SetUniqueOnField(1,1,5012614)
	--
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,5012604,aux.FilterBoolFunction(c5012614.fsfilter),2,true,true)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5012604,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c5012614.cost)
	e1:SetTarget(c5012614.target)
	e1:SetOperation(c5012614.operation)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c5012614.sprcon)
	e2:SetOperation(c5012614.sprop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0x3f,0x3f)
	e3:SetTarget(c5012614.distg)
	c:RegisterEffect(e3)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c5012614.disop)
	c:RegisterEffect(e4)
	--disable trap monster
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c5012614.distg)
	c:RegisterEffect(e5)
	--immune spell
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c5012614.efilter)
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BATTLE_START)
	e7:SetCondition(c5012614.tdcon)
	e7:SetOperation(c5012614.tdop)
	c:RegisterEffect(e7)
	--add code
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_ADD_SETCODE)
	e8:SetValue(0x350)
	c:RegisterEffect(e8)
end
function c5012614.fsfilter(c)
	return c:IsSetCard(0x350) and c:IsType(TYPE_MONSTER)
end
function c5012614.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c5012614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c5012614.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c5012614.spfilter1(c,e,tp)
	return c:IsCode(5012604) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(e,true) 
		and Duel.IsExistingMatchingCard(c5012614.spfilter2,tp,LOCATION_MZONE,0,2,c,e)
end
function c5012614.spfilter2(c,e)
	return not c:IsCode(5012604) and c:IsCanBeFusionMaterial(e,false) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x350)
end
function c5012614.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c5012614.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,c,tp)
end
function c5012614.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,2))
	local g1=Duel.SelectMatchingCard(tp,c5012614.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,3))
	local g2=Duel.SelectMatchingCard(tp,c5012614.spfilter2,tp,LOCATION_MZONE,0,2,2,g1:GetFirst(),e:GetHandler())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c5012614.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function c5012614.disop(e,tp,eg,ep,ev,re,r,rp)
	if  re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
function c5012614.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c5012614.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsAbleToDeck() and bc:IsFaceup() and (bc:IsAttackAbove(1700) or bc:IsDefenseAbove(800))
end
function c5012614.tdop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local atk=bc:GetBaseAttack()
	local def=bc:GetBaseDefense()
	local val=0
	if atk>=def then
	val=atk
	else
	val=def
	end
	if bc:IsRelateToBattle() and bc:IsFaceup() and Duel.SendtoDeck(bc,nil,2,REASON_EFFECT)>0 then
	Duel.Damage(1-tp,val,REASON_EFFECT)
	end
end