--悼别过往
function c60159219.initial_effect(c)
	c:SetUniqueOnField(1,0,60159219)
	--Activate
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_ACTIVATE)
    e11:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e11)
	--handes
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,60159219)
    e1:SetCost(c60159219.cost)
    e1:SetTarget(c60159219.target)
    e1:SetOperation(c60159219.operation)
    c:RegisterEffect(e1)
	--draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159219,0))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c60159219.condition2)
    e2:SetTarget(c60159219.target2)
    e2:SetOperation(c60159219.operation2)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c60159219.spcon)
    e3:SetTarget(c60159219.sptg)
    e3:SetOperation(c60159219.spop)
    c:RegisterEffect(e3)
end
function c60159219.cfilter(c,e,tp)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(c60159219.cfilter2,tp,LOCATION_DECK,0,1,nil,c:GetOriginalLevel(),c:GetCode(),e,tp)
end
function c60159219.cfilter2(c,lv,code,e,tp)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:GetCode()~=code 
		and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159219.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.CheckReleaseGroup(tp,c60159219.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c60159219.cfilter,1,1,nil,e,tp)
	local lv=g:GetFirst():GetOriginalLevel()
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
	for i=1,lv do
		Duel.RegisterFlagEffect(tp,60159219,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60159219.filter(c,lv,code,e,tp)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:GetCode()~=code
		and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159219.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60159219.operation(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetFlagEffect(tp,60159219)
	local code=e:GetLabel()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60159219.filter,tp,LOCATION_DECK,0,1,1,nil,lv,code,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
	Duel.ResetFlagEffect(tp,60159219)
end
function c60159219.filter2(c,tp)
    return c:IsSetCard(0x5b25) and c:IsControler(tp) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c60159219.condition2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60159219.filter2,1,nil,tp)
end
function c60159219.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159219.operation2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c60159219.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetPreviousControler()==tp and rp~=tp and c:IsReason(REASON_DESTROY)
end
function c60159219.tgfilter(c,e,tp)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60159219.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159219.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60159219.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159219.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end