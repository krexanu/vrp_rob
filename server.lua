local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPclient = Tunnel.getInterface("vRP","vrp_rob")

vRP = Proxy.getInterface("vRP")

local player

RegisterServerEvent('start_heist')
AddEventHandler('start_heist', function()

  print("merge in plm")
  user_id = vRP.getUserId({source})
  player = vRP.getUserSource({user_id})

  vRP.prompt({player,"Partener [ ID ]:","",function(player,nuser_id) 
    if nuser_id ~= nil and nuser_id ~= "" then
      if user_id == tonumber(nuser_id) then 
        local target = vRP.getUserSource({tonumber(nuser_id)})
        if target ~= nil then
          vRP.request({target,GetPlayerName(player).." vrea sa participi la ROB! Accepti?", 10, function(target,ok)
            if not ok then
              vRPclient.notify(target,{"~r~Ai refuzat sa iei parte la robul lui"..GetPlayerName(player).."."})
            else
              TriggerClientEvent('stop_camera',player)
              TriggerClientEvent('set_blip_mission',player,target)
              vRPclient.notify(player,{"A acceptat, hai la rob coaie!"})
              vRPclient.notify(target,{"Ai acceptat, hai la rob coaie!"})
            end
          end})
        else
          vRPclient.notify(player,{"Id introdus gresit!"})
        end
      else
        vRPclient.notify(player,{"Singur?!Idiotule...M-am prins de schema!"})
      end
    else
      vRPclient.notify(player,{"Id introdus gresit!"})
    end
  end})
end)

RegisterServerEvent('spawn_lester')
AddEventHandler('spawn_lester', function(target)
  TriggerClientEvent("spawn_lester", -1,target)
  TriggerClientEvent('tp_at_imp',player,1274.3673095703,-1723.2858886719,54.655017852783, 50.0)
  TriggerClientEvent('tp_at_imp',target,1276.7087402344,-1721.8830566406,54.65502166748, 75.0)
  TriggerClientEvent('set_camlester',target)
end)

RegisterServerEvent('set_specialcam')
AddEventHandler('set_specialcam', function(target)
  TriggerClientEvent('tp_at_imp',player,1012.4476928711,-3158.3759765625,-38.907562255859, 216.311)
  TriggerClientEvent('tp_at_imp',target,1013.1937255859,-3160.5610351563,-38.907703399658, 301.15)
  TriggerClientEvent('set_camfadepos',target,1009.9951171875,-3159.1052246094,-38.907726287842)
  TriggerClientEvent('waiting_screen',player)
  TriggerClientEvent('waiting_screen',target)
  TriggerClientEvent('set_blip_driver',player)
  TriggerClientEvent('set_blip_driver',target)
  TriggerClientEvent('spawn_veh',player)
  TriggerClientEvent('set_camfadepos',player,1009.9951171875,-3159.1052246094,-38.907726287842)
end)

RegisterServerEvent('tp_imp')
AddEventHandler('tp_imp', function(target)
  TriggerClientEvent('tp_at_imp',player,1265.3732910156,-1711.0408935547,54.722911834717, 216.311)
  TriggerClientEvent('tp_at_imp',target,1260.5396728516,-1712.4360351563,54.942573547363, 301.15)
  TriggerClientEvent('stop_camera',player)
  TriggerClientEvent('stop_camera',target)
end)

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
	["fleeca3"] = {
		position = { ['x'] = -1212.2568359375, ['y'] = -336.128295898438, ['z'] = 36.7907638549805 },
		reward = 30000 + math.random(100000,200000),
		nameofbank = "Fleeca Bank (Vinewood Hills)",
		lastrobbed = 0
	},
	["fleeca4"] = {
		position = { ['x'] = -354.452575683594, ['y'] = -53.8204879760742, ['z'] = 48.0463104248047 },
		reward = 30000 + math.random(100000,200000),
		nameofbank = "Fleeca Bank (Burton)",
		lastrobbed = 0
	},
	["fleeca5"] = {
		position = { ['x'] = 309.967376708984, ['y'] = -283.033660888672, ['z'] = 53.1745223999023 },
		reward = 30000 + math.random(100000,200000),
		nameofbank = "Fleeca Bank (Alta)",
		lastrobbed = 0
	},
	["fleeca6"] = {
		position = { ['x'] = 1176.86865234375, ['y'] = 2711.91357421875, ['z'] = 38.097785949707 },
		reward = 30000 + math.random(100000,200000),
		nameofbank = "Fleeca Bank (Desert)",
		lastrobbed = 0
	},
	["pacific"] = {
		position = { ['x'] = 255.001098632813, ['y'] = 225.855895996094, ['z'] = 101.005694274902 },
		reward = 60000 + math.random(100000,200000),
		nameofbank = "Pacific Standard PDB (Downtown Vinewood)",
		lastrobbed = 0
	}
}

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

AddEventHandler("playerDropped", function()
	if(robbers[source])then
		local wtf = robbers[source]
		local wtf2 = banks[wtf].nameofbank
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" ..wtf2.."Reason: [Disconnected]")
	end
end)

RegisterServerEvent('es_bank:toofar')
AddEventHandler('es_bank:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. banks[robb].nameofbank)
	end
end)

RegisterServerEvent('es_bank:playerdied')
AddEventHandler('es_bank:playerdied', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:playerdiedlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. banks[robb].nameofbank)
	end
end)

RegisterServerEvent('es_bank:rob')
AddEventHandler('es_bank:rob', function(robb)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if vRP.hasGroup({user_id,"cop"}) then
    vRPclient.notify(player,{"~r~Cops can't rob banks."})
  else
	  if banks[robb] then
		  local bank = banks[robb]

		  if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then
			  TriggerClientEvent('chatMessage', player, 'ROBBERY', {255, 0, 0}, "This has already been robbed recently. Please wait another: ^2" .. (1200 - (os.time() - bank.lastrobbed)) .. "^0 seconds.")
			  return
		  end
		  TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. bank.nameofbank)
		  TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. bank.nameofbank .. "^0, do not get too far away from this point!")
		  TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^1 12 ^0minutes and the money is yours!")
		  TriggerClientEvent('es_bank:currentlyrobbing', player, robb)
		  banks[robb].lastrobbed = os.time()
		  robbers[player] = robb
		  local savedSource = player
		  SetTimeout(720000, function()
			  if(robbers[savedSource])then
				  if(user_id)then
					  vRP.giveInventoryItem({user_id,"dirty_money",bank.reward,true})
					  TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. bank.nameofbank .. "^0!")
					  TriggerClientEvent('es_bank:robberycomplete', savedSource, bank.reward)
				  end
			  end
		  end)		
	  end
	end
end)

