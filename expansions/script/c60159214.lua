--澄 无可奈何的面对
function c60159214.initial_effect(c)
	--only 1 can exists
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e21:SetCondition(c60159214.excon)
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
	e41:SetTarget(c60159214.sumlimit)
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
	e81:SetTarget(c60159214.destarget)
	c:RegisterEffect(e81)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60159214.ffilter,aux.FilterBoolFunction(c60159214.ffilter),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60159214.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60159214.spcon)
	e2:SetOperation(c60159214.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159214,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCost(c60159214.thcost)
	e3:SetTarget(c60159214.destg)
	e3:SetOperation(c60159214.desop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetOperation(c60159214.spop2)
	c:RegisterEffect(e4)
end
function c60159214.sumlimit(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_FUSION)
end
function c60159214.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_FUSION)
end
function c60159214.excon(e,tp)
	return Duel.IsExistingMatchingCard(c60159214.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159214.destarget(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_FUSION) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c60159214.ffilter(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_SYNCHRO+TYPE_XYZ))
end
function c60159214.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60159214.spfilter1(c,tp,fc)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_SYNCHRO+TYPE_XYZ)) 
		and c:IsCanBeFusionMaterial(fc) and Duel.CheckReleaseGroup(tp,c60159214.spfilter2,1,c,fc)
end
function c60159214.spfilter2(c,fc)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not (c:IsType(TYPE_SYNCHRO+TYPE_XYZ)) 
		and c:IsCanBeFusionMaterial(fc)
end
function c60159214.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.GetCounter(tp,1,1,0x1137)>5
		and Duel.CheckReleaseGroup(tp,c60159214.spfilter1,1,nil,tp,c) 
end
function c60159214.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c60159214.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c60159214.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c60159214.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1137,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1137,4,REASON_COST)
end
function c60159214.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c60159214.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159214.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,1,nil) end
end
function c60159214.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c60159214.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(g:GetFirst():GetCode())
		e1:SetOperation(c60159214.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c60159214.filter2(c,e)
	return c:IsFaceup() and c:IsCode(e:GetLabel())
end
function c60159214.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60159214.filter2,tp,0,LOCATION_ONFIELD+LOCATION_EXTRA,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c60159214.filter3(c,code)
	return c:IsCode(code)
end
function c60159214.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_EXTRA)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local code=bc:GetCode()
	if g:GetCount()>0 then 
		Duel.ConfirmCards(tp,g)
		local sg=Duel.GetMatchingGroup(c60159214.filter3,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil,code)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
