KB_premadeShowKeystone = true

KeyStoneCheckButton = CreateFrame("CheckButton", nil, LFGListFrame.ApplicationViewer.RefreshButton, "UICheckButtonTemplate")
KeyStoneCheckButton:SetPoint("RIGHT", LFGListFrame.ApplicationViewer.RefreshButton, "LEFT", 0, 0)
KeyStoneCheckButton:SetSize(38, 40)
KeyStoneCheckButton:SetChecked(true)

KeyStoneCheckButtonText = KeyStoneCheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
KeyStoneCheckButtonText:SetPoint("RIGHT", KeyStoneCheckButton, "LEFT", 0, 0)
KeyStoneCheckButtonText:SetText("Show keys")



KeystoneHeaderButton = CreateFrame("Button", nil, LFGListFrame.ApplicationViewer.ItemLevelColumnHeader, "LFGListColumnHeaderTemplate")
KeystoneHeaderButton:SetSize(120,24)
KeystoneHeaderButton:SetPoint("LEFT", LFGListFrame.ApplicationViewer.ItemLevelColumnHeader, "RIGHT")
KeystoneHeaderButton:SetText("Keystone")
KeystoneHeaderButton:Hide()

local applicantSpace = { LFGListApplicationViewerScrollFrameScrollChild:GetChildren() }
for _, child in ipairs(applicantSpace) do
	--child:SetWidth(470)
	KeystoneLabel  = child.Member1:CreateFontString(nil, "ARTWORK", "KeystoneLabelSmall")
	KeystoneLabel:SetPoint("LEFT", child.Member1, "LEFT", 200, 0)
	KeystoneLabel:SetParent(child.Member1)
	KeystoneLabel:SetText("No keystone whisper")
	KeystoneLabel:Hide()
end
	
function KB_DeleteData()
		KB_applicants = {}
		KB_applicants[0] = {}
		
		local applicantSpace = { LFGListApplicationViewerScrollFrameScrollChild:GetChildren() }
		for _, child in ipairs(applicantSpace) do
			--child:SetWidth(470)
			KeystoneLabel  = child.Member1.KeystoneLabel
			KeystoneLabel:SetPoint("LEFT", child.Member1, "LEFT", 200, 0)
			KeystoneLabel:SetParent(child.Member1)
			KeystoneLabel:SetText("No keystone whisper")
		end	
end
	
--PVEFrame:SetWidth(720)
--LFGListPVEStub:SetWidth(496)
--LFGListApplicationViewerScrollFrameScrollChild:SetWidth(450)
--LFGListApplicationViewerScrollFrameButton3:SetWidth(450)
function KB_premadeUpdate()
	premadeLocal = {}
	local kids = { LFGListApplicationViewerScrollFrameScrollChild:GetChildren() };
	for _, child in ipairs(kids) do
		local foundKeystone = false
		local applicantName = child.Member1.Name:GetText()
		if applicantName ~= "Name" then
			for applicant = 1, #KB_applicants do
				local applicantNameKQ = {strsplit('-', KB_applicants[applicant][2])}
				if tostring(applicantName) == tostring(applicantNameKQ[1]) then
					if KB_applicants[applicant][3] == true then
						child.Member1.KeystoneLabel:SetTextColor(0.5,0.5,0.5,1)
						child.Member1.KeystoneLabel:SetText("+"..tostring(KB_applicants[applicant][1]) .. " " .. tostring(KB_applicants[applicant][0]) .. " (d)")
					else
						child.Member1.KeystoneLabel:SetTextColor(1,0.82,0,1)
						child.Member1.KeystoneLabel:SetText("+"..tostring(KB_applicants[applicant][1]) .. " " .. tostring(KB_applicants[applicant][0]))
					end
					foundKeystone = true
				end
			end
		end
		if foundKeystone == false then
			child.Member1.KeystoneLabel:SetText("No keystone whisper")
		end
	end
	
	
end


function KB_UpdatePremade(wide) 
	if wide == true then
		KeystoneHeaderButton:Show()
		KeystoneHeaderButton:SetSize(120,24)
		PVEFrame:SetWidth(720)
		LFGListPVEStub:SetWidth(496)
		local applicantSpace = { LFGListApplicationViewerScrollFrameScrollChild:GetChildren() }
		for _, child in ipairs(applicantSpace) do
			child:SetWidth(470)
			KeystoneLabel  = child.Member1.KeystoneLabel
			KeystoneLabel:Show()

		end
	else
		KeystoneHeaderButton:Hide()
		KeystoneHeaderButton:SetSize(120,24)
		PVEFrame:SetWidth(563)
		LFGListPVEStub:SetWidth(338)
		local applicantSpace = { LFGListApplicationViewerScrollFrameScrollChild:GetChildren() }
		for _, child in ipairs(applicantSpace) do
			child:SetWidth(309)
			KeystoneLabel  = child.Member1.KeystoneLabel
			KeystoneLabel:Hide()

		end
	end
end


KeyStoneCheckButton:SetScript("OnShow", function()
	KeyStoneCheckButton:SetChecked(KB_premadeShowKeystone)
	if KB_premadeShowKeystone == true then
		KB_UpdatePremade(true)
		KB_premadeUpdate()
	else
		KB_UpdatePremade(false)
	end
end)
KeyStoneCheckButton:SetScript("OnHide", function()
	KB_UpdatePremade(false)
	local kids = { LFGListApplicationViewerScrollFrameScrollChild:GetChildren() };
	for _, child in ipairs(kids) do
		child.Member1.KeystoneLabel:SetText("No keystone whisper")
	end
end)
KeyStoneCheckButton:SetScript("OnClick", function()
	KB_premadeShowKeystone = not KB_premadeShowKeystone
	if KB_premadeShowKeystone == true then
		KB_UpdatePremade(true)
	else
		KB_UpdatePremade(false)
	end
end)

local function eventHandler(self, event, prefix, msg, channel, sender, presenceID)
	if event == 'GROUP_ROSTER_UPDATE' and GetNumGroupMembers() >= 5 then
		KB_DeleteData()
	end
end

KeyStoneCheckButton:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED')
KeyStoneCheckButton:SetScript('OnEvent', eventHandler)
