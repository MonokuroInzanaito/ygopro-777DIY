--V2 ASSAULT-BUSTER高达
function c18743208.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,18743207,c18743208.ffilter,2,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c18743208.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTarget(c18743208.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--EQ
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetDescription(aux.Stringid(187235501,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c18743208.addct)
	e4:SetOperation(c18743208.addc)
	c:RegisterEffect(e4)
end
os=require("os")
function c18743208.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(4)
end
function c18743208.target(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c18743208.tgfilter(c,ty)
	return c:IsFaceup() and c:IsType(ty) and c:IsDestructable()
end
function c18743208.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(54974237,2))
	local ac=Duel.SelectOption(tp,aux.Stringid(54974237,0),aux.Stringid(54974237,1))
	local ty=TYPE_SPELL
	if ac==1 then ty=TYPE_TRAP end
	e:SetLabel(ty)
	local g=Duel.GetMatchingGroup(c18743208.tgfilter,tp,0,LOCATION_ONFIELD,nil,ty)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18743208.cffilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c18743208.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(0,4))
	Duel.SelectOption(tp,aux.Stringid(18743208,val))
	Duel.SelectOption(1-tp,aux.Stringid(18743208,val))
	local ty=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if g:GetCount()>0 then
		local cg=g:Filter(c18743208.cffilter,nil)
		Duel.ConfirmCards(tp,cg)
		local dg=g:Filter(Card.IsType,nil,ty)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end