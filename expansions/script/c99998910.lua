--虹海的黄金剧场
function c99998910.initial_effect(c)
	  c:SetUniqueOnField(1,0,99998910)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c99998910.actcon)
	c:RegisterEffect(e1)  
	 --rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c99998910.descon)
	c:RegisterEffect(e2)
   --
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c99998910.reptg)
	e3:SetValue(c99998910.repval)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
end
function c99998910.actfilter(c)
	return c:IsFaceup() and c:IsCode(99998918) 
end
function c99998910.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998910.actfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99998910.descon(e)
	return not Duel.IsExistingMatchingCard(c99998910.actfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c99998910.repfilter(c)
	return c:IsLocation(LOCATION_MZONE) and (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_DECK or  c:GetDestination()==LOCATION_HAND or  c:GetDestination()==LOCATION_EXTRA or  c:GetDestination()==LOCATION_REMOVED )
end
function c99998910.repfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_DECK or  c:GetDestination()==LOCATION_HAND or  c:GetDestination()==LOCATION_EXTRA or  c:GetDestination()==LOCATION_REMOVED )
end
function c99998910.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local st1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local st2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if chk==0 then
		local count=eg:FilterCount(c99998910.repfilter,nil)
		return count>0 and (st1>0 or st2>0)
	end
		local  g1=eg:Filter(c99998910.repfilter2,nil,tp)
		local  g2=eg:Filter(c99998910.repfilter2,nil,1-tp)
if (st1>0 and g1:GetCount()>0) or (st2>0 and g2:GetCount()>0) then
	   local container=e:GetLabelObject()
		container:Clear()			  
		if st1>0 and g1:GetCount()>st1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			g1=eg:FilterSelect(tp,c99998910.repfilter2,1,st1,nil,tp)
		end 
		if st2>0 and g2:GetCount()>st2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
		   g2=eg:FilterSelect(1-tp,c99998910.repfilter2,1,st2,nil,1-tp)
		end
		if st1>0 and g1:GetCount()>0 then
		local tc=g1:GetFirst()
		while tc do
		Duel.MoveToField(tc,tp,tc:GetControler(),LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		tc=g1:GetNext()
end
end
  if st2>0 and g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
		Duel.MoveToField(tc,tp,tc:GetControler(),LOCATION_SZONE,POS_FACEUP,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fc0000)
		e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e2)
		tc=g2:GetNext()
end
end
	container:Merge(g1)
	container:Merge(g2)
	return true end
  return false 
end
function c99998910.repval(e,c)
	 return  e:GetLabelObject():IsContains(c)
end
