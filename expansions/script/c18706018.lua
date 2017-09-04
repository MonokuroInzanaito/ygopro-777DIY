--魔人少女 莎姆&莎瑪
function c18706018.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xabb),1)
	c:EnableReviveLimit()
	--remove
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(52687916,0))
	--e1:SetCategory(CATEGORY_REMOVE)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCondition(c18706018.remcon)
	--e1:SetCost(c18706018.cost)
	--e1:SetTarget(c18706018.remtg)
	--e1:SetOperation(c18706018.remop)
	--c:RegisterEffect(e1)
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e3:SetValue(c18706018.efilter)
	--c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c18706018.ind2)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c18706018.damtg)
	e2:SetOperation(c18706018.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
end
function c18706018.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c18706018.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c18706018.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
		if Duel.IsExistingTarget(c18706018.mfilter,tp,0,LOCATION_MZONE,1,nil) then 
		Duel.Damage(p,d,REASON_EFFECT)
		end
end

function c18706018.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c18706018.costfilter(c)
	return c:IsSetCard(0xabb) and not c:IsPublic()
end
function c18706018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706018.costfilter,tp,LOCATION_HAND,0,1,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c18706018.costfilter,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c18706018.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c18706018.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c18706018.ind2(e,c)
	return c:GetRace()==RACE_WARRIOR or c:GetRace()==RACE_SPELLCASTER or c:GetRace()==RACE_ZOMBIE or c:GetRace()==RACE_MACHINE
	or c:GetRace()==RACE_AQUA or c:GetRace()==RACE_PYRO or c:GetRace()==RACE_ROCK or c:GetRace()==RACE_WINDBEAST
	or c:GetRace()==RACE_PLANT or c:GetRace()==RACE_INSECT or c:GetRace()==RACE_THUNDER or c:GetRace()==RACE_DRAGON
	  or c:GetRace()==RACE_BEAST or c:GetRace()==RACE_BEASTWARRIOR or c:GetRace()==RACE_DINOSAUR or c:GetRace()==RACE_FISH
	  or c:GetRace()==RACE_SEASERPENT  or c:GetRace()==RACE_REPTILE  or c:GetRace()==RACE_PSYCHO  or c:GetRace()==RACE_DEVINE
	  or c:GetRace()==RACE_CREATORGOD  or c:GetRace()==RACE_WYRM
end
function c18706018.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (re:GetHandler():GetRace()==RACE_WARRIOR or re:GetHandler():GetRace()==RACE_SPELLCASTER or re:GetHandler():GetRace()==RACE_ZOMBIE or re:GetHandler():GetRace()==RACE_MACHINE
	or re:GetHandler():GetRace()==RACE_AQUA or re:GetHandler():GetRace()==RACE_PYRO or re:GetHandler():GetRace()==RACE_ROCK or re:GetHandler():GetRace()==RACE_WINDBEAST
	or re:GetHandler():GetRace()==RACE_PLANT or re:GetHandler():GetRace()==RACE_INSECT or re:GetHandler():GetRace()==RACE_THUNDER or re:GetHandler():GetRace()==RACE_DRAGON
	  or re:GetHandler():GetRace()==RACE_BEAST or re:GetHandler():GetRace()==RACE_BEASTWARRIOR or re:GetHandler():GetRace()==RACE_DINOSAUR or re:GetHandler():GetRace()==RACE_FISH
	  or re:GetHandler():GetRace()==RACE_SEASERPENT  or re:GetHandler():GetRace()==RACE_REPTILE  or re:GetHandler():GetRace()==RACE_PSYCHO  or re:GetHandler():GetRace()==RACE_DEVINE
	  or re:GetHandler():GetRace()==RACE_CREATORGOD  or re:GetHandler():GetRace()==RACE_WYRM)
end