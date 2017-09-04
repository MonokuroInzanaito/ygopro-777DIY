--虚拟歌姬的舞台
function c1300300.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot release and annot be material
	local list={
		[EFFECT_UNRELEASABLE_NONSUM]=1,
		[EFFECT_UNRELEASABLE_SUM]=1,
		[EFFECT_CANNOT_BE_SYNCHRO_MATERIAL]=1,
		[EFFECT_CANNOT_BE_FUSION_MATERIAL]=1,
		[EFFECT_CANNOT_BE_XYZ_MATERIAL]=1,
		[EFFECT_CANNOT_BE_EFFECT_TARGET]=aux.tgoval,
		[EFFECT_CANNOT_BE_BATTLE_TARGET]=aux.imval1,
	}
	for code,val in pairs(list) do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(code)
		e2:SetRange(LOCATION_FZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c1300300.indtg)
		e2:SetValue(val)
		c:RegisterEffect(e2)
	end
	--once per turn indes
	--indes
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1300300.indtg)
	e2:SetValue(c1300300.indct)
	c:RegisterEffect(e2)]]
	--atk & def up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if e:GetHandler():GetFlagEffect(1300300)>0 then return false end
			local a=Duel.GetAttacker()
			local d=Duel.GetAttackTarget()
			if not d then return false end
			if a:IsSetCard(0x130) and a:IsControler(tp) then return true end
			if d:IsSetCard(0x130) and d:IsControler(tp) then return true end
			return false
		end
		e:GetHandler():RegisterFlagEffect(1300300,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	end)
	e3:SetOperation(c1300300.adup)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(0x14000)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(r,REASON_EFFECT)==REASON_EFFECT
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ex=Effect.CreateEffect(e:GetHandler())
		ex:SetType(EFFECT_TYPE_FIELD)
		ex:SetCode(EFFECT_UPDATE_ATTACK)
		ex:SetTargetRange(LOCATION_MZONE,0)
		ex:SetTarget(function(e,c)
			return c:IsFaceup() and c:IsSetCard(0x130) and Duel.GetAttacker()==c
		end)
		ex:SetCondition(function() return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL end)
		ex:SetReset(RESET_PHASE+PHASE_END)
		ex:SetValue(1300)
		Duel.RegisterEffect(ex,tp)
		local ex1=ex:Clone()
		ex1:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(ex1,tp)
	end)
	c:RegisterEffect(e3)
end
function c1300300.indtg(e,c)
	return c:IsSetCard(0x130) and c:IsFaceup()
end
function c1300300.adup(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetAttacker()
	local dc=Duel.GetAttackTarget()
	if not dc then return end
		if ac:IsSetCard(0x130) and ac:IsControler(tp) then
			local a,d=ac:GetAttack(),ac:GetDefense()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(a)
			ac:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(d)
			ac:RegisterEffect(e2)
		end
		if dc:IsSetCard(0x130) and dc:IsControler(tp) then
			local a,d=dc:GetAttack(),ac:GetDefense()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(a)
			dc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(d)
			dc:RegisterEffect(e2)
		end  
end
