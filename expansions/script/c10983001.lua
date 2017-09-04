--幻怪 妖狐
function c10983001.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10983001.spcon)
	e2:SetOperation(c10983001.spop)
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10983001,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10983001.atcon)
	e3:SetOperation(c10983001.damop)
	c:RegisterEffect(e3)  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c10983001.con)
	e4:SetValue(c10983001.val)
	c:RegisterEffect(e4)
	--def down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCondition(c10983001.con)
	e5:SetValue(c10983001.val)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(c10983001.con)
	e6:SetTarget(c10983001.distg)
	c:RegisterEffect(e6)
end
function c10983001.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10983001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
	if sum<15 then return false end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and Duel.IsExistingMatchingCard(c10983001.spfilter,tp,LOCATION_MZONE,0,2,c)
end
function c10983001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c10983001.spfilter,tp,LOCATION_MZONE,0,2,2,c)	
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10983001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1355)
end
function c10983001.atcon(e,tp,eg,ep,ev,re,r,rp)
    local sum=0
    for i=0,4 do
        local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
        if tc and tc:IsFaceup() then
            if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
            else sum=sum+tc:GetLevel() end
        end
    end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsSetCard(0x355) and (sum>19 or Duel.IsExistingMatchingCard(c10983001.filter,tp,LOCATION_MZONE,0,1,nil))
			and a:IsRelateToBattle() and a:IsLocation(LOCATION_ONFIELD)
	elseif a:IsControler(tp) then
		e:SetLabelObject(d)
		return  a:IsSetCard(0x355) and (sum>19 or Duel.IsExistingMatchingCard(c10983001.filter,tp,LOCATION_MZONE,0,1,nil))
			and d:IsRelateToBattle() and d:IsLocation(LOCATION_ONFIELD)
	end
	return false
end
function c10983001.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1500,REASON_EFFECT)
end
function c10983001.val(e,c)
	if not c:IsSetCard(0x355) and c:IsType(TYPE_XYZ) then return c:GetRank()*-200
		else if not c:IsSetCard(0x355) then return c:GetLevel()*-200
		end
	end
end
function c10983001.distg(e,c)
	return c:IsAttackBelow(500) or c:IsDefenseBelow(500)
end
function c10983001.con(e,tp,eg,ep,ev,re,r,rp)
    local sum=0
    for i=0,4 do
        local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
        if tc and tc:IsFaceup() then
            if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
            else sum=sum+tc:GetLevel() end
        end
    end
return sum>34 or Duel.IsExistingMatchingCard(c10983001.filter,tp,LOCATION_MZONE,0,1,nil)
end