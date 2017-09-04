--无名的集结
function c11113037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c11113037.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113037,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11113037)
	e3:SetTarget(c11113037.mvtg)
	e3:SetOperation(c11113037.mvop)
	c:RegisterEffect(e3)
end
function c11113037.tgtg(e,c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x15c)
end
function c11113037.mvfilter1(c,tp)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x15c) and c:IsAbleToRemove() 
		and Duel.IsExistingMatchingCard(c11113037.mvfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c11113037.mvfilter2(c,code)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x15c) and not c:IsCode(code)
end
function c11113037.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c11113037.mvfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c11113037.mvfilter1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11113037.mvfilter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c11113037.mvop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
	    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11113037,1))
		local g=Duel.SelectMatchingCard(tp,c11113037.mvfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		local tg=g:GetFirst()
		if tg then
			Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end