--狼与赤的终始
function c400006.initial_effect(c)
   function c400006.initial_effect(c)
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
   e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
   e1:SetRange(LOCATION_EXTRA)
--   e1:SetCost(c400006.cost1)
   e1:SetCondition(c400006.con1)
--   e1:SetTarget(c400006.tg1)
   e1:SetOperation(c400006.op1)
end
--function c400006.cost1(c,e,tp)
--	Duel.ConfirmCards(1-tp,e:GetHandler())
--end
function c400006.con1()
	return Duel.GetTurnCount()==1
end
--function c400006.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
--	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
--		Duel.SetChainLimit(aux.FALSE)
--	end
--end
function c400006.op1(e,tp,eg,ep,ev,re,r,rp)
	local token1=Duel.CreateToken(tp,400002)
	Duel.MoveToField(token1,tp,tp,LOCATION_EXTRA,POS_FACEDOWN,true)
	local token2=Duel.CreateToken(tp,400003)
	Duel.MoveToField(token1,tp,tp,LOCATION_EXTRA,POS_FACEDOWN,true)
	local token3=Duel.CreateToken(tp,400004)
	Duel.MoveToField(token1,tp,tp,LOCATION_EXTRA,POS_FACEDOWN,true)
	local token4=Duel.CreateToken(tp,400005)
	Duel.MoveToField(token1,tp,tp,LOCATION_EXTRA,POS_FACEDOWN,true)
	end
end
