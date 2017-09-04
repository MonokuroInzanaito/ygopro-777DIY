--澄 镜水沉溺
function c60159213.initial_effect(c)
	--only 1 can exists
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e21:SetCondition(c60159213.excon)
	c:RegisterEffect(e21)
	local e31=e21:Clone()
	e31:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e31)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD)
	e41:SetRange(LOCATION_MZONE)
	e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e41:SetTargetRange(1,0)
	e41:SetCode(EFFECT_CANNOT_SUMMON)
	e41:SetTarget(c60159213.sumlimit)
	c:RegisterEffect(e41)
	local e51=e41:Clone()
	e51:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e51)
	local e61=e41:Clone()
	e61:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e61)
	local e81=Effect.CreateEffect(c)
	e81:SetType(EFFECT_TYPE_FIELD)
	e81:SetCode(EFFECT_SELF_DESTROY)
	e81:SetRange(LOCATION_MZONE)
	e81:SetTargetRange(LOCATION_MZONE,0)
	e81:SetTarget(c60159213.destarget)
	c:RegisterEffect(e81)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60159213.ffilter,aux.FilterBoolFunction(c60159213.ffilter),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60159213.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60159213.spcon)
	e2:SetOperation(c60159213.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159213,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,60159213)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60159213.discon)
	e3:SetCost(c60159213.discost)
	e3:SetTarget(c60159213.distg)
	e3:SetOperation(c60159213.disop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60159213,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,60159213)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c60159213.thcost)
	e4:SetTarget(c60159213.thtg)
	e4:SetOperation(c60159213.thop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c60159213.condition)
	e5:SetTarget(c60159213.target3)
	e5:SetOperation(c60159213.operation3)
	c:RegisterEffect(e5)
end
function c60159213.sumlimit(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_FUSION)
end
function c60159213.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_FUSION)
end
function c60159213.excon(e,tp)
	return Duel.IsExistingMatchingCard(c60159213.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159213.destarget(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_FUSION) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c60159213.ffilter(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_SYNCHRO+TYPE_XYZ))
end
function c60159213.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60159213.spfilter1(c,tp,fc)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_SYNCHRO+TYPE_XYZ)) 
		and c:IsCanBeFusionMaterial(fc) and Duel.CheckReleaseGroup(tp,c60159213.spfilter2,1,c,fc)
end
function c60159213.spfilter2(c,fc)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_SYNCHRO+TYPE_XYZ)) 
		and c:IsCanBeFusionMaterial(fc)
end
function c60159213.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.GetCounter(tp,1,1,0x1137)>3
		and Duel.CheckReleaseGroup(tp,c60159213.spfilter1,1,nil,tp,c) 
end
function c60159213.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c60159213.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c60159213.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c60159213.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and Duel.IsChainNegatable(ev) 
end
function c60159213.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1137,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1137,3,REASON_COST)
end
function c60159213.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60159213.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c60159213.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1137,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1137,3,REASON_COST)
end
function c60159213.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60159213.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c60159213.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159213.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
end
function c60159213.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1137+COUNTER_NEED_ENABLE,4)
	end
end