--凋叶棕-被弃置的小伞怨节
function c29200110.initial_effect(c)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29200110,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(0x0081)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,29200110)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c29200110.target)
	e1:SetOperation(c29200110.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200110,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(0x0081)
	e2:SetCode(29200000)
	e2:SetProperty(0x14000)
	e2:SetTarget(c29200110.tdtg)
	e2:SetOperation(c29200110.tdop)
	c:RegisterEffect(e2)
end
function c29200110.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29200110.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c29200110.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) end
end
function c29200110.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x53e0)
end
function c29200110.operation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,4) then return end
    Duel.ConfirmDecktop(tp,4)
    local g=Duel.GetDecktopGroup(tp,4)
	if g:GetCount()>0 then
		local sg=g:Filter(c29200110.filter,nil)
        if sg:GetCount()>0 then
            Duel.DisableShuffleCheck()
            Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
        end
        Duel.SortDecktop(tp,tp,4-sg:GetCount())
        for i=1,4-sg:GetCount() do
            local mg=Duel.GetDecktopGroup(tp,1)
            Duel.MoveSequence(mg:GetFirst(),1)
		    Duel.RaiseSingleEvent(mg:GetFirst(),29200000,e,0,0,0,0)
		    Duel.RaiseEvent(mg:GetFirst(),EVENT_CUSTOM+29200001,e,0,tp,0,0)
		end
	end
end
