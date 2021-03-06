--动物朋友 南之朱雀
function c33700175.initial_effect(c)
	 c:EnableReviveLimit()
	 aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsCode,33700175),18,true)
   --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700175,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700175.tg)
	e1:SetOperation(c33700175.op)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33700175.spcon)
	e2:SetOperation(c33700175.spop)
	c:RegisterEffect(e2)
	--fusion material
   -- local e3=Effect.CreateEffect(c)
   -- e3:SetType(EFFECT_TYPE_SINGLE)
   -- e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
   -- e3:SetCode(EFFECT_FUSION_MATERIAL)
   -- e3:SetCondition(c33700175.fuscon)
	--e3:SetOperation(c33700175.fusop)
   -- c:RegisterEffect(e3)
end
function c33700175.ffilter1(c,tp)
   local lv=c:GetLevel()
   return lv>0  and Duel.IsExistingMatchingCard(c33700175.ffilter2,tp,LOCATION_MZONE,0,nil,lv,c:GetRace(),c:GetFusionAttribute())
end
function c33700175.ffilter2(c,lv,rc,att)
	 return c:GetLevel()==lv and c:GetRace()~=rc  and not c:IsFusionAttribute(att)
end
function c33700175.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local tp=e:GetHandlerPlayer()
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return c33700175.ffilter1(gc,tp)		 
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	local g4=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		if c33700175.ffilter1(tc,tp) then
			local pc=mg:Filter(c33700175.ffilter2,tc,tc:GetLevel(),tc:GetRace(),tc:GetFusionAttribute())
			g1:AddCard(tc)
			g3:AddCard(pc)
			if aux.FConditionCheckF(tc,chkf) then 
			g2:AddCard(tc) 
			g4:AddCard(pc) end
		end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return (g3:IsExists(aux.FConditionFilterF2,1,nil,g2))
			or g4:IsExists(aux.FConditionFilterF2,1,nil,g1)
	else
		return (g1:IsExists(aux.FConditionFilterF2,1,nil,g2))
	end
end
function c33700175.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		local sg1=Group.CreateGroup()
   local sg2=Group.CreateGroup()
		if c33700175.ffilter1(gc,tp) then
			sg1:Merge(g:Filter(c33700175.ffilter2,gc,gc:GetLevel(),gc:GetRace(),gc:GetFusionAttribute()))
		   sg2:Merge(g:Filter(c33700175.ffilter1,gc,tp))
		end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=sg1:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
   
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=g:Filter(aux.FConditionCheckF,nil,chkf):FilterSelect(tp,c33700175.ffilter1,1,1,nil,tp)
	else g1=g:FilterSelect(tp,c33700175.ffilter1,1,1,nil,tp) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	if c33700175.ffilter1(tc1,tp) then
		sg1:Merge(g:Filter(c33700175.ffilter2,tc1,tc1:GetLevel(),tc1:GetRace(),tc1:GetFusionAttribute()))
	end
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	g2=sg1:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c33700175.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x442) and c:IsSummonableCard()  and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c33700175.spfilter2,1,c,fc,c:GetCode())
end
function c33700175.spfilter2(c,fc,code)
	return c:IsFusionSetCard(0x442) and c:IsSummonableCard() and c:IsCanBeFusionMaterial(fc) and c:GetCode()~=code
end
function c33700175.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c33700175.spfilter1,1,nil,tp,c)
end
function c33700175.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c33700175.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c33700175.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c33700175.cfilter(c)
   return  c:IsPublic()
end
function c33700175.pfilter(c)
   return not c:IsPublic()
end
function c33700175.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	 local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return  sg:GetCount()>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,sg:GetCount(),nil) and not Duel.IsExistingMatchingCard(c33700175.cfilter,tp,LOCATION_HAND,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,sg:GetCount(),0,0)
end
function c33700175.op(e,tp,eg,ep,ev,re,r,rp)
	 local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g=Duel.GetMatchingGroup(c33700175.pfilter,tp,LOCATION_HAND,0,nil)
	if sg:GetCount()~=g:GetCount() then return end
	Duel.ConfirmCards(1-tp,sg)
	if  sg:GetClassCount(Card.GetCode)==sg:GetCount() then
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	local ct=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
	if ct>0 and tg:GetCount()>=ct then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sel=tg:Select(tp,ct,ct,nil)
		Duel.SendtoHand(sel,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sel)
	end
end
end