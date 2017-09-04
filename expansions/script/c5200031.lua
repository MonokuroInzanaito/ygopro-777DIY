--Days·桂言叶
function c5200031.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5200031,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,5200031)
	e1:SetCondition(c5200031.hdcon)
	e1:SetTarget(c5200031.hdtg)
	e1:SetOperation(c5200031.hdop)
	c:RegisterEffect(e1)
	--handes2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5200031,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCountLimit(1,5200031)
	e2:SetCondition(c5200031.hdcon2)
	e2:SetTarget(c5200031.hdtg)
	e2:SetOperation(c5200031.hdop)
	c:RegisterEffect(e2)
end
function c5200031.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x361) and c:GetCode()~=5200031
end
function c5200031.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5200031.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c5200031.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c5200031.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c5200031.hdcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
