--Stella-星夏
function c75646115.initial_effect(c)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x2)
	e2:SetRange(0x4)
	e2:SetCode(29)
	e2:SetTargetRange(0x6,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x62c3))
	c:RegisterEffect(e2)
	--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75646115,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e5:SetType(0x82)
	e5:SetRange(0x4)
	e5:SetCountLimit(1,7564615)
	e5:SetProperty(0x10000)
	e5:SetCode(1111)
	e5:SetCondition(c75646115.ctcon)
	e5:SetTarget(c75646115.tg)
	e5:SetOperation(c75646115.op)
	c:RegisterEffect(e5)
end
function c75646115.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re and re:GetHandler():IsSetCard(0x62c3) and bit.band(r,0x40)~=0
end
function c75646115.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x62c3) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646115.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c75646115.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646115.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75646115.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)~=0 then
		--xyzlv
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(0x1)
		e1:SetCode(242)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(0x4)
		e1:SetValue(c75646115.xyzlv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		--special xyz rule
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(0x1)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(75646115)
		e2:SetRange(0x4)
		e2:SetProperty(0x400+EFFECT_FLAG_UNCOPYABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.Damage(1-tp,100,0x40)
	end
end
function c75646115.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end