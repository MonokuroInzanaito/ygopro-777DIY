--Stella-星序
function c75646129.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(0x400+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(0x1)
	e4:SetCode(30)
	e4:SetValue(aux.xyzlimit)
	c:RegisterEffect(e4)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c75646129.xyzcon)
	e1:SetOperation(c75646129.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Damage1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646129,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c75646129.cost)
	e2:SetCondition(c75646129.con)
	e2:SetTarget(c75646129.tg)
	e2:SetOperation(c75646129.op)
	c:RegisterEffect(e2)
	--Damage2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c75646129.damcon)
	e2:SetTarget(c75646129.damtg)
	e2:SetOperation(c75646129.damop)
	c:RegisterEffect(e2)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(0x200+CATEGORY_DAMAGE)
	e6:SetType(0x1+0x80)
	e6:SetCode(1014)
	e6:SetProperty(0x10+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(c75646129.spcon)
	e6:SetTarget(c75646129.sptg)
	e6:SetOperation(c75646129.spop)
	c:RegisterEffect(e6)
end
function c75646129.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x62c3) and c:GetRank()==4 and c:IsCanBeXyzMaterial(xyzc)
end
function c75646129.xyzfilter1(c,g)
	return g:IsExists(c75646129.xyzfilter2,2,c,c:GetRank())
end
function c75646129.xyzfilter2(c,rk)
	return c:GetRank()==4
end
function c75646129.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,0x4)
	local minc=3
	local maxc=3
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c75646129.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c75646129.mfilter,tp,0x4,0,nil,c)
	end
	return maxc>=3 and mg:IsExists(c75646129.xyzfilter1,1,nil,mg,ct)
end
function c75646129.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c75646129.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c75646129.mfilter,tp,0x4,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,0x4)
		local minc=3
		local maxc=3
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(3,tp,513)
		g=mg:FilterSelect(tp,c75646129.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(3,tp,513)
		local g2=mg:FilterSelect(tp,c75646129.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,0x400)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c75646129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75646129.con(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return ct2>ct1
end
function c75646129.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=ct2-ct1
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function c75646129.op(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=ct2-ct1
	if ct>0 then
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	end
end
function c75646129.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)
end
function c75646129.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c75646129.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c75646129.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c75646129.spfilter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646129.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and c75646129.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingTarget(c75646129.spfilter,tp,0x10,0,1,nil,e,tp) end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectTarget(tp,c75646129.spfilter,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,0x200,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646129.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)~=0 then
		if Duel.Damage(1-tp,100,0x40)~=0 then 
		Duel.RaiseEvent(e:GetHandler(),0x10000000+75646112,e,0,tp,0,0)
		end
	end end
end