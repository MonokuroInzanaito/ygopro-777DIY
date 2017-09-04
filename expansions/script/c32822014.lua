--海象人图腾师
local m=32822014
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)   
	local e1=nil
	--cannot be material
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(function(e,c)
		if not c then return false end
		return not c:IsRace(RACE_PLANT) and not c:IsAttribute(ATTRIBUTE_EARTH)
	end)
	c:RegisterEffect(e1)
	local codes={EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_FUSION_MATERIAL}
	orion.cloneExceptCodes(c,e1,codes)
	--special summon
	--e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetCode(EFFECT_SPSUMMON_PROC)
	--e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e1:SetRange(LOCATION_HAND)
	--e1:SetCondition(orion.conditionNoMonsterSelf)
	--c:RegisterEffect(e1)
	--search & summon
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(orion.costDiscardOneCard)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(orion.totemSearchMonsterFilter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,orion.totemSearchMonsterFilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			if not Duel.IsExistingMatchingCard(orion.totemSummonFilter,tp,LOCATION_HAND,0,1,nil) then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,orion.totemSummonFilter,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				local s1=tc:IsSummonable(true,nil)
				local s2=tc:IsMSetable(true,nil)
				if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
					Duel.Summon(tp,tc,true,nil)
				else
					Duel.MSet(tp,tc,true,nil)
				end
			end
		end
	end)
	c:RegisterEffect(e1)
	e1=e1:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--return deck
	--e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,2))
	--e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetRange(LOCATION_GRAVE)
	--e1:SetCountLimit(1,32822101)
	--e1:SetCost(orion.costRemoveItself)
	--e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		--if chk==0 then return Duel.IsExistingMatchingCard(orion.totemFaceupFilter,tp,LOCATION_REMOVED,0,1,nil) end
		--Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
		--Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	--end)
	--e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		--local g=Duel.SelectMatchingCard(tp,orion.totemFaceupFilter,tp,LOCATION_REMOVED,0,1,3,nil)
		--if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			--Duel.BreakEffect()
			--Duel.Draw(tp,1,REASON_EFFECT)
		--end
	--end)
	--c:RegisterEffect(e1)
end