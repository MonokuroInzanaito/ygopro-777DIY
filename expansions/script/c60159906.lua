--现世的赤龙唤士 索妮娅
function c60159906.initial_effect(c)
	c:EnableReviveLimit()
	--summon limit
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	e21:SetCondition(c60159906.regcon)
	e21:SetOperation(c60159906.regop)
	c:RegisterEffect(e21)
	--
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	e22:SetValue(c60159906.splimit)
	c:RegisterEffect(e22)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c60159906.spcon)
	e1:SetOperation(c60159906.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c60159906.tg)
	e2:SetOperation(c60159906.op)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159906,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60159906.atkcon)
	e3:SetValue(c60159906.atkval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60159906,2))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c60159906.atkcon)
	e4:SetValue(c60159906.atkval)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60159906,1))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetValue(1)
	e5:SetCondition(c60159906.atkcon2)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(60159906,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e6:SetCondition(c60159906.atkcon3)
	e6:SetTarget(c60159906.target)
	e6:SetOperation(c60159906.activate)
	c:RegisterEffect(e6)
	if not c60159906.global_check then
		c60159906.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c60159906.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60159906.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsCode(60159906) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60159906,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60159906,RESET_PHASE+PHASE_END,0,1) end
end
function c60159906.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60159906.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60159906.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c60159906.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsCode(60159906)
end
function c60159906.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c60159906.spfilter(c,sc,att)
	return c:IsFaceup() and c:IsAttribute(att) and c:IsCanBeXyzMaterial(sc)
end
function c60159906.spfilter1(c,mg,sc,att)
	local catt=c:GetAttribute()
	if bit.band(catt,att)==0 then return false end
	if bit.band(catt,att)==1 then att=att-1 end
	if bit.band(catt,att)==2 then att=att-2 end
	if bit.band(catt,att)==4 then att=att-4 end
	if bit.band(catt,att)==8 then att=att-8 end
	mg:RemoveCard(c)
	local ret=mg:IsExists(c60159906.spfilter2,1,nil,mg,sc,att)
	mg:AddCard(c)
	return ret and c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
end
function c60159906.spfilter2(c,mg,sc,att)
	local catt=c:GetAttribute()
	if bit.band(catt,att)==0 then return false end
	if bit.band(catt,att)==1 then att=att-1 end
	if bit.band(catt,att)==2 then att=att-2 end
	if bit.band(catt,att)==4 then att=att-4 end
	if bit.band(catt,att)==8 then att=att-8 end
	mg:RemoveCard(c)
	local ret=mg:IsExists(c60159906.spfilter3,1,nil,mg,sc,att)
	mg:AddCard(c)
	return ret and c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
end
function c60159906.spfilter3(c,mg,sc,att)
	local catt=c:GetAttribute()
	if bit.band(catt,att)==0 then return false end
	if bit.band(catt,att)==1 then att=att-1 end
	if bit.band(catt,att)==2 then att=att-2 end
	if bit.band(catt,att)==4 then att=att-4 end
	if bit.band(catt,att)==8 then att=att-8 end
	mg:RemoveCard(c)
	local ret=mg:IsExists(c60159906.spfilter4,1,nil,mg,sc,att)
	mg:AddCard(c)
	return ret and c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
end
function c60159906.spfilter4(c,mg,sc,att)
	if bit.band(c:GetAttribute(),att)==0 then return false end
	return c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
end
function c60159906.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local att=ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND
	local mg=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,att)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		return mg:FilterCount(c60159906.spfilter1,nil,mg,c,att)>0 
			and Duel.GetFlagEffect(c:GetControler(),60159906)==0
	else
		return Duel.IsExistingMatchingCard(c60159906.spfilter,tp,LOCATION_MZONE,0,1,nil,c,att) 
			and mg:FilterCount(c60159906.spfilter1,nil,mg,c,att)>0 
			and Duel.GetFlagEffect(c:GetControler(),60159906)==0
	end
end
function c60159906.spop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local att=ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND
	local mg=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,att)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg1=mg:FilterSelect(tp,c60159906.spfilter1,1,1,nil,mg,c,att)
		local catt=rg1:GetFirst():GetAttribute()
		if bit.band(catt,att)==1 then att=att-1 end
		if bit.band(catt,att)==2 then att=att-2 end
		if bit.band(catt,att)==4 then att=att-4 end
		if bit.band(catt,att)==8 then att=att-8 end
		mg:Sub(rg1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg2=mg:FilterSelect(tp,c60159906.spfilter2,1,1,nil,mg,c,att)
		catt=rg2:GetFirst():GetAttribute()
		if bit.band(catt,att)==1 then att=att-1 end
		if bit.band(catt,att)==2 then att=att-2 end
		if bit.band(catt,att)==4 then att=att-4 end
		if bit.band(catt,att)==8 then att=att-8 end
		mg:Sub(rg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg3=mg:FilterSelect(tp,c60159906.spfilter3,1,1,nil,mg,c,att)
		catt=rg3:GetFirst():GetAttribute()
		if bit.band(catt,att)==1 then att=att-1 end
		if bit.band(catt,att)==2 then att=att-2 end
		if bit.band(catt,att)==4 then att=att-4 end
		if bit.band(catt,att)==8 then att=att-8 end
		mg:Sub(rg3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg4=mg:FilterSelect(tp,c60159906.spfilter4,1,1,nil,mg,c,att)
		rg1:Merge(rg2)
		rg1:Merge(rg3)
		rg1:Merge(rg4)
		local tc=rg1:GetFirst()
		local sg=Group.CreateGroup()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=rg1:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(rg1)
		Duel.Overlay(c,rg1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg1=Duel.SelectMatchingCard(tp,c60159906.spfilter,tp,LOCATION_MZONE,0,1,1,nil,c,att)
		local catt=rg1:GetFirst():GetAttribute()
		if bit.band(catt,att)==1 then att=att-1 end
		if bit.band(catt,att)==2 then att=att-2 end
		if bit.band(catt,att)==4 then att=att-4 end
		if bit.band(catt,att)==8 then att=att-8 end
		mg:Sub(rg1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg2=mg:FilterSelect(tp,c60159906.spfilter2,1,1,nil,mg,c,att)
		catt=rg2:GetFirst():GetAttribute()
		if bit.band(catt,att)==1 then att=att-1 end
		if bit.band(catt,att)==2 then att=att-2 end
		if bit.band(catt,att)==4 then att=att-4 end
		if bit.band(catt,att)==8 then att=att-8 end
		mg:Sub(rg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg3=mg:FilterSelect(tp,c60159906.spfilter3,1,1,nil,mg,c,att)
		catt=rg3:GetFirst():GetAttribute()
		if bit.band(catt,att)==1 then att=att-1 end
		if bit.band(catt,att)==2 then att=att-2 end
		if bit.band(catt,att)==4 then att=att-4 end
		if bit.band(catt,att)==8 then att=att-8 end
		mg:Sub(rg3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg4=mg:FilterSelect(tp,c60159906.spfilter4,1,1,nil,mg,c,att)
		rg1:Merge(rg2)
		rg1:Merge(rg3)
		rg1:Merge(rg4)
		local tc=rg1:GetFirst()
		local sg=Group.CreateGroup()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=rg1:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(rg1)
		Duel.Overlay(c,rg1)
	end
end
function c60159906.filter(c)
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) or c:IsFaceup())
end
function c60159906.filter2(c)
	return not c:IsCode(60159906) and not (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_WATER) 
		or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_MONSTER) 
		and c:IsAbleToRemove()
end
function c60159906.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c60159906.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c60159906.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c60159906.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60159906.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		local g3=Duel.GetMatchingGroup(c60159906.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil)
		Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end
function c60159906.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_EFFECT)
end
function c60159906.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function c60159906.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_PENDULUM)
end
function c60159906.atkval(e,c)
	return c:GetOverlayCount()*900
end
function c60159906.filter4(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60159906.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c60159906.filter4(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c60159906.filter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c60159906.filter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60159906.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end