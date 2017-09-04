--镜世录 云入道
function c29201053.initial_effect(c)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(29201053,3))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c29201053.pencon)
	e7:SetTarget(c29201053.pentg)
	e7:SetOperation(c29201053.penop)
	c:RegisterEffect(e7)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29201053,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c29201053.tdcon)
	e3:SetTarget(c29201053.tdtg)
	e3:SetOperation(c29201053.tdop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29201053,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29201053)
	e1:SetTarget(c29201053.sptg)
	e1:SetOperation(c29201053.spop)
	c:RegisterEffect(e1)
end
function c29201053.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201053.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201053.penop(e,tp,eg,ep,ev,re,r,rp)
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
function c29201053.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c29201053.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c29201053.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29201053.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c29201053.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c29201053.spfilter(c)
	return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and not c:IsType(TYPE_PENDULUM) 
end
function c29201053.spfilter1(c,lv)
	return c:GetLevel()==lv
end
function c29201053.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c29201053.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
		local ct=Duel.Destroy(sg,REASON_EFFECT)
		if ct>0 then
		local mg=Duel.GetMatchingGroup(c29201053.spfilter,tp,LOCATION_DECK,0,nil)
		local tg=Group.CreateGroup()
		if mg:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
			--for i=1,ct do
			repeat
				local sg=mg:Select(tp,1,1,nil):GetFirst()
				mg:Remove(c29201053.spfilter1,nil,sg:GetLevel())
				tg:AddCard(sg)
				ct=ct-1
				ft=ft-1
			until ft<=0 or ct<=0 or not Duel.SelectYesNo(tp,aux.Stringid(29201053,1))
			--end
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
	end
end
function c29201053.filter3(c)
	return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c29201053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29201053.filter3,tp,LOCATION_HAND,0,1,e:GetHandler()) 
		and Duel.IsPlayerCanDraw(tp,2) and e:GetHandler():IsDiscardable() end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,e:GetHandler(),0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c29201053.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c29201053.filter3,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

