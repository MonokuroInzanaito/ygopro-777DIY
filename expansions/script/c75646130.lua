--Stella-天之星
function c75646130.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,75646128,75646129,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x1)
	e1:SetProperty(0x400+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(30)
	e1:SetValue(c75646130.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x2)
	e2:SetCode(34)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(0x40)
	e2:SetCondition(c75646130.spcon)
	e2:SetOperation(c75646130.spop)
	c:RegisterEffect(e2)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x100)
	e2:SetCode(1027)
	e2:SetRange(0x4)
	e2:SetCondition(c75646130.chcon)
	e2:SetCost(c75646130.cost)
	e2:SetTarget(c75646130.chtg)
	e2:SetOperation(c75646130.chop)
	c:RegisterEffect(e2)
	--specialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x1+0x80)
	e2:SetProperty(EFFECT_FLAG_DELAY+0x4000)
	e2:SetCode(1011)
	e2:SetCondition(c75646130.spcon1)
	e2:SetTarget(c75646130.sptg)
	e2:SetOperation(c75646130.spop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(1014)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(1013)
	c:RegisterEffect(e4)
end

function c75646130.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(0x40)
end
function c75646130.spfilter(c,code)
	return c:GetOriginalCode()==code and c:IsAbleToGraveAsCost()
end
function c75646130.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,0x4)
	if ft<-1 then return false end
	local g1=Duel.GetMatchingGroup(c75646130.spfilter,tp,0xc,0,nil,75646128)
	local g2=Duel.GetMatchingGroup(c75646130.spfilter,tp,0xc,0,nil,75646129)
	if g1:GetCount()==0 or g2:GetCount()==0 then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,0x4)
	local f2=g2:FilterCount(Card.IsLocation,nil,0x4)
	if ft==-1 then return f1>0 and f2>0
	else return f1>0 or f2>0 end
end
function c75646130.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,0x4)
	local g1=Duel.GetMatchingGroup(c75646130.spfilter,tp,0xc,0,nil,75646128)
	local g2=Duel.GetMatchingGroup(c75646130.spfilter,tp,0xc,0,nil,75646129)
	g1:Merge(g2)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,2 do
		Duel.Hint(3,tp,504)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,0x4):GetFirst()
			ft=ft+1
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		if i==1 then
			g1:Clear()
			if tc:GetOriginalCode()==75646128 then
				local sg=Duel.GetMatchingGroup(c75646130.spfilter,tp,0xc,0,tc,75646129)
				g1:Merge(sg)
			end
			if tc:GetOriginalCode()==75646129 then
				local sg=Duel.GetMatchingGroup(c75646130.spfilter,tp,0xc,0,tc,75646128)
				g1:Merge(sg)
			end
		end
	end
	Duel.SendtoGrave(g,0x5,0x80)
end
function c75646130.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(0x5) and e:GetHandler():IsPreviousLocation(0xc)
end
function c75646130.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
 and not c:IsCode(75646130)
end
function c75646130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>1
		and Duel.IsExistingMatchingCard(c75646130.filter,tp,0x10,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,2,tp,0x10)
end
function c75646130.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x4)<2 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646130.filter,tp,0x10,0,2,2,nil,e,tp)
	if g:GetCount()==2 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,0x4)
end
end
function c75646130.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c75646130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x2,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,0x80+0x4000)
end
function c75646130.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
end
function c75646130.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c75646130.repop)
end
function c75646130.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==0x2 or c:GetType()==0x4 then
		c:CancelToGrave(false)
	end
	if Duel.Damage(tp,800,0x40) then
	Duel.SendtoGrave(e:GetHandler(),0x40)
	end
end