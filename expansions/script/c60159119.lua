--八枢罪之始 祈愿
function c60159119.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,60159119)
	e3:SetCost(c60159119.thcost)
    e3:SetTarget(c60159119.thtg)
    e3:SetOperation(c60159119.thop)
    c:RegisterEffect(e3)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCountLimit(1,60159119)
    e2:SetCondition(c60159119.drcon)
    e2:SetTarget(c60159119.drtg)
    e2:SetOperation(c60159119.drop)
    c:RegisterEffect(e2)
	--spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,6019119+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(c60159119.spcon)
    e2:SetTarget(c60159119.sptg)
    e2:SetOperation(c60159119.spop)
    c:RegisterEffect(e2)
end
function c60159119.cfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c60159119.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159119.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60159119.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60159119.filter(c)
    return c:IsSetCard(0x3b25) and c:IsAbleToHand()
end
function c60159119.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159119.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60159119.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159119.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60159119.cfilter2(c,tp)
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and rp~=tp and c:IsType(TYPE_XYZ) and c:IsSetCard(0x3b25)
end
function c60159119.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60159119.cfilter2,1,nil,tp)
end
function c60159119.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159119.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c60159119.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetPreviousControler()==tp and rp~=tp and bit.band(r,0x41)==0x41 and c:GetPreviousPosition(POS_FACEUP) 
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159119.xyzfilter(c,e,tp,mc)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3b25) and c:GetRank()==5
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c60159119.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159119.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60159119.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsFaceup() and not e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60159119.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
		local sc=g:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(e:GetHandler()))
			Duel.Overlay(sc,Group.FromCards(e:GetHandler()))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end