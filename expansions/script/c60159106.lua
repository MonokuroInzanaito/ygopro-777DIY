--八枢罪 本源
function c60159106.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(c60159106.condition2)
    e1:SetTarget(c60159106.target)
    e1:SetOperation(c60159106.activate)
    c:RegisterEffect(e1)
	--Activate
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159101,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,60159106)
    e2:SetCondition(c60159106.condition)
    e2:SetTarget(c60159106.settg)
    e2:SetOperation(c60159106.setop)
    c:RegisterEffect(e2)
end
function c60159106.spfilter(c)
    return c:IsSetCard(0x3b25) and c:GetRank()==5
end
function c60159106.condition2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60159106.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct>2
end
function c60159106.filter(c,e,tp)
    return c:IsSetCard(0x3b25) and c:GetRank()==7 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159106.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60159106.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60159106.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c60159106.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
	if ct>0 then
		local a=Group.CreateGroup()
		local b=Group.CreateGroup()
		local t={}
		for i=1,ct do t[i]=i end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159106,0))
		local ac=Duel.AnnounceNumber(tp,table.unpack(t))
		for i=1,ac do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
			local g1=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
			if not g1:GetFirst():IsImmuneToEffect(e) then 
				a:Merge(g1)
				b:Merge(g1:GetFirst():GetOverlayGroup())
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c60159106.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g2:GetCount()>0 and a:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(g2:GetFirst(),b)
			Duel.Overlay(g2:GetFirst(),a)
		end
    end
end
function c60159106.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) 
		and eg:GetFirst():IsSetCard(0x3b25) and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c60159106.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c60159106.setop(e,tp,eg,ep,ev,re,r,rp)
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