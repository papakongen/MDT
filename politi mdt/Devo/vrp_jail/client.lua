--bind client tunnel interface
vRPbm = {}
Tunnel.bindInterface("vRP_basic_menu",vRPbm)
vRP = Proxy.getInterface("vRP")

local frozen = false
local unfrozen = false
function vRPbm.loadFreeze(freeze)
	if freeze then
	  frozen = true
	  unfrozen = false
	else
	  unfrozen = true
	end
end

kortslutter = false
police1 = 0
locked = true 

RegisterNetEvent('kaz:sendpolice')
AddEventHandler('kaz:sendpolice', function(police)
police1 = police
end)

RegisterNetEvent('kaz_jail:lockstatus2')
AddEventHandler('kaz_jail:lockstatus2', function(locked2)
locked = locked2
end)

local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false
  
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
	while true do
		if frozen then
			if unfrozen then
				SetEntityInvincible(GetPlayerPed(-1),false)
				SetEntityVisible(GetPlayerPed(-1),true)
				FreezeEntityPosition(GetPlayerPed(-1),false)
				frozen = false
			else
				SetEntityInvincible(GetPlayerPed(-1),true)
				SetEntityVisible(GetPlayerPed(-1),false)
				FreezeEntityPosition(GetPlayerPed(-1),true)
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1670.8273925781,2618.3583984375,53.190883636475, true ) > 250 then
		TriggerServerEvent('kaz_gobacktojail:1')
		end
	end
end)	

Citizen.CreateThread(function()
	while true do
		if not vRP.isHandcuffed() then 
			TriggerServerEvent('jail:removeJailedGroup')
		end
		Citizen.Wait(10000)
	end
end)

-- KORTLSUT
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if locked == true then 
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1884.5135498047,2704.7912597656,45.838832855225, true ) < 35 then
					DrawMarker(27,1884.5135498047,2704.7912597656,45.838832855225-0.9,0,0,0,0,0,Rotation,1.001,1.0001,0.5001,255,0,0,200,0,0,0,true)					
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1884.5135498047,2704.7912597656,45.838832855225, true ) < 2 then 
							DrawText3Ds(1884.5135498047,2704.7912597656,45.838832855225+0.3, "~w~[~g~E~w~] for starte kortslutning på generatoren.", 3.0, 7) 
								if IsControlJustPressed(1, 38) then
									if police1 >= 2 then 
										message = "En person prøver at kortslutte fængslets generator!! Den vil være nede om 5 minutter!!"
										local plyPos = GetEntityCoords(GetPlayerPed(-1))
										TriggerServerEvent('kaz_jail:dispatch', plyPos.x, plyPos.y, plyPos.z, message)
										TriggerServerEvent('kaz_jail:dispatch', plyPos.x, plyPos.y, plyPos.z, message)
										TriggerServerEvent('kaz_jail:dispatch', plyPos.x, plyPos.y, plyPos.z, message)
										kortslutter = true
										TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER")
										FreezeEntityPosition(GetPlayerPed(-1),true)
										SetEntityHeading(GetPlayerPed(-1), 24.468120574951)	
										exports['kaz_progressbar']:startUI(300000, "Kortslutter generator")						
										Citizen.Wait(300000) 
										FreezeEntityPosition(GetPlayerPed(-1),false)
										ClearPedTasksImmediately(GetPlayerPed(-1))
										if kortslutter == true then
											message = "Fængslets generator er blevet kortsluttet, fangerne flygter!! Generatoren er nede i 15 minutter!!"
											local plyPos = GetEntityCoords(GetPlayerPed(-1))
											TriggerServerEvent('kaz_jail:dispatch', plyPos.x, plyPos.y, plyPos.z, message)
											TriggerServerEvent('kaz_jail:stopfodting')
											TriggerEvent("pNotify:SendNotification",{text = "Generatoren blev kortsluttet, den vil være nede i 15 minutter! - Ta til det kriminelle jobcenter!",type = "success",timeout = (15000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
											TriggerServerEvent('kaz_doors:outbreak')
											kortslutter = false
										end
									else
										TriggerEvent("pNotify:SendNotification",{text = "Ikke nok politi på job!",type = "success",timeout = (8500),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
									end
								end
						end
				end
			end
	end
end)
-- ANNULLER
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if kortslutter == true then 
				DrawText3Ds(1884.5135498047,2704.7912597656,45.838832855225+0.3, "~w~[~g~H~w~] for at afslutte.", 3.0, 7) 
					if IsControlJustPressed(1, 74) then
						message = "Forsøget på at kortslutte fængslets generator er blevet afbrudt!"
						local plyPos = GetEntityCoords(GetPlayerPed(-1))
						TriggerServerEvent('kaz_jail:dispatch', plyPos.x, plyPos.y, plyPos.z, message)
						kortslutter = false
						local spiller = PlayerPedId()
						FreezeEntityPosition(spiller,false)
						ClearPedTasksImmediately(spiller)
					end
			end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if locked == false then 
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1272.2215576172,-1712.1978759766,54.771453857422, true ) < 35 then
					DrawMarker(27,1272.2215576172,-1712.1978759766,54.771453857422-0.9,0,0,0,0,0,Rotation,1.001,1.0001,0.5001,255,0,0,200,0,0,0,true)					
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1272.2215576172,-1712.1978759766,54.771453857422, true ) < 2 then 
						DrawText3Ds(1272.2215576172,-1712.1978759766,54.771453857422+0.3, "~w~[~g~E~w~] for at hacke fodlænke.", 3.0, 7) 
							if IsControlJustPressed(1, 38) then
								TriggerEvent("mhacking:show")
								TriggerEvent("mhacking:start",4,30,fodting)
							end
					end
				end
			end
	end
end)

function fodting(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerServerEvent('kaz_jail:hacked')
	else
		TriggerEvent("pNotify:SendNotification",{text = "Du fejlede, systemet har sendt politiet en besked.",type = "success",timeout = (8500),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		local plyPos = GetEntityCoords(GetPlayerPed(-1))
		message = "En person forsøgte forgæves at hacke fodlænken."
		TriggerServerEvent('kaz_jail:dispatch', plyPos.x, plyPos.y, plyPos.z, message)
		TriggerEvent('mhacking:hide')
	end
end	
				
				
function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end