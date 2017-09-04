--嗫告篇帙 本条二亚
function c18706075.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xabb),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(aux.Stringid(18706075,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(18706075,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c18706075.sprcon)
	e2:SetOperation(c18706075.sprop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52687916,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c18706075.target)
	e3:SetOperation(c18706075.operation)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18706075,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c18706075.target2)
	e4:SetOperation(c18706075.operation2)
	c:RegisterEffect(e4)
end
function c18706075.sprfilter(c,tp)
	return  c:IsFaceup() and c:IsSetCard(0xabb) and c:IsReleasable()
		and c:GetLevel()==1
end
function c18706075.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c18706075.sprfilter,tp,LOCATION_MZONE,0,2,nil,tp)
end
function c18706075.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c18706075.sprfilter,tp,LOCATION_MZONE,0,2,2,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c18706075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c18706075.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g1)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g2)
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g3)
end
function c18706075.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.Hint(HINT_CARD,0,ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c18706075.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ac,c=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),e:GetHandler()
	c:SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c18706075.tgop)
	e1:SetCountLimit(1)
	e1:SetLabel(ac)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,18706074,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,18706075,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
end
function c18706075.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c18706075.filter,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,e:GetLabel()) and Duel.GetFlagEffect(tp,18706075)>0 and Duel.GetFlagEffect(tp,18706074)==0 then
	local g=Duel.GetMatchingGroup(c18706075.filter,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
	end
end
function c18706075.filter(c,code)
	return c:IsCode(code)
end