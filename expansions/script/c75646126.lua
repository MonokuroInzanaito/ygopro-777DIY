--Stella-星流
function c75646126.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x62c3),4,2)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x200+CATEGORY_DAMAGE)
	e1:SetType(0x40)
	e1:SetRange(0x4)
	e1:SetCountLimit(1)
	e1:SetCode(1002)
	e1:SetCost(c75646126.spcost)
	e1:SetTarget(c75646126.sptg)
	e1:SetOperation(c75646126.spop)
	c:RegisterEffect(e1)
	--Duel.AddCustomActivityCounter(75646126,3,c75646126.counterfilter)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x1+0x800)
	e2:SetCode(1108)
	e2:SetCondition(c75646126.efcon)
	e2:SetOperation(c75646126.efop)
	c:RegisterEffect(e2)
end
--function c75646126.counterfilter(c)
	--return c:IsSetCard(0x62c3) or c:GetSummonLocation()~=LOCATION_EXTRA 
--end
function c75646126.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end
--function c75646126.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	--return not c:IsSetCard(0x62c3) and c:IsLocation(0x40)
--end
function c75646126.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsType(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(0x10) or c:IsFaceup())
end
function c75646126.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646126.filter,tp,0x30,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646126.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x4)<=0 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646126.filter,tp,0x30,0,1,1,nil,e,tp)
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,0x5)~=0 then
	Duel.Damage(1-tp,100,0x40)
	end
end
function c75646126.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c75646126.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x1)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0x4)
	e1:SetCode(47)
	e1:SetCountLimit(1)
	e1:SetValue(c75646126.valcon)
	e1:SetReset(0x1000+0x1fe0000)
	rc:RegisterEffect(e1)
	if not rc:IsType(0x20) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(0x1)
		e2:SetCode(115)
		e2:SetValue(0x20)
		e2:SetReset(0x1000+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c75646126.valcon(e,re,r,rp)
	return bit.band(r,0x40)~=0 and e:GetHandler():GetOverlayCount()~=0
end