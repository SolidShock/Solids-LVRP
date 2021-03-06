local plantDrug = {
    [1] = function(thePlayer, x,y,z, drugTypeID) 
    	local drugInformation = drugInfo[drugTypeID]
    	local drugObject = createObject(drugInformation[2], x, y, z, 0, 0, 0, false)
		setObjectScale(drugObject, drugInformation[10][1][1], drugInformation[10][1][2], drugInformation[10][1][3])
		setElementData(drugObject, "soliddrugs:ownername", getPlayerName(thePlayer))
		setElementData(drugObject, "soliddrugs:growthstage", 1)
		setElementData(drugObject, "soliddrugs:humidity", drugInformation[5])
		setElementData(drugObject, "soliddrugs:readytoharvest", false)
		exports.global:takeItem(thePlayer, drugInformation[1], 1)
		setTimer(updateDrug, drugInformation[7], 1, drugObject, drugTypeID)
    end,
    [2] = function(thePlayer, x,y,z, drugTypeID)
    	local drugInformation = drugInfo[drugTypeID]
    	local drugObject = createObject(drugInformation[2], x, y, z+1, 0, 0, 0, false)
		setObjectScale(drugObject, drugInformation[10][1][1], drugInformation[10][1][2], drugInformation[10][1][3])
		setElementData(drugObject, "soliddrugs:ownername", getPlayerName(thePlayer))
		setElementData(drugObject, "soliddrugs:growthstage", 1)
		setElementData(drugObject, "soliddrugs:humidity", drugInformation[5])
		setElementData(drugObject, "soliddrugs:readytoharvest", false)
		exports.global:takeItem(thePlayer, drugInformation[1], 1)
		setTimer(updateDrug, drugInformation[7], 1, drugObject, drugTypeID)
	end,
	[3] = function(thePlayer, x,y,z, drugTypeID)
    	local drugInformation = drugInfo[drugTypeID]
    	local drugObject = createObject(drugInformation[2], x, y, z+0.1, 0, 0, 0, false)
		setObjectScale(drugObject, drugInformation[10][1][1], drugInformation[10][1][2], drugInformation[10][1][3])
		setElementData(drugObject, "soliddrugs:ownername", getPlayerName(thePlayer))
		setElementData(drugObject, "soliddrugs:growthstage", 1)
		setElementData(drugObject, "soliddrugs:humidity", drugInformation[5])
		setElementData(drugObject, "soliddrugs:readytoharvest", false)
		exports.global:takeItem(thePlayer, drugInformation[1], 1)
		setTimer(updateDrug, drugInformation[7], 1, drugObject, drugTypeID)
	end,
}

local function playerWeedChecks(playerSource, commandname, drugType)
	if drugType then
		if not isPedInVehicle(playerSource) then
			if isPedOnGround(playerSource) then
				if not isPedDead(playerSource) then
					if isPedDucked(playerSource) then
						local drugType = drugTypes[drugType]
						if drugType then
							if exports.global:hasItem(playerSource, drugInfo[drugType][1], 1) then
								triggerClientEvent(playerSource, "checkPlantingLocation", playerSource, drugType)
							else
								outputChatBox("Tev nav nepiecie??amais, lai uzs??ktu audz????anu!",playerSource)
							end
						end
					else
						outputChatBox("Vispirms pietupies, lai iest??d??tu narkotikas!", playerSource)
					end
				else
					outputChatBox("Tu nevari iest??d??t narkotikas, ja esi miris!", playerSource)
				end
			else
				outputChatBox("Tu nevari iest??d??t narkotikas, ja neatrodies uz zemes!", playerSource)
			end
		else
			outputChatBox("Tu nevari iest??d??t narkotikas, ja atrodies ma????n??!", playerSource)
		end
	else
		outputChatBox("Neder??gs narkotiku tips komand??! /plant (weed/coca/poppy)",playerSource)
		-- TODO izvad??t visus narku veidus
	end
end
addCommandHandler("plant", playerWeedChecks, false, true)

function testDistanceToNearestPlant(x, y, z, drugTypeID)
	local testObject = createPickup(x,y,z,3, 1276)
	local nearestObject = getNearestObject(testObject, minDistanceBetweenPlants)
	if not nearestObject then
		destroyElement(testObject)
		plantDrug[drugTypeID](client, x,y,z, drugTypeID)
	elseif getElementModel(nearestObject) == drugInfo[drugTypeID][2] then
		destroyElement(testObject)
		outputChatBox("Tu nevari iest??d??t jaunu narkotiku tik tuvu jau eso??ai narkotikai!", client)
	else
		destroyElement(testObject)
		plantDrug[drugTypeID](client, x,y,z, drugTypeID)
	end
end
addEvent("testDistanceToNearestPlant", true)
addEventHandler("testDistanceToNearestPlant", root, testDistanceToNearestPlant)

local function testDrug(playerSource, commandname, drugType)
	if drugType then
		if drugTypes[drugType] then
			if exports.integration:isPlayerAdmin(playerSource) or exports.integration:isPlayerScripter(playerSource) then
				local drugTypeID = drugTypes[drugType]
				local nearestElement = getNearestObject(playerSource, 10)
				local nearestElementModel = getElementModel(nearestElement)
				if nearestElementModel == drugInfo[drugTypeID][2] then
					local data = getAllElementData (nearestElement)
					for k, v in pairs (data) do
					    outputChatBox(k..": "..tostring(v), playerSource)
					end
				end
			else
				outputChatBox("Tev ir j??b??t vai nu administr??toram vai ar?? skripterim, lai pielietotu ??o komandu!")
			end
		else
			outputChatBox("T??da tipa narkotikas tuvum?? nav!", playerSource)
			--TODO output all types of drugs
		end
	else
		outputChatBox("J??s nenor??dij??t narkotiku tipu!", playerSource)
		--TODO output all types of drugs
	end
end
addCommandHandler("testdrug", testDrug, false, true)