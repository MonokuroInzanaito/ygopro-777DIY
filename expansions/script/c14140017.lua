--血泪·八重樱
local m=14140017
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.fscon)
	e1:SetOperation(cm.fsop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e)
		local l=e:GetHandler():GetFlagEffect(m)
		local cl=e:GetHandler():GetFlagEffectLabel(m-40000)
		return cl~=l
	end)
	e1:SetOperation(function(e)
		local l=e:GetHandler():GetFlagEffect(m)
		e:GetHandler():ResetFlagEffect(m-40000)
		e:GetHandler():RegisterFlagEffect(m-40000,0x1fe1000,EFFECT_FLAG_CLIENT_HINT,1,l,aux.Stringid(m,l))
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,9))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():GetFlagEffect(m)<8 and Duel.GetFlagEffect(tp,m-10000)==0 and Duel.CheckLPCost(tp,800) end
		Duel.PayLPCost(tp,800)
		Duel.RegisterFlagEffect(tp,m-10000,RESET_CHAIN,0,1)
		e:GetHandler():RegisterFlagEffect(m,0x1fe1000,0,1)
	end)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-800)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:GetAttack()==0 then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
		end
	end)
	c:RegisterEffect(e1)
end
function cm.fsfilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:GetRace()>0
end
function cm.exfilter(c,fc)
	if c==fc then return false end
	return cm.fsfilter(c,fc) and c:GetLevel()==8 and c:IsAbleToRemove()
end
--[[function cm.SplitRace(c)
	local res={}
	local race=c:GetRace()
	local i=1
	while i<=RACE_ALL do
		if bit.band(i,race)~=0 then table.insert(res,i) end
		i=i*2
	end
	return res
end]]
function cm.CheckRecursive(c,mg,sg,exg,tp,fc,chkf)	
	if exg and sg:GetCount()<3 and exg:IsContains(c) then return false end
	if sg:IsExists(Card.IsRace,1,nil,c:GetRace()) then return false end
	--[[local ex=0
	local racelist=cm.SplitRace(c)
	for i,race in pairs(racelist) do
		if sg:IsExists(Card.IsRace,1,nil,race) then ex=ex+1 end
	end
	if ex>=#racelist then return false end]]
	if sg:GetCount()==7 then return true end
	sg:AddCard(c)
	if chkf~=PLAYER_NONE and not sg:IsExists(aux.FConditionCheckF,1,nil,chkf) then
		sg:RemoveCard(c)
		return false
	end
	--if sg:GetCount()==8 then return Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0 end
	local res=mg:IsExists(cm.CheckRecursive,1,sg,mg,sg,exg,tp,fc,PLAYER_NONE)
	sg:RemoveCard(c)
	return res
end
function cm.fscon(e,g,gc,chkfnf)
	if g==nil then return false end
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	local chkf=bit.band(chkfnf,0xff)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local fs=false
	local mg=g:Filter(cm.fsfilter,nil,c)
	local exg=nil
	if bit.band(chkfnf,0x100)==0 then
		exg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,mg,c)
		mg:Merge(exg)
	end
	return mg:IsExists(cm.CheckRecursive,1,sg,mg,sg,exg,tp,c,chkf,0)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	if gc then sg:AddCard(gc) end
	local chkf=bit.band(chkfnf,0xff)
	local mg=eg:Filter(cm.fsfilter,nil,c)
	local exg=nil
	if bit.band(chkfnf,0x100)==0 then
		exg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,mg,c)
		mg:Merge(exg)
	end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,cm.CheckRecursive,1,1,sg,mg,sg,exg,tp,c,chkf)
		chkf=PLAYER_NONE
		sg:Merge(g)
	until sg:GetCount()==8
	if exg then
		local rg=sg:Filter(function(c,g) return g:IsContains(c) end,nil,exg)
		for tc in aux.Next(rg) do
			tc:RegisterFlagEffect(m-20000,RESET_CHAIN,0,1)
		end
	end
	Duel.SetFusionMaterial(sg)
end
function cm.SetMaterial(c,g)
	Card.SetMaterial(c,g)
	if not g then return end
	local rg=g:Filter(function(c) return c:GetFlagEffect(m-20000)>0 end,nil)
	if rg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		local p=c:GetControler()
		Duel.Remove(rg,POS_FACEDOWN,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT)
		Duel.ConfirmCards(1-p,rg)
		for tc in aux.Next(rg) do
			tc:ResetFlagEffect(m-20000)
		end
		g:Sub(rg)
	end
end