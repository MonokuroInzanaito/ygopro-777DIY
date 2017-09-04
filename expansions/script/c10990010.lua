--萌板娘 哔哩哔哩
function c10990010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,4)
	c:EnableReviveLimit()  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10990010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10990010.condition)
	e1:SetTarget(c10990010.sptg2)
	e1:SetOperation(c10990010.spop2)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10990010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c10990010.sptg)
	e4:SetOperation(c10990010.spop)
	c:RegisterEffect(e4)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x232))
	e2:SetValue(2233)
	c:RegisterEffect(e2)  
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetValue(c10990010.val)
	c:RegisterEffect(e5)   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10990010,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10990010.target)
	e3:SetOperation(c10990010.activate)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetTarget(c10990010.target2)
	e6:SetOperation(c10990010.activate2)
	c:RegisterEffect(e6)
end
function c10990010.spfilter(c,e,tp)
	return c:IsSetCard(0x232) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10990010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10990010.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10990010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10990010.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10990010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0
end
function c10990010.spfilter(c,e,tp)
	return c:IsSetCard(0x232) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10990010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAbleToGrave,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_OVERLAY)
end
function c10990010.spop2(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	if og:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=og:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) 
	and tc:IsSetCard(0x232) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10990010.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return dam
	else return dam/2 end
end
function c10990010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,nil,33,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,33000)
end
function c10990010.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsCanRemoveCounter(tp,1,1,nil,33,REASON_EFFECT) then return end
	Duel.RemoveCounter(tp,1,1,nil,33,REASON_EFFECT)
	Duel.Damage(1-tp,33000,REASON_EFFECT)
end
function c10990010.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckRemoveOverlayCard(tp,1,1,22,REASON_EFFECT) then return end
	Duel.RemoveOverlayCard(tp,1,1,22,22,REASON_EFFECT)
	Duel.Damage(1-tp,33000,REASON_EFFECT)
end
function c10990010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,22,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,33000)
end
