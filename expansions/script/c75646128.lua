--Stella-星痕
function c75646128.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c75646128.mfilter,7,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(0x400+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(0x1)
	e1:SetCode(30)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(1027)
	e2:SetType(0x100)
	e2:SetRange(0x4)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCost(c75646128.cost)
	e2:SetCondition(c75646128.damcon)
	e2:SetTarget(c75646128.damtg)
	e2:SetOperation(c75646128.damop)
	c:RegisterEffect(e2)  
	--Lock
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x2)
	e3:SetRange(0x4)
	e3:SetCode(22)
	e3:SetProperty(0x800)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c75646128.splimit)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(0x200+CATEGORY_DAMAGE)
	e4:SetType(0x81)
	e4:SetCode(1014)
	e4:SetProperty(0x14010)
	e4:SetTarget(c75646128.sptg)
	e4:SetOperation(c75646128.spop)
	c:RegisterEffect(e4)
end
function c75646128.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75646128.damcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(0x4000)
		and re:IsActiveType(0x6)
end
function c75646128.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c75646128.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,500,0x40)~=0 then 
		Duel.RaiseEvent(e:GetHandler(),0x10000000+75646112,e,0,tp,0,0)
	end
end
function c75646128.mfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x62c3)
end
function c75646128.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (se:IsHasType(0x7f0) or se:IsHasProperty(0x8) or se:IsHasProperty(EFFECT_FLAG_OWNER_RELATE))
end
function c75646128.spfilter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646128.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and c75646128.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingTarget(c75646128.spfilter,tp,0x10,0,1,nil,e,tp) end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectTarget(tp,c75646128.spfilter,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,0x200,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646128.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)~=0 then
		if Duel.Damage(1-tp,100,0x40)~=0 then 
		Duel.RaiseEvent(e:GetHandler(),0x10000000+75646112,e,0,tp,0,0)
		end end
	end 
end