--Ê¥ÕßµÄÒÀ´ú
function c99991068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99991068+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99991068.cost)
	e1:SetTarget(c99991068.target)
	e1:SetOperation(c99991068.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99991068,ACTIVITY_SPSUMMON,c99991068.counterfilter)
end
function c99991068.counterfilter(c)
	return  c:IsLocation(LOCATION_EXTRA) and not  c:IsType(TYPE_FUSION) 
end
function c99991068.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.GetCustomActivityCount(99991068,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,2000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99991068.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c99991068.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not  c:IsType(TYPE_FUSION) 
end
function c99991068.filter0(c,e,tp)
	return c.material and Duel.IsExistingMatchingCard(c99991068.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c,e,tp)
end
function c99991068.filter1(c,mg,e,tp)
	if c:IsForbidden() or not c:IsCanBeSpecialSummoned(e,0,tp,false,false)  then return false end
	return c:IsCode(table.unpack(mg.material))
end
function c99991068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991068.filter0,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99991068.activate(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c99991068.filter0,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99991068.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,cg:GetFirst(),e,tp)
	local tc=g:GetFirst()
	if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)  then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_CODE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetValue(cg:GetFirst():GetCode())
		e0:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(99991068,RESET_EVENT+0x1fe0000,0,1)
		if t>s and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and  Duel.SelectYesNo(tp,aux.Stringid(99991068,0)) then
		tc:ReplaceEffect(cg:GetFirst():GetOriginalCode(),RESET_EVENT+0x1fe0000)
		else
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4,true)
		end
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetCountLimit(1)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetLabelObject(tc)
		e5:SetCondition(c99991068.descon)
		e5:SetOperation(c99991068.desop)
		Duel.RegisterEffect(e5,tp)
		Duel.SpecialSummonComplete()
	end
end
function c99991068.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(99991068)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c99991068.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end