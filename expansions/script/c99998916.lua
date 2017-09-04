--传说之暗杀者 尼托克莉丝
function c99998916.initial_effect(c)
	--special summon (hand/grave)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,99998916)
	e1:SetTarget(c99998916.sptg)
	e1:SetOperation(c99998916.spop)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998916,0))
	e2:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_POSITION+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)   
	e2:SetTarget(c99998916.deftg)
	e2:SetOperation(c99998916.defop)
	c:RegisterEffect(e2)
  --cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTarget(c99998916.tg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(c99998916.tglimit)
	e5:SetTarget(c99998916.tg)
	c:RegisterEffect(e5)
end
function c99998916.filter(c,g,tp,m1,m2,ft)
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,g,g)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,g:GetLevel(),g)
	else
		return ft>-1 and mg:IsExists(c99998916.mfilterf,1,nil,tp,mg,g)
	end
end
function c99998916.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c99998916.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99998916.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then  
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c99998916.mfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return c99998916.filter(c,e:GetHandler(),tp,mg1,mg2,ft)
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99998916.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c99998916.mfilter,tp,LOCATION_GRAVE,0,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
		mg:Merge(mg2)
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c99998916.mfilterf,1,1,nil,tp,mg,c)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
				mat:Merge(mat2)
			end
			c:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
end
function c99998916.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c99998916.defop(e,tp,eg,ep,ev,re,r,rp)
   local cg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	 if sg:GetCount()>0 and Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 
	 then
	 local sg2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	 if sg2:GetCount()>0 and cg:GetCount()>0 then 
	local tg=sg2:GetFirst()
	while tg do
	  local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-cg:GetCount()*300)
			tg:RegisterEffect(e1)
			tg=sg2:GetNext()
		end
	  local sg3=Duel.GetMatchingGroup(c99998916.tdfilter,tp,0,LOCATION_MZONE,nil)
	if sg3:GetCount()>0 then
	Duel.SendtoDeck(sg3,nil,2,REASON_EFFECT)
end
end
end
end
function c99998916.tdfilter(c)
	return  c:IsAbleToDeck() and c:GetDefense()==0
end
function c99998916.tg(e,c)
	return  c:GetCode()~=99998916
end
function c99998916.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end