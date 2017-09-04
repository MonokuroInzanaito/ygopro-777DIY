--宝具 争论的战利品
function c99999958.initial_effect(c)
	c:SetUniqueOnField(1,0,99999958)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99999958.target)
	e1:SetOperation(c99999958.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c99999958.eqlimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c99999958.spcost)
	e3:SetTarget(c99999958.sptg)
	e3:SetOperation(c99999958.spop)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e6:SetTarget(c99999958.atktg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--[[search card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(999999,7))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCost(c99999958.secost)
	e6:SetTarget(c99999958.setarget)
	e6:SetOperation(c99999958.seoperation)
	c:RegisterEffect(e6)--]]
end
function c99999958.eqlimit(e,c)
	return  c:IsCode(99999959) 
end
function c99999958.filter(c)
	return c:IsFaceup() and c:IsCode(99999959) 
end
function c99999958.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99999958.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99999958.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99999958.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99999958.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c99999958.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c99999958.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999958.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c99999958.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99999958.spfilter(c,e,tp,mc)
	return c:IsCode(99999957) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99999958.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99999958.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99999958.spop(e,tp,eg,ep,ev,re,r,rp)
	  if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc:IsFacedown() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c99999958.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end
--[[function c99999958.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,99999958)==0 and Duel.GetFlagEffect(tp,99999959)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,99999958,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99999959,RESET_PHASE+PHASE_END,0,1)
end
function c99999958.sefilter(c)
	return c:GetCode()==99999959 and c:IsAbleToHand()
end
function c99999958.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999958.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99999958.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c99999958.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--]]
function c99999958.atktg(e,c)
   local ec=e:GetHandler():GetEquipTarget()
	return ec:IsFaceup() and c~=ec
end