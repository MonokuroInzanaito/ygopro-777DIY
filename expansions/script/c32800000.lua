--orion qq:455168247
orion=orion or {}
local cm=orion
function cm.isLeftFaceup(e)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.isSummonAdvance(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function cm.isSummonNormal(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function cm.isOpponentReleasable(c,ft)
	return c:IsReleasable() and (ft>0 or c:GetSequence()<5)
end
function cm.isSummonPlayer(c,sp)
	return c:GetSummonPlayer()==sp
end
function cm.filterTf(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function cm.cloneExceptCodes(c,e1,codes)
	for index,code in pairs(codes) do
		e1=Effect.Clone(e1)
		e1:SetCode(code)
		c:RegisterEffect(e1)
	end
end
function cm.registerSummonIndestructable(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(cm.isSummonNormal)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cm.registerSummonReflectDamage(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetCondition(cm.isSummonNormal)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cm.conditionSummonAdvance(e,tp,eg,ep,ev,re,r,rp)
	return cm.isSummonAdvance(e)
end
function cm.costDiscardOneCard(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.costRemoveItself(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.targetDestroyAnotherCard(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c~=chkc end
	if chk==0 then return  Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.targetSummonTribute(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if lv<5 then return end
	local ct=1
	if lv>6 then ct=2 end
	if chk==0 then return Duel.CheckTribute(c,ct) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.operationDestroy(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.operationDestroyBothSync(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function cm.operationSummonAdvance(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if not c:IsRelateToEffect(e) then return end
	if lv<5 then return end
	local ct=1
	if lv>6 then ct=2 end
	if not Duel.CheckTribute(c,ct) or not c:IsSummonable(true,e) then return end
	local g=Duel.SelectTribute(tp,c,ct,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_CHAIN)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetCondition(aux.TRUE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end)
	c:RegisterEffect(e1,true)
	Duel.Summon(tp,c,true,nil)
end
function cm.conditionNoMonsterSelf(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.conditionOpponentRelease(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.isOpponentReleasable,tp,0,LOCATION_MZONE,1,nil,ft)
end
function cm.operationOpponentRelease(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.isOpponentReleasable,tp,0,LOCATION_MZONE,1,1,nil,ft)
	Duel.Release(g,REASON_COST)
end
function cm.valueNotItself(e,c)
	return c~=e:GetHandler()
end
function cm.valueNotImmune(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.valueQliImmuneAdvance(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler():GetControler()~=te:GetHandler():GetControler() then return true
	else return aux.qlifilter(e,te) end
end