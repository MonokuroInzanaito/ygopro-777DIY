--约会圣女 五河士织
function c18706076.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18706076.spcon)
	e1:SetOperation(c18706076.spcop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(423585,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c18706076.spcost)
	e3:SetTarget(c18706076.sptg)
	e3:SetOperation(c18706076.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(18706076,ACTIVITY_SPSUMMON,c18706076.counterfilter)
end
function c18706076.counterfilter(c)
	return c:IsSetCard(0xabb) or c:IsSetCard(0xab0)
end
function c18706076.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  and Duel.GetCustomActivityCount(18706076,tp,ACTIVITY_SPSUMMON)==0
end
function c18706076.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xabb) or c:IsSetCard(0xab0)
end
function c18706076.spcop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1)
	--oath effects
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c18706076.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c18706076.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c18706076.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706076.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c18706076.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c18706076.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,18706077,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	local t={}
	local i=1
	local p=1
	local lv=9
	for i=1,8 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26082117,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c18706076.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18706077,0,0x4011,0,0,ct,RACE_FAIRY,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,18706077)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(ct)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end