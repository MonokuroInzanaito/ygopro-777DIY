--镜世录 正体不明
function c29201041.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29201041,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c29201041.ttcon)
	e1:SetOperation(c29201041.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--summon with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29201041,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c29201041.otcon)
	e2:SetOperation(c29201041.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	--tribute check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c29201041.valcheck)
	c:RegisterEffect(e4)
	--give atk effect only when  summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SUMMON_COST)
	e5:SetOperation(c29201041.facechk)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--copy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29201041,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCondition(c29201041.copycon)
	e6:SetTarget(c29201041.copytg)
	e6:SetOperation(c29201041.copyop)
	c:RegisterEffect(e6)
	--summon success
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(29201041,3))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c29201041.spcon)
	e8:SetTarget(c29201041.sptg)
	e8:SetOperation(c29201041.spop)
	c:RegisterEffect(e8)
	--splimit
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_SZONE)
	e12:SetTargetRange(1,0)
	e12:SetTarget(c29201041.splimit)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_CANNOT_SUMMON)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetRange(LOCATION_SZONE)
	e13:SetTargetRange(1,0)
	e13:SetTarget(c29201041.splimit)
	c:RegisterEffect(e13)
	--race
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e9:SetCode(EFFECT_CHANGE_CODE)
	e9:SetValue(29201042)
	c:RegisterEffect(e9)
	--[[tribute check
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(c29201041.valcheck1)
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)]]
end
function c29201041.splimit(e,c)
	return not c:IsSetCard(0x63e0)
end
function c29201041.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3
end
function c29201041.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c29201041.otfilter(c,tp)
	return c:IsSetCard(0x63e0) and (c:IsControler(tp) or c:IsFaceup())
end
function c29201041.otcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c29201041.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:GetLevel()>6 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.GetTributeCount(c,mg)>0
end
function c29201041.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c29201041.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c29201041.valcheck1(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x63e0) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c29201041.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function c29201041.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local catk=tc:GetTextAttack()
		local cdef=tc:GetTextDefense()
		atk=atk+(catk>=0 and catk or 0)
		def=def+(cdef>=0 and cdef or 0)
		tc=g:GetNext()
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		--def continuous effect
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end
function c29201041.copycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c29201041.filter(c,e)
	return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsCode(29201041) --and c:IsCanBeEffectTarget(e)
end
function c29201041.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c29201041.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29201041.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c29201041.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
end
function c29201041.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	end
end
function c29201041.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE --and e:GetLabel()==1
end
function c29201041.spfilter(c)
	return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and not c:IsType(TYPE_PENDULUM) 
end
function c29201041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return --[[ct>0 and]] Duel.IsExistingMatchingCard(c29201041.spfilter,tp,LOCATION_DECK,0,1,nil) end
	--and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,ct,0x63e0)
	--and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201041.spop(e,tp,eg,ep,ev,re,r,rp)
	--[[if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,ct,nil,0x63e0)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		if sg:GetCount()>ct then
			local rg=sg:Select(tp,ct,ct,nil)
			sg=rg
		end
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end]]
	local ct=e:GetHandler():GetMaterialCount()
	local mg=Duel.GetMatchingGroup(c29201041.spfilter,tp,LOCATION_DECK,0,nil)
	local tg=Group.CreateGroup()
	if mg:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		for i=1,ct do
			local sg=mg:Select(tp,1,1,nil):GetFirst()
		    mg:Remove(c29201041.spfilter1,nil,sg:GetLevel())
		    tg:AddCard(sg)
		--tg1:Merge(tg)
	--[[local tc1=mg:Select(tp,1,1,nil):GetFirst()
	mg:Remove(Card.IsLevel,nil,mg1:GetFirst():GetLevel())
	if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(19337371,1)) then
	   local tc2=mg:Select(tp,1,1,nil):GetFirst()
		mg:Remove(Card.IsLevel,nil,mg2:GetFirst():GetLevel())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(19337371,1)) then
		local tc3=mg:Select(tp,1,1,nil):GetFirst()
		 mg:Remove(Card.IsLevel,nil,mg3:GetFirst():GetLevel())
		 g1:Merge(g3)
		end
	end]]
	end
		local tc=tg:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			Duel.RaiseEvent(tc,EVENT_CUSTOM+29201000,e,0,tp,0,0)
			tc=tg:GetNext()
		end
end
function c29201041.spfilter1(c,lv)
	return c:GetLevel()==lv
end
