--神妙的巫女 玉依姬
function c10958802.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsSetCard,0x23a),aux.NonTuner(nil))
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c10958802.synlimit)
	c:RegisterEffect(e0)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c10958802.syncon)
	e1:SetTarget(c10958802.syntg)
	e1:SetValue(1)
	e1:SetOperation(c10958802.synop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10958802,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c10958802.drcon)
	e2:SetTarget(c10958802.drtg)
	e2:SetOperation(c10958802.drop)
	c:RegisterEffect(e2)
	--hand synchro for double tuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c10958802.syncon)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	c:RegisterEffect(e3)	
end
function c10958802.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x23a)
end
function c10958802.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10958802.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10958802.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10958802.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c10958802.synfilter2(c,syncard,tuner,f,g,lv,minc,maxc)
	if c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c)) then
		lv=lv-c:GetLevel()
		if lv<0 then return false end
		if lv==0 then return minc==1 end
		return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc-1,maxc-1,syncard)
	else return false end
end
function c10958802.syncon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c10958802.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g1=Duel.GetMatchingGroup(c10958802.synfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or Duel.IsExistingMatchingCard(c10958802.synfilter2,tp,LOCATION_HAND,0,1,nil,syncard,c,f,g1,lv,minc,maxc)
end
function c10958802.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g1=Duel.GetMatchingGroup(c10958802.synfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local g2=Duel.GetMatchingGroup(c10958802.synfilter2,tp,LOCATION_HAND,0,nil,syncard,c,f,g1,lv,minc,maxc)
	if not g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or (g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10958802,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g2:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if lv>tc:GetLevel() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-tc:GetLevel(),minc-1,maxc-1,syncard)
			sg:Merge(tg)
		end
		Duel.SetSynchroMaterial(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
		Duel.SetSynchroMaterial(sg)
	end
end
