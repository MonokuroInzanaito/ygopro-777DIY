--魔人少女 拜伊科
function c18706031.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xabb),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetOperation(c18706031.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_SINGLE)
	--e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e4:SetValue(c18706031.efilter)
	--c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c18706031.ind2)
	c:RegisterEffect(e5)
	--disable and destroy
	--local e6=Effect.CreateEffect(c)
	--e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e6:SetRange(LOCATION_MZONE)
	--e6:SetCode(EVENT_CHAIN_ACTIVATING)
	--e6:SetOperation(c18706031.disop2)
	--c:RegisterEffect(e6)
end
function c18706031.ind2(e,c)
	return c:GetRace()==RACE_WARRIOR or c:GetRace()==RACE_SPELLCASTER or c:GetRace()==RACE_ZOMBIE or c:GetRace()==RACE_MACHINE
	or c:GetRace()==RACE_AQUA or c:GetRace()==RACE_PYRO or c:GetRace()==RACE_ROCK or c:GetRace()==RACE_WINDBEAST
	or c:GetRace()==RACE_PLANT or c:GetRace()==RACE_INSECT or c:GetRace()==RACE_THUNDER or c:GetRace()==RACE_DRAGON
	  or c:GetRace()==RACE_BEAST or c:GetRace()==RACE_BEASTWARRIOR or c:GetRace()==RACE_DINOSAUR or c:GetRace()==RACE_FISH
	  or c:GetRace()==RACE_SEASERPENT  or c:GetRace()==RACE_REPTILE  or c:GetRace()==RACE_PSYCHO  or c:GetRace()==RACE_DEVINE
	  or c:GetRace()==RACE_CREATORGOD  or c:GetRace()==RACE_WYRM
end
function c18706031.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (re:GetHandler():GetRace()==RACE_WARRIOR or re:GetHandler():GetRace()==RACE_SPELLCASTER or re:GetHandler():GetRace()==RACE_ZOMBIE or re:GetHandler():GetRace()==RACE_MACHINE
	or re:GetHandler():GetRace()==RACE_AQUA or re:GetHandler():GetRace()==RACE_PYRO or re:GetHandler():GetRace()==RACE_ROCK or re:GetHandler():GetRace()==RACE_WINDBEAST
	or re:GetHandler():GetRace()==RACE_PLANT or re:GetHandler():GetRace()==RACE_INSECT or re:GetHandler():GetRace()==RACE_THUNDER or re:GetHandler():GetRace()==RACE_DRAGON
	  or re:GetHandler():GetRace()==RACE_BEAST or re:GetHandler():GetRace()==RACE_BEASTWARRIOR or re:GetHandler():GetRace()==RACE_DINOSAUR or re:GetHandler():GetRace()==RACE_FISH
	  or re:GetHandler():GetRace()==RACE_SEASERPENT  or re:GetHandler():GetRace()==RACE_REPTILE  or re:GetHandler():GetRace()==RACE_PSYCHO  or re:GetHandler():GetRace()==RACE_DEVINE
	  or re:GetHandler():GetRace()==RACE_CREATORGOD  or re:GetHandler():GetRace()==RACE_WYRM)
end
function c18706031.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c18706031.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingTarget(c18706031.mfilter,tp,0,LOCATION_MZONE,1,nil) then 
	if ep==tp or (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and 
	Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)) then return end
	else
	if ep==tp or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then return end
	end
	Duel.Hint(HINT_CARD,0,18706031)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c18706031.Fkfilter(c)
	return c:GetSequence()<5
end
