local pedname = "Sergeant E. Stone"

local GUIEditor = {
    label = {},
    edit = {},
    button = {},
    window = {},
    radiobutton = {},
    memo = {},
	gridlist = {}
}

function getShortTime(timestamp)
	local months = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" }
	local time = getRealTime(timestamp)
	local ts = nil
	ts = time.hour .. ":"..("%02d"):format(time.minute)
	ts =  months[time.month + 1] .. " ".. time.monthday .. ", " .. tostring(tonumber(time.year) + 1900) .. " " .. ts
	return ts
end

addEvent("showPayGUI", true)
addEventHandler("showPayGUI", getRootElement(), function(tickets)
	if GUIEditor.window[2] and isElement(GUIEditor.window[2]) then
		destroyElement(GUIEditor.window[2])
	else
        GUIEditor.window[2] = guiCreateWindow(501, 210, 637, 342, "Nesamaksātās biļetes", false)
		exports.global:centerWindow( GUIEditor.window[2] )
		guiWindowSetSizable(GUIEditor.window[2], false)

        GUIEditor.gridlist[1] = guiCreateGridList(10, 28, 617, 263, false, GUIEditor.window[2])
		guiGridListSetSortingEnabled(GUIEditor.gridlist[1], false)
        guiGridListAddColumn(GUIEditor.gridlist[1], "Izsniegšanas datums", 0.25)
        guiGridListAddColumn(GUIEditor.gridlist[1], "Pārkāpumi", 0.5)
        guiGridListAddColumn(GUIEditor.gridlist[1], "Sods", 0.22)
        GUIEditor.button[3] = guiCreateButton(10, 301, 111, 29, "Aizvērt", false, GUIEditor.window[2])
        GUIEditor.button[4] = guiCreateButton(518, 301, 109, 29, "Maksāt skaidrā", false, GUIEditor.window[2])
        GUIEditor.button[5] = guiCreateButton(399, 301, 109, 29, "Maksāt caur banku", false, GUIEditor.window[2])

		guiSetProperty(GUIEditor.button[4], "Disabled", "True")
		guiSetProperty(GUIEditor.button[5], "Disabled", "True")

		for i, v in ipairs(tickets) do
			guiGridListAddRow(GUIEditor.gridlist[1], getShortTime(tickets[i][4]), tickets[i][2], tickets[i][3]:sub(1, string.find(tickets[i][3], " ")))
		end

		addEventHandler("onClientGUIClick", GUIEditor.window[2], function()
			if source == GUIEditor.gridlist[1] then
				local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])+1
				if row > 0 then
					if getElementData(localPlayer, "money") >= tonumber(tickets[row][3]:sub(2, string.find(tickets[row][3], " "))) then
						guiSetProperty(GUIEditor.button[4], "Disabled", "False")
					else
						guiSetProperty(GUIEditor.button[4], "Disabled", "True")
					end
					if getElementData(localPlayer, "bankmoney") >= tonumber(tickets[row][3]:sub(2, string.find(tickets[row][3], " "))) then
						guiSetProperty(GUIEditor.button[5], "Disabled", "False")
					else
						guiSetProperty(GUIEditor.button[4], "Disabled", "True")
					end
				else
					guiSetProperty(GUIEditor.button[4], "Disabled", "True")
					guiSetProperty(GUIEditor.button[5], "Disabled", "True")
				end
			elseif source == GUIEditor.button[3] then
				destroyElement(GUIEditor.window[2])
			elseif source == GUIEditor.button[4] or source == GUIEditor.button[5] then
				local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])+1
				if row > 0 then
					local toPay = tonumber(tickets[row][3]:sub(2, string.find(tickets[row][3], " ")))
					if source == GUIEditor.button[4] then -- cash
						if toPay > getElementData(localPlayer, "money") then
							outputChatBox("Jums nepietiek skaidras naudas.", 255, 0, 0)
							return false
						end
						triggerServerEvent("chargePlayer", localPlayer, toPay, 1, tickets[row][1], getShortTime(tickets[row][4]))
						triggerServerEvent("sendAmeClient", localPlayer, "izņem $" .. exports.global:formatMoney(toPay) .. " no kabatas un pasniedz tās " .. name .. ".")
					else
						if toPay > getElementData(localPlayer, "bankmoney") then
							outputChatBox("Jums nepietiek naudas bankā", 255, 0, 0)
							return false
						end
						triggerServerEvent("chargePlayer", localPlayer, toPay, 2, tickets[row][1])
						triggerServerEvent("sendAmeClient", localPlayer, "izņem bankomāta karti un ieslidina to iekš bankomāta.")
					end
					guiGridListRemoveRow(GUIEditor.gridlist[1], row-1)
					destroyElement(GUIEditor.window[2])
				end
			end
		end)
	end
end)

addEvent("showTicketGUI", true)
addEventHandler("showTicketGUI", getRootElement(), function(vehicle)
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
		destroyElement(GUIEditor.window[1])
		showCursor(false)
		guiSetInputEnabled(false)
	else
		showCursor(true)
		guiSetInputEnabled(true)

		GUIEditor.window[1] = guiCreateWindow(1075, 186, 377, 332, "Biļešu grāmata", false)
		exports.global:centerWindow( GUIEditor.window[1] )
		guiWindowSetSizable(GUIEditor.window[1], false)

		GUIEditor.label[5] = guiCreateLabel(38, 30, 104, 15, "Biļete izsniegta:", false, GUIEditor.window[1])
        GUIEditor.radiobutton[1] = guiCreateRadioButton(233, 30, 83, 15, "Persona", false, GUIEditor.window[1])
        --[[ 1st ]] GUIEditor.edit[1] = guiCreateEdit(10, 79, 172, 24, "", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(15, 61, 143, 18, "Nummurs:", false, GUIEditor.window[1])
        GUIEditor.radiobutton[2] = guiCreateRadioButton(152, 30, 71, 15, "Auto", false, GUIEditor.window[1])
        GUIEditor.label[2] = guiCreateLabel(200, 61, 143, 18, "Soda apjoms:", false, GUIEditor.window[1])
        --[[ fine ]] GUIEditor.edit[2] = guiCreateEdit(195, 79, 172, 24, "", false, GUIEditor.window[1])
		GUIEditor.label[4] = guiCreateLabel(15, 113, 143, 18, "Datums un laiks:", false, GUIEditor.window[1])
        --[[ date ]] GUIEditor.edit[3] = guiCreateEdit(10, 131, 172, 24, getShortTime(getRealTime().timestamp), false, GUIEditor.window[1])
		guiSetProperty(GUIEditor.edit[3], "Disabled", "True")
        GUIEditor.label[4] = guiCreateLabel(15, 165, 143, 18, "Pārkāpumi:", false, GUIEditor.window[1])
        GUIEditor.memo[1] = guiCreateMemo(10, 183, 357, 86, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 288, 141, 31, "Atcelt", false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(227, 288, 140, 31, "Izsniegt", false, GUIEditor.window[1])
		guiRadioButtonSetSelected(GUIEditor.radiobutton[2], true)

		if vehicle then
			guiSetText(GUIEditor.edit[1], getElementData(vehicle, "plate"))
		end

		addEventHandler("onClientGUIClick", GUIEditor.window[1], function()
			if source == GUIEditor.radiobutton[1] then
				guiSetText(GUIEditor.label[1], "Vārds:")
			elseif source == GUIEditor.radiobutton[2] then
				guiSetText(GUIEditor.label[1], "Nummurs:")
			elseif source == GUIEditor.button[1] then
				destroyElement(GUIEditor.window[1])
				showCursor(false)
				guiSetInputEnabled(false)
			elseif source == GUIEditor.button[2] then
				if not tonumber(guiGetText(GUIEditor.edit[2])) then
					outputChatBox("Jūs neesat ierakstījis soda apjomu.", 255, 0, 0)
				elseif tonumber(guiGetText(GUIEditor.edit[2])) < 50 or tonumber(guiGetText(GUIEditor.edit[2])) > 10000 then
					outputChatBox("Jūs varat izsniegt sodu tikai starp $50 un $10'000", 255, 0, 0)
				elseif string.len(guiGetText(GUIEditor.memo[1])) > 100 then
					outputChatBox("Jūs esat pārsniedzis 100 rakstzīmju limitu pārkāpumiem.", 255, 0, 0)
				else
					local found = false
					if guiRadioButtonGetSelected(GUIEditor.radiobutton[1]) then
						for i, v in ipairs(getElementsByType("player")) do
							if getPlayerName(v) == guiGetText(GUIEditor.edit[1]) or getPlayerName(v):gsub("_", " ") == guiGetText(GUIEditor.edit[1]) then
								found = v
								break
							end
						end
						if not found then
							outputChatBox("Nevarēja atrast spēlētāju ar nosaukumu " .. guiGetText(GUIEditor.edit[1]) .. ".", 255, 0, 0)
							return false
						end
						triggerServerEvent("givePlayerTicket", localPlayer, found, tonumber(guiGetText(GUIEditor.edit[2])), guiGetText(GUIEditor.memo[1]), getShortTime(getRealTime().timestamp))
					else
						for i, v in ipairs(getElementsByType("vehicle")) do
							if getElementData(v, "plate") and string.upper(getElementData(v, "plate")) == string.upper(guiGetText(GUIEditor.edit[1])) then
								found = v
								break
							end
						end
						if not found then
							outputChatBox("Nevarēja atrast auto ar nummuru " .. guiGetText(GUIEditor.edit[1]) .. ".", 255, 0, 0)
							return false
						end
						if getElementData(found, "faction") > 0 or getElementData(found, "job") > 0 then
							outputChatBox("Tu nevari izsniegt biļeti frakcijas vai civilajam auto.", 255, 0, 0)
							return false
						end
						triggerServerEvent("giveVehicleTicket", localPlayer, found, string.upper(guiGetText(GUIEditor.edit[1])), guiGetText(GUIEditor.edit[2]), guiGetText(GUIEditor.memo[1]), getShortTime(getRealTime().timestamp))
					end
					destroyElement(GUIEditor.window[1])
					showCursor(false)
					guiSetInputEnabled(false)
				end
			end
		end)
	end
end)
