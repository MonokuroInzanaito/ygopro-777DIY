--红龙-羽蛇神
function c11113099.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11113099.xyzcon)
	e2:SetOperation(c11113099.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113099,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11113099.condition)
	e3:SetCost(c11113099.cost)
	e3:SetTarget(c11113099.target)
	e3:SetOperation(c11113099.operation)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	--effect copy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c11113099.effcon)
	e5:SetOperation(c11113099.effop)
	c:RegisterEffect(e5)
end
function c11113099.ovfilter1(c,tp,xyzcard)
    local lv=c:GetLevel()
	return lv>4 and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsCanBeXyzMaterial(xyzcard)
	    and Duel.IsExistingMatchingCard(c11113099.ovfilter2,tp,LOCATION_MZONE,0,1,c,lv)
end
function c11113099.ovfilter2(c,lv,xyzcard)
	return c:IsFaceup() and c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsCanBeXyzMaterial(xyzcard)
end
function c11113099.ovfilter3(c,xyzcard)
	return c:IsLevelBelow(8) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsCanBeXyzMaterial(xyzcard)
end
function c11113099.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11113099.ovfilter3,tp,LOCATION_EXTRA,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c11113099.ovfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
	    and g:GetClassCount(Card.GetCode)>3
end
function c11113099.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.SelectOption(tp,aux.Stringid(11113099,0))
	Duel.SelectOption(1-tp,aux.Stringid(11113099,0))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c11113099.ovfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c11113099.ovfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetLevel())
	g1:Merge(g2)
    local sg=Duel.GetMatchingGroup(c11113099.ovfilter3,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	g1:Merge(sg1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
	g1:Merge(sg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg3=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,sg3:GetFirst():GetCode())
	g1:Merge(sg3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg4=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,sg4:GetFirst():GetCode())
	g1:Merge(sg4)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c11113099.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c11113099.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function c11113099.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c11113099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c11113099.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c11113099.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c11113099.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c11113099.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c11113099.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113099,2))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11113099)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c11113099.cptg)
	e1:SetOperation(c11113099.cpop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c11113099.cpfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsLevelBelow(8) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsAbleToExtra()
end
function c11113099.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c11113099.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11113099.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11113099.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c11113099.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
	    if c:IsRelateToEffect(e) and c:IsFaceup() then
			local code=tc:GetOriginalCode()
			local atk=tc:GetBaseAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(atk)
			c:RegisterEffect(e2)
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		end	
	end
end