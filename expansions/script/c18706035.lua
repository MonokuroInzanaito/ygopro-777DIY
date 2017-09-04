--黑白配
function c18706035.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--indestructable by effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(c18706035.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c18706035.incon)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	--EQ
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(69610924,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c18706035.cost)
	e1:SetTarget(c18706035.target)
	e1:SetOperation(c18706035.activate)
	c:RegisterEffect(e1)
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetDescription(aux.Stringid(114100029,1))
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c18706035.xyzcon)
	e2:SetOperation(c18706035.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetCondition(c18706035.limcon)
	c:RegisterEffect(e1)
	if not c18706035.global_check then
		c18706035.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c18706035.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c18706035.limcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),18706035)~=0
end
function c18706035.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsCode(18706035) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,18706035,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,18706035,RESET_PHASE+PHASE_END,0,1) end
end
function c18706035.incon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c18706035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18706035.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18706035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c18706035.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18706035.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c18706035.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c18706035.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c18706035.xyzfilter1(c,slf)
	return c:IsCode(18706024)
	and c:IsCanBeXyzMaterial(slf,true)
end
function c18706035.xyzfilter2(c,slf)
	return c:IsCode(18706009)
	and c:IsCanBeXyzMaterial(slf,true)
end
function c18706035.xyzcon(e,c,og)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local abcount=0
	if ft>0 and Duel.IsExistingMatchingCard(c18706035.xyzfilter1,c:GetControler(),LOCATION_HAND,0,1,nil,c) 
	and  Duel.IsExistingMatchingCard(c18706035.xyzfilter2,c:GetControler(),LOCATION_HAND,0,1,nil,c)  then abcount=abcount+2 end
	if ft>=-1 then if Duel.CheckXyzMaterial(c,nil,3,2,2,og) then abcount=abcount+1 end end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end
function c18706035.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114100029,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114100029,0),aux.Stringid(114100029,1))+1
		end
		local mg
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			mg1=Duel.SelectMatchingCard(tp,c18706035.xyzfilter1,tp,LOCATION_HAND,0,1,1,nil,c)
			mg2=Duel.SelectMatchingCard(tp,c18706035.xyzfilter2,tp,LOCATION_HAND,0,1,1,nil,c)
		else
			mg=Duel.SelectXyzMaterial(tp,c,c18706035.xyzfilter1,3,2,2)
			mg=Duel.SelectXyzMaterial(tp,c,c18706035.xyzfilter2,3,2,2)
		end
		c:SetMaterial(mg1)
		c:SetMaterial(mg2)
		Duel.Overlay(c,mg1)
		Duel.Overlay(c,mg2)
	end
end