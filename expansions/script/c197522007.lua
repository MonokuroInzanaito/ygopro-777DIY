function c197522007.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,197522007)
	e1:SetCondition(c197522007.condition)
	e1:SetCost(c197522007.cost)
	e1:SetOperation(c197522007.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(197522007,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,197523007)
	e2:SetCondition(c197522007.drcon)
	e2:SetTarget(c197522007.drtg)
	e2:SetOperation(c197522007.drop)
	c:RegisterEffect(e2)
end
function c197522007.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c197522007.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0 and rp~=tp
end
function c197522007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD)
end
function c197522007.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c197522007.repop)
end
function c197522007.filter(c,tp,eg,ep,ev,re,r,rp)
	return c:IsRace(RACE_BEAST) and c:GetLevel()==1
end
function c197522007.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and rp~=tp
end
function c197522007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	if rp~=tp then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c197522007.drop(e,tp,eg,ep,ev,re,r,rp)
	   local g=Duel.SelectTarget(tp,c197522007.filter,tp,LOCATION_DECK,LOCATION_DECK,1,1,nil,e,tp)
	   local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end

