--凋叶棕-书本的旅人
function c29200129.initial_effect(c)
	--[[counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200129,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+29200001)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,29200129)
	e2:SetTarget(c29200129.sptg)
	e2:SetOperation(c29200129.spop)
	c:RegisterEffect(e2)]]
	--Activate
	local ed=Effect.CreateEffect(c)
	ed:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	ed:SetType(EFFECT_TYPE_ACTIVATE)
	ed:SetCode(EVENT_DESTROYED)
	ed:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	ed:SetCondition(c29200129.condition)
	ed:SetTarget(c29200129.target)
	ed:SetOperation(c29200129.operation)
	c:RegisterEffect(ed)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200129,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,29200129)
    e3:SetCost(c29200129.spcost)
    e3:SetTarget(c29200129.sptg)
    e3:SetOperation(c29200129.spop)
    c:RegisterEffect(e3)
end
function c29200129.cfilter8(c,tp)
	return c:IsSetCard(0x53e0) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c29200129.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29200129.cfilter8,1,nil,tp)
end
function c29200129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29200108,0x53e0,0x4011,0,1800,2,RACE_SPELLCASTER,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c29200129.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29200108,0x53e0,0x4011,0,1800,2,RACE_SPELLCASTER,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,29200108)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function c29200129.cfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c29200129.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200129.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
        and e:GetHandler():GetFlagEffect(29200129)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c29200129.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:GetHandler():RegisterFlagEffect(29200129,RESET_CHAIN,0,1)
end
function c29200129.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29200129,0x53e0,0x11,4,0,1800,RACE_SPELLCASTER,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29200129.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,29200129,0x53e0,0x11,2,0,1800,RACE_SPELLCASTER,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_EARTH,RACE_SPELLCASTER,2,0,1800)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		--redirect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
		local e10=Effect.CreateEffect(e:GetHandler())
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_SET_BASE_ATTACK)
		e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e10:SetValue(0)
		--e10:SetReset(RESET_EVENT+0x1fe0000)
		e10:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e10)
		local e12=e10:Clone()
		e12:SetCode(EFFECT_SET_BASE_DEFENSE)
		e12:SetValue(1800)
		c:RegisterEffect(e12)
		local e3=e10:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(2)
		c:RegisterEffect(e3)
		local e4=e10:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(RACE_SPELLCASTER)
		c:RegisterEffect(e4)
		local e5=e10:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(ATTRIBUTE_EARTH)
		c:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_TYPE)
		e6:SetValue(0x11)
		c:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
	end
end


