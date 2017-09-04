--Cofe De Lapin
function c400016.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(400016,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,400016)
	e1:SetCost(c400016.cost)
	e1:SetTarget(c400016.target)
	e1:SetOperation(c400016.operation)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(400016,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c400016.lvcost)
	e2:SetOperation(c400016.lvop)
	c:RegisterEffect(e2)
end
function c400016.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c400016.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c400016.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c400016.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
end
function c400016.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel())
		c:RegisterEffect(e1)
	end
end
function c400016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c400016.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(400015,3))
	local tc=Duel.SelectMatchingCard(tp,c400016.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_EXTRA) then
	   Duel.SendtoGrave(tc,REASON_COST)
	else
	   Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
	e:SetLabelObject(tc)
end
function c400016.cfilter2(c)
	return (c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()) or (c:IsFaceup() and c:IsAbleToGraveAsCost())
end
function c400016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_ONFIELD) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c400016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetLabelObject()
	local race,att,lv=tc:GetOriginalRace(),tc:GetOriginalAttribute(),tc:GetOriginalLevel()
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT) and not tc:IsType(TYPE_XYZ) then
	   local g=Duel.GetMatchingGroup(c400016.thfilter,tp,LOCATION_DECK,0,nil,race,att,lv)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(400016,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=g:Select(tp,1,1,nil)
		  Duel.SendtoHand(sg,nil,REASON_EFFECT)
	   end
	end
end
function c400016.thfilter(c,race,att,lv)
	return c:GetOriginalRace()==race and c:GetOriginalAttribute()==att and c:GetOriginalLevel()<=lv and c:IsAbleToHand()
end