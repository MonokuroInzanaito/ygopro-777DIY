--八枢罪 莫言
function c60159109.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,60159109)
    e1:SetTarget(c60159109.target)
    e1:SetOperation(c60159109.activate)
    c:RegisterEffect(e1)
	--Activate
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159101,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,60159109)
    e2:SetCondition(c60159109.condition)
    e2:SetTarget(c60159109.settg)
    e2:SetOperation(c60159109.setop)
    c:RegisterEffect(e2)
end
function c60159109.spfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL)
end
function c60159109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60159109.spfilter,tp,LOCATION_REMOVED,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and ct>3 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c60159109.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60159109.spfilter,tp,LOCATION_REMOVED,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
	if ct>3 then
		local a=Group.CreateGroup()
		for i=1,4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
			local g1=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
			if not g1:GetFirst():IsImmuneToEffect(e) then 
				a:Merge(g1)
			end
		end
		if Duel.SendtoDeck(a,nil,2,REASON_EFFECT)>0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
function c60159109.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) 
		and eg:GetFirst():IsSetCard(0x3b25) and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c60159109.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c60159109.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsSSetable() then
        Duel.SSet(tp,c)
        Duel.ConfirmCards(1-tp,c)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end