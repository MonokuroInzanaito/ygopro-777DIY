--梦中的少女 哲尔尼亚斯
function c60159009.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(c60159009.mfilter),3,2)
    c:EnableReviveLimit()
	--destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159009,0))
    e1:SetCategory(CATEGORY_RELEASE+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,60159009)
    e1:SetCost(c60159009.descost)
    e1:SetTarget(c60159009.destg)
    e1:SetOperation(c60159009.desop)
    c:RegisterEffect(e1)
	--search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c60159009.regcon)
    e2:SetOperation(c60159009.regop)
    c:RegisterEffect(e2)
	--to grave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60159009,6))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCondition(c60159009.condition)
    e3:SetTarget(c60159009.target)
    e3:SetOperation(c60159009.operation)
    c:RegisterEffect(e3)
end
function c60159009.mfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159009.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60159009.filter(c)
    return (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c60159009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159009.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
end
function c60159009.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c60159009.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_ONFIELD) then
			Duel.HintSelection(g)
		end
        if Duel.Release(g,REASON_EFFECT)~=0 then
			local opt=Duel.SelectOption(tp,aux.Stringid(60159009,1),aux.Stringid(60159009,2))
			if opt==0 then
				Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
			else
				Duel.Recover(tp,tc:GetDefense(),REASON_EFFECT)
			end
		end
    end
end
function c60159009.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60159009.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c60159009.thcon)
    e1:SetOperation(c60159009.thop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60159009.thfilter(c)
    return (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c60159009.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60159009.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c60159009.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60159009)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159009,5))
    local g=Duel.SelectMatchingCard(tp,c60159009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
		local tc=g:GetFirst()
        if tc:IsAbleToHand() and tc:IsAbleToGrave() then
			local opt=Duel.SelectOption(tp,aux.Stringid(60159009,3),aux.Stringid(60159009,4))
			if opt==0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			else
				Duel.SendtoGrave(g,nil,REASON_EFFECT)
			end 
		elseif tc:IsAbleToHand() then
			local opt=Duel.SelectOption(tp,aux.Stringid(60159009,3))
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif tc:IsAbleToGrave() then
			local opt=Duel.SelectOption(tp,aux.Stringid(60159009,4))
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
		end
    end
end
function c60159009.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159009.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159009.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end