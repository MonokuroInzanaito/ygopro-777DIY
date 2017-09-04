--空间感应者
function c21520082.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c21520082.fsfilter1,c21520082.fsfilter2,1,99,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520082.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCondition(c21520082.sprcon)
	e00:SetOperation(c21520082.sprop)
	c:RegisterEffect(e00)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c21520082.matcheck)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c21520082.sdcon)
	c:RegisterEffect(e2)
	--to deck and power up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520082,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c21520082.cost)
	e3:SetTarget(c21520082.tg)
	e3:SetOperation(c21520082.op)
	c:RegisterEffect(e3)
end
function c21520082.fsfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsLevelAbove(6) and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c21520082.fsfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial()
end
function c21520082.spfilter1(c,tp,ft)
	if c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsLevelAbove(6) and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) 
		and c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(c21520082.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(c21520082.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end
function c21520082.spfilter2(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup())
end
function c21520082.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler()
end
function c21520082.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c21520082.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
end
function c21520082.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c21520082.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c21520082.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		g2=g:Select(tp,1,99,nil)
	else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		if g:GetCount()>1 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g3=g:Select(tp,1,99,g2:GetFirst())
			g2:Merge(g3)
		end
	end
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
--	c:CompleteProcedure()
	c:RegisterFlagEffect(21520082,RESET_EVENT+0xfc0000,0,1)
end
function c21520082.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_SET_BASE_ATTACK)
	ae:SetValue(ct*500)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520082.sdcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION and e:GetHandler():GetFlagEffect(21520082)==0
end
function c21520082.rfliter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL)
end
function c21520082.tdfliter(c)
	return c:IsAbleToDeck() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_LEAVE_CONFIRMED)
end
function c21520082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520082.rfliter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520082.rfliter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520082.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,0,1000)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,nil,0,0,1000)
end
function c21520082.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		if not tc:IsImmuneToEffect(e) then
			local op=Duel.SelectOption(tp,aux.Stringid(21520082,1),aux.Stringid(21520082,2))
			Duel.SendtoDeck(tc,nil,op,REASON_EFFECT)
		end
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetCode(EFFECT_UPDATE_ATTACK)
		ae:SetValue(1000)
		ae:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(ae)
		local de=ae:Clone()
		de:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(de)
	end
end
