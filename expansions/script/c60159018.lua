--生命与死亡 会议
function c60159018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(c60159018.mfilter))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c60159018.reptg)
	e3:SetValue(c60159018.repval)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60159018,4))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,60159018)
	e4:SetCost(c60159018.cost)
	e4:SetTarget(c60159018.target)
	e4:SetOperation(c60159018.activate)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60159018,5))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,6019018)
	e5:SetTarget(c60159018.target2)
	e5:SetOperation(c60159018.activate2)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c60159018.damcon)
	e6:SetTarget(c60159018.damtg)
	e6:SetOperation(c60159018.damop)
	c:RegisterEffect(e6)
end
function c60159018.mfilter(c)
	return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159018.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(60159018)==0
end
function c60159018.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c60159018.repfilter,1,nil,tp) end
	local g=eg:Filter(c60159018.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(60159018,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60159018,0))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c60159018.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c60159018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60159018.tgfilter1(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) and Duel.IsExistingMatchingCard(c60159018.thfilter1,tp,LOCATION_DECK,0,1,nil)
end
function c60159018.thfilter1(c)
	return (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)) and c:IsAbleToHand()
end
function c60159018.tgfilter2(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)) and Duel.IsExistingMatchingCard(c60159018.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c60159018.thfilter2(c)
	return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) and c:IsAbleToHand()
end
function c60159018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159018.tgfilter1,tp,LOCATION_MZONE,0,1,nil,tp) 
		or Duel.IsExistingMatchingCard(c60159018.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	local b1=Duel.IsExistingMatchingCard(c60159018.tgfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c60159018.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	local op=2
	if (b1 or b2) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(60159018,1),aux.Stringid(60159018,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(60159018,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(60159018,2))+1
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	e:SetLabel(op)
end
function c60159018.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c60159018.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c60159018.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60159018.tfilter(c,att,e,tp,rk)
	if c:IsType(TYPE_XYZ) then
		return (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24)) and c:IsAttribute(att) 
			and c:GetRank()~=rk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	else
		return c:GetLevel()>0 and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24)) and c:IsAttribute(att) 
			and c:GetLevel()~=rk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function c60159018.tfilter2(c,att,e,tp,lv)
	if c:IsType(TYPE_XYZ) then
		return (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24)) and c:IsAttribute(att) 
			and c:GetRank()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	else
		return lv>0 and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24)) and c:IsAttribute(att) 
			and c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function c60159018.filter(c,e,tp)
	if c:IsType(TYPE_XYZ) then
		local rk=c:GetRank()
		return c:IsFaceup() and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24))
			and Duel.IsExistingMatchingCard(c60159018.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,rk)
	else
		local lv=c:GetLevel()
		return lv>0 and c:IsFaceup() and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24))
			and Duel.IsExistingMatchingCard(c60159018.tfilter2,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,lv)
	end
end
function c60159018.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c60159018.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c60159018.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function c60159018.spfilter(c)
	return true 
end
function c60159018.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	local rk=tc:GetRank()
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	if tc:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c60159018.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,rk)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
				local tc2=sg:GetFirst()
				if tc2:IsType(TYPE_XYZ) then
					local g=Duel.GetMatchingGroup(c60159018.spfilter,tp,LOCATION_HAND,0,nil)
					if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159018,3)) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159018,6))
						local sg2=g:Select(tp,1,1,nil)
						Duel.Overlay(tc2,sg2)
					end
				end
			sg:GetFirst():CompleteProcedure()
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c60159018.tfilter2,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
				local tc2=sg:GetFirst()
				if tc2:IsType(TYPE_XYZ) then
					local g=Duel.GetMatchingGroup(c60159018.spfilter,tp,LOCATION_HAND,0,nil)
					if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159018,3)) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159018,6))
						local sg2=g:Select(tp,1,1,nil)
						Duel.Overlay(tc2,sg2)
					end
				end
			sg:GetFirst():CompleteProcedure()
			end
		end
	end
end
function c60159018.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c60159018.filter2(c)
	return c:GetCode()~=60159018 and c:IsSetCard(0xcb24) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60159018.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159018.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60159018.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159018.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end