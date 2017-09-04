--广鸟射怪鸟事
local m=14140013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and e:GetHandler():IsCanBeFusionMaterial(c)
end
function cm.mfilter(c,exg,ec)
	return c:IsFaceup() and exg:IsExists(cm.chkfilter,1,nil,c,ec)
end
function cm.chkfilter(c,tc,ec)
	local mg=Group.FromCards(tc,ec)
	return ec:IsCanBeFusionMaterial(c) and c:CheckFusionMaterial(mg,tc) and c:CheckFusionMaterial(mg,ec)
end
function cm.chkcfilter(c,mg1,mg2)
	local mg=Group.FromCards(c,ec)
	return c:CheckFusionMaterial(mg1,nil) and c:CheckFusionMaterial(mg2,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chkc then
		local mg1=Group.FromCards(e:GetLabelObject(),e:GetHandler())
		local mg2=Group.FromCards(chkc,e:GetHandler())
		return exg:IsExists(cm.chkcfilter,1,nil,mg1,mg2)
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_MZONE,0,1,nil,exg,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectTarget(tp,cm.mfilter,tp,LOCATION_MZONE,0,1,1,nil,exg,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabelObject(g:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or c:IsImmuneToEffect(e) then return end
	local exg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp):Filter(cm.chkfilter,nil,c,tc)
	if exg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=exg:Select(tp,1,1,nil):GetFirst()
	local mg=Group.FromCards(c,tc)
	sc:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT)
	Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end