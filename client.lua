vRP = Proxy.getInterface("vRP")

local text = nil

local banks = {
	["fleeca"] = {
		position = { ['x'] = 147.04908752441, ['y'] = -1044.9448242188, ['z'] = 29.36802482605 },
		reward = 10000 + math.random(100000,200000),
		nameofbank = "Fleeca Bank",
		lastrobbed = 0
	},
	["fleeca2"] = {
		position = { ['x'] = -2957.6674804688, ['y'] = 481.45776367188, ['z'] = 15.697026252747 },
		reward = 10000 + math.random(100000,200000),
		nameofbank = "Fleeca Bank (Highway)",
		lastrobbed = 0
	},
	["blainecounty"] = {
		position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
		reward = 10000 + math.random(100000,200000),
		nameofbank = "Blaine County Savings",
		lastrobbed = 0
	},
	["pacific"] = {
		position = { ['x'] = 255.001098632813, ['y'] = 225.855895996094, ['z'] = 101.005694274902 },
		reward = 60000 + math.random(100000,200000),
		nameofbank = "Pacific Standard PDB (Downtown Vinewood)",
		lastrobbed = 0
	}
}

local stop = false
incircle = false

RegisterNetEvent('stop_camera')
AddEventHandler('stop_camera',function()
    local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    DoScreenFadeIn(800) --- Fade In Showing the Screen
    FreezeEntityPosition(playerPed, false) -- unfreeze
    DestroyCam(createdCamera, 0)
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
end)

RegisterNetEvent('spawn_veh')
AddEventHandler('spawn_veh',function()
	Citizen.Wait(500)
	local vehicle = "Kuruma2"
	RequestModel(vehicle)
	if HasModelLoaded(vehicle) then
		nveh = CreateVehicle("Kuruma2", 2673.18359375,3517.1870117188,52.339908599854, 100.0, false, false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh, "BRE GVNG")
		SetModelAsNoLongerNeeded(vehicle)
	end
end)

RegisterNetEvent('spawn_lester')
AddEventHandler('spawn_lester',function(target)
	RequestModel( "cs_lestercrest" )
	while ( not HasModelLoaded( "cs_lestercrest" ) ) do
		Citizen.Wait( 1 )
	end

	local lester_ped2 = CreatePed(4, "cs_lestercrest",1275.9381103516,-1713.6461181641,54.771446228027-0.9, 270.0,false,false)
	SetEntityInvincible(lester_ped2,true)
	SetBlockingOfNonTemporaryEvents(lester_ped2, true)
	TaskFollowNavMeshToCoord(lester_ped2, 1275.0631103516,-1721.5115966797,54.655071258545, 1.0, 20000, 1.0, true, 1.0)
	Wait(7500)
	FreezeEntityPosition(lester_ped2, true)
	Wait(2000)
	text = "Off...ati ajuns!"
	Wait(2000)
	text = "In sfarsit!"
	Wait(2000)
	text = "Acum sa trecem la treaba!"
	Wait(2000)
	text = "Hai in spate sa ne echipam..."
	Wait(2000)
	text = "Dupa mine, gloabelor!"
	Wait(2000)
	text = "..."
	Wait(2000)
	text = nil
	FreezeEntityPosition(lester_ped2, false)
	TaskFollowNavMeshToCoord(lester_ped2, 1267.9090576172,-1714.5211181641,54.655025482178, 1.0, 20000, 1.0, true, 1.0)
		Wait(17500)
		FreezeEntityPosition(lester_ped2, true)
		Wait(2000)
		SetEntityCoordsNoOffset(lester_ped2,1014.6817016602,-3158.9387207031,-38.907566070557, false, false, false, true) --- Teleport Player Back to start
		SetEntityHeading(lester_ped2, 83.53)
		TriggerServerEvent('set_specialcam',target)
		Wait(17500)
		TriggerServerEvent('tp_imp',target)
end)

AddEventHandler('spawn_lester',function()
	Citizen.CreateThread(function()
		while true do
			Wait(0)
			Draw3DText( 1275.0631103516,-1721.5115966797,54.155071258545, text, 4, 0.1, 0.1)
			Draw3DText( -2308.9853515625,3393.7092285156,30.950607299805-0.9, "Cadet Corupt | Ofera arme | ROB", 4, 0.1, 0.1)---2308.9853515625,3393.7092285156,30.950607299805

		end
	end)
end)

RegisterNetEvent('tp_at_imp')
AddEventHandler('tp_at_imp',function(x,y,z,h)
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)
		SetEntityCoordsNoOffset(playerPed,x,y,z, false, false, false, true) --- Teleport Player Back to start
		SetEntityHeading(playerPed, h)
	end)
end)

RegisterNetEvent('set_blip_mission')
AddEventHandler('set_blip_mission',function(target)
	Citizen.CreateThread(function()

			blip = AddBlipForCoord(1274.6240234375,-1721.0201416016,54.68083190918)
			SetBlipRoute(blip,true)

			while true do
				Wait(0)
				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)
				if target ~= false then
					if Vdist(1274.6240234375,-1721.0201416016,54.68083190918, coords) < 2 then
						camera_start(1276.9575195313,-1725.5511474609,54.650009155273)
						TriggerServerEvent('spawn_lester',target)
						Wait(20000)
						TriggerEvent('stop_camera')
						break
					end
				end
			end
			SetBlipRoute(blip,false)
			RemoveBlip(blip)
	end)
end)

RegisterNetEvent('set_blip_driver')
AddEventHandler('set_blip_driver',function()
	Citizen.CreateThread(function()

		blip = AddBlipForCoord(2673.18359375,3517.1870117188,52.339908599854)
		SetBlipSprite(blip,229)
		SetBlipColour(blip, 37)

		local blip1 = AddBlipForCoord(2673.18359375,3517.1870117188,52.339908599854)
		SetBlipSprite(blip1, 161)
		SetBlipScale(blip1, 0.8)
		SetBlipColour(blip1, 37)

			FreezeEntityPosition(lester_ped2, true)

			while true do
				Wait(0)
				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)
				if Vdist(2673.18359375,3517.1870117188,52.339908599854, coords) < 2 then
					RemoveBlip(blip)
					RemoveBlip(blip1)
					TriggerEvent('rob_bank')
					giveWeapon('weapon_assaultrifle')
					giveWeapon('weapon_pistol')
					giveWeapon('weapon_pumpshotgun')
					notify("Mergeti la o banca, ati primit si arme, haidaaa!")
					break
				end
			end
			RemoveBlip(blip)
			RemoveBlip(blip1)
	end)
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('waiting_screen')
AddEventHandler('waiting_screen',function()
	Citizen.CreateThread(function()
		while true do
			Wait(0)
			onScreen("~w~Duceti-va si ridicati masina #KURUMA si armele de la magazinul de pe autostrada!",0.1,0.3)
			if stop then
				break
			end
		end
	end)
end)

AddEventHandler('waiting_screen',function()
	local a = 0
	Citizen.CreateThread(function()
		while true do
			Wait(1000)
			a = a + 1
			if a == 20 then
				stop = true
				Wait(500)
				a = 0
				break
			end
		end
	end)
end)

RegisterNetEvent('set_camlester')
AddEventHandler('set_camlester',function()
	Citizen.CreateThread(function()
		while true do
			Wait(0)
			camera_start(1276.9575195313,-1725.5511474609,54.650009155273)
			Wait(20000)
			TriggerEvent('stop_camera')
			break
		end
	end)
end)

RegisterNetEvent('set_camfadepos')
AddEventHandler('set_camfadepos',function(x,y,z)
	Citizen.CreateThread(function()
		DoScreenFadeOut(100)
		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end
		while true do
			Wait(0)
			camera_startfoc(x,y,z)
			Citizen.Wait(0)
			DoScreenFadeIn(250)
			Wait(40000)
			TriggerEvent('stop_camera')
			break
		end
	end)
end)

RegisterNetEvent('set_camfade')
AddEventHandler('set_camfade',function()
    playerPed = GetPlayerPed(-1)
    coords = GetEntityCoords(playerPed)
    bone = GetPedBoneIndex(playerPed, 24818)
    sacosa = GetHashKey("prop_cs_heist_bag_01")
    funiesacosa = GetHashKey("prop_cs_heist_bag_strap_01")
	RequestModel(sacosa)
	RequestModel(funiasacosa)

	Citizen.CreateThread(function()
		DoScreenFadeOut(100)
		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end
		Citizen.Wait(2500)
		DoScreenFadeIn(250)
	end)
        sacosel = CreateObject(sacosa, coords.x, coords.y, coords.z, true, true, false)
        funia = CreateObject(funiesacosa, coords.x, coords.y, coords.z, true, true, false)

        AttachEntityToEntity(sacosel, playerPed, bone, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
        AttachEntityToEntity(funia, playerPed, bone, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
end)

RegisterNetEvent("stergesacosa")
AddEventHandler("stergesacosa", function()
    DeleteObject(sacosel)
    DeleteObject(funia)
end)

RegisterNetEvent("remove_weapons")
AddEventHandler("remove_weapons", function()
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
end)

RegisterNetEvent('es_bank:currentlyrobbing')
AddEventHandler('es_bank:currentlyrobbing', function(robb)
	robbing = true
	bank = robb
	secondsRemaining = 720
end)

RegisterNetEvent('es_bank:toofarlocal')
AddEventHandler('es_bank:toofarlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "The robbery was cancelled, you will receive nothing.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
	TriggerEvent('remove_weapons')
end)

RegisterNetEvent('es_bank:playerdiedlocal')
AddEventHandler('es_bank:playerdiedlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "The robbery was cancelled, you died!.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
	TriggerEvent('remove_weapons')
end)


RegisterNetEvent('es_bank:robberycomplete')
AddEventHandler('es_bank:robberycomplete', function(reward)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Robbery done, you received:^2" .. reward)
	bank = ""
	secondsRemaining = 0
	incircle = false
	TriggerEvent('remove_weapons')
end)

RegisterNetEvent('rob_bank')
AddEventHandler('rob_bank',function()
	Citizen.CreateThread(function()
		while true do
			local pos = GetEntityCoords(GetPlayerPed(-1), true)

			for k,v in pairs(banks)do
				local pos2 = v.position
				if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
					if not robbing then
						DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
						if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 2)then
							if (incircle == false) then
								bank_DisplayHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.nameofbank .. "~w~ beware, the police will be alerted!")
							end
							incircle = true
							if(IsControlJustReleased(1, 51))then
								TriggerServerEvent('es_bank:rob', k)
							end
						elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 2)then
							incircle = false
						end
					end
				end
			end

			if robbing then
				SetPlayerWantedLevel(PlayerId(), 0, 0)
				SetPlayerWantedLevelNow(PlayerId(), 0)
				
				bank_drawTxt(0.66, 1.44, 1.0,1.0,0.4, "Robbing bank: ~r~" .. secondsRemaining .. "~w~ seconds remaining", 255, 255, 255, 255)
				
				local pos2 = banks[bank].position
				local ped = GetPlayerPed(-1)
				
				if IsEntityDead(ped) then
				TriggerServerEvent('es_bank:playerdied', bank)
				elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 15)then
					TriggerServerEvent('es_bank:toofar', bank)
				end
			end
			Citizen.Wait(0)
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		if robbing then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		for k,v in pairs(banks)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if IsPlayerWantedLevelGreater(PlayerId(),0) or ArePlayerFlashingStarsAboutToDrop(PlayerId()) then
					local wanted = GetPlayerWantedLevel(PlayerId())
					Citizen.Wait(5000)
				    SetPlayerWantedLevel(PlayerId(), wanted, 0)
					SetPlayerWantedLevelNow(PlayerId(), 0)
				end
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local rob = true

	RequestModel( "cs_lestercrest" )
	while ( not HasModelLoaded( "cs_lestercrest" ) ) do
		Citizen.Wait( 1 )
	end

	RequestAnimDict("mini@strip_club@idles@bouncer@base")
	while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
		Wait(1)
	end

	local lester_ped1 = CreatePed(4, "cs_lestercrest",705.88415527344,-964.98645019531,30.395347595215-0.9, 270.0,false,false)
	SetEntityInvincible(lester_ped1,true)
	FreezeEntityPosition(lester_ped1, true)
	SetBlockingOfNonTemporaryEvents(lester_ped1, true)

	while true do
		Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if Vdist(pos,1290.3466796875,-1734.3869628906,53.261741638184) < 2.5 then
			--FreezeEntityPosition(GetPlayerPed(-1), false)
			bank_DisplayHelpText("Press ~INPUT_CONTEXT~to start the rob!")
				if IsControlJustPressed(0,51) then
					TriggerServerEvent('start_heist')
					camera_start(708.78106689453,-967.63354492188,30.395345687866)
				end
		end
	end
end)

function camera_start(x, y,z)
    local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)	
    FreezeEntityPosition(playerPed, true) --- Freeze The Player There
    SetCamCoord(cam, x, y, z) --- Set the camera there
	RenderScriptCams(1, 0, 0, 1, 1) --- Render Cams
end

function deleteVehiclePedIsIn()
	local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
	SetVehicleHasBeenOwnedByPlayer(v,false)
	Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
	SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
end
    
function camera_startfoc(x, y,z)
    local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)	
    FreezeEntityPosition(playerPed, true) --- Freeze The Player There
    SetCamCoord(cam, x, y, z) --- Set the camera there
	SetCamRot(cam, 0.0, 0.0, 270.0)
	RenderScriptCams(1, 0, 0, 1, 1) --- Render Cams
end

function giveWeapon(weaponHash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponHash), 999, false, false --[[equips when gotten]])
end

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function bank_DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov   
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, 255)		-- You can change the text color here
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function onScreen(content,x,y)
	SetTextFont(1)
	SetTextProportional(0)
	SetTextScale(1.0, 1.0)
	SetTextEntry("STRING")
	AddTextComponentString(content)
	DrawText(x+0.015, y-0.05)
end
