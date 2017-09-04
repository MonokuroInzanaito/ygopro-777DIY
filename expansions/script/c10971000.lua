--灵龙埋骨乡
function c10971000.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(10971000)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1) 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10971000,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c10971000.drcon)
	e3:SetTarget(c10971000.sumtg)
	e3:SetOperation(c10971000.sumop)
	c:RegisterEffect(e3)   
end
function c10971000.cfilter(c,tp)
	return c:IsSetCard(0x234) and c:IsType(TYPE_MONSTER)
end
function c10971000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10971000.cfilter,1,nil,tp)
end
function c10971000.filter(c)
	return c:IsSetCard(0x234) and c:IsSummonable(true,nil)
end
function c10971000.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971000.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10971000.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10971000.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
