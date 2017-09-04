--镜世录 鼓动
function c29201049.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
	c:EnableReviveLimit()
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(29201049,3))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,29201049)
	e7:SetCondition(c29201049.pencon)
	e7:SetTarget(c29201049.pentg)
	e7:SetOperation(c29201049.penop)
	c:RegisterEffect(e7)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetTargetRange(1,0)
	e1:SetValue(c29201049.damval)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29201049,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c29201049.descon)
	e2:SetTarget(c29201049.ztg)
	e2:SetOperation(c29201049.zop2)
	c:RegisterEffect(e2)
	--[[
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c29201049.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)]]
end
function c29201049.damval(e,re,val,r,rp,rc)
	local atk=e:GetHandler():GetAttack()
	if val<=atk then return 0 else return val end
end
function c29201049.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c29201049.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial()
	e:GetLabelObject():SetLabel(ct)
end
function c29201049.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c29201049.zop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetHandler():GetMaterialCount()
	if ct<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft<=0 then return end
	local dis=Duel.SelectDisableField(tp,ct,0,LOCATION_MZONE+LOCATION_SZONE,0)
	e:SetLabel(dis)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c29201049.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabel(e:GetLabel())
	c:RegisterEffect(e1)
end
function c29201049.disop(e,tp)
	return e:GetLabel()
end
function c29201049.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201049.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201049.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
	end
end
