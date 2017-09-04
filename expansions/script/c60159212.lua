--澄 破碎的假面
function c60159212.initial_effect(c)
	--only 1 can exists
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e21:SetCondition(c60159212.excon)
	c:RegisterEffect(e21)
	local e31=e21:Clone()
	e31:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e31)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD)
	e41:SetRange(LOCATION_MZONE)
	e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e41:SetTargetRange(1,0)
	e41:SetCode(EFFECT_CANNOT_SUMMON)
	e41:SetTarget(c60159212.sumlimit)
	c:RegisterEffect(e41)
	local e51=e41:Clone()
	e51:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e51)
	local e61=e41:Clone()
	e61:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e61)
	local e81=Effect.CreateEffect(c)
	e81:SetType(EFFECT_TYPE_FIELD)
	e81:SetCode(EFFECT_SELF_DESTROY)
	e81:SetRange(LOCATION_MZONE)
	e81:SetTargetRange(LOCATION_MZONE,0)
	e81:SetTarget(c60159212.destarget)
	c:RegisterEffect(e81)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5b25),4,3)
	c:EnableReviveLimit()
	--cannot disable summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5b25))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159212,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c60159212.thcost)
	e3:SetTarget(c60159212.thtg)
	e3:SetOperation(c60159212.thop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c60159212.condition)
	e4:SetTarget(c60159212.target3)
	e4:SetOperation(c60159212.operation3)
	c:RegisterEffect(e4)
end
function c60159212.sumlimit(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_XYZ)
end
function c60159212.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_XYZ)
end
function c60159212.excon(e,tp)
	return Duel.IsExistingMatchingCard(c60159212.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159212.destarget(e,c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_XYZ) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c60159212.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60159212.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER)
end
function c60159212.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60159212.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c60159212.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159212.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159204,1))
			local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
				Duel.HintSelection(g2)
				local tc=g2:GetFirst()
				tc:AddCounter(0x1137+COUNTER_NEED_ENABLE,2)
			end
		end
	end
end
function c60159212.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159212.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159212.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60159212.filter3(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c60159212.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159212.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end