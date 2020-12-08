isPAdmin = false
local godmode = false


--> Noclip Variables
local in_noclip_mode = false
local travelSpeed = 4
local curLocation
local curRotation
local curHeading
local target

--> Event :
RegisterNetEvent('GTA:UpdateRoleAdmin')
AddEventHandler('GTA:UpdateRoleAdmin', function()
	isPAdmin = true
end)

RegisterNetEvent("GTA:toggleGodmode")
AddEventHandler("GTA:toggleGodmode", function()
  godmode = not godmode
  SetEntityInvincible(GetPlayerPed(-1), godmode)
  if godmode then
    exports.nCoreGTA:ShowNotification("GodMode ~g~activé")
  else
    exports.nCoreGTA:ShowNotification("GodMode ~r~désactivé")
  end
end)


--> Function :
function toggleNoClipMode()
	in_noclip_mode = not in_noclip_mode
    if(in_noclip_mode)then
        turnNoClipOn()
    end
end

function turnNoClipOn()
    local playerPed = PlayerPedId()

    local x, y, z = table.unpack( GetEntityCoords( playerPed, false ) )
    curLocation = { x = x, y = y, z = z }
    curRotation = GetEntityRotation( playerPed, false )
    curHeading = GetEntityHeading( playerPed )
end

-- Credits to @Oui (Lambda Menu)
function degToRad( degs )
    return degs * 3.141592653589793 / 180
end

-- Handles all No Clipping.
Citizen.CreateThread( function()
    local rotationSpeed = 1.5
    local forwardPush = 0.3

    local moveUpKey = 44      -- Q
    local moveDownKey = 46    -- E
    local moveForwardKey = 32 -- W
    local moveBackKey = 33    -- S
    local rotateLeftKey = 34  -- A
    local rotateRightKey = 35 -- D

    -- Updates the players position
    function handleMovement(xVect,yVect)
        if ( IsControlPressed( 1, moveUpKey ) or IsDisabledControlPressed( 1, moveUpKey ) ) then
            curLocation.z = curLocation.z + forwardPush
        elseif ( IsControlPressed( 1, moveDownKey ) or IsDisabledControlPressed( 1, moveDownKey ) ) then
            curLocation.z = curLocation.z - forwardPush
        end

        if ( IsControlPressed( 1, moveForwardKey ) or IsDisabledControlPressed( 1, moveForwardKey ) ) then
            curLocation.x = curLocation.x + xVect
            curLocation.y = curLocation.y + yVect
        elseif ( IsControlPressed( 1, moveBackKey ) or IsDisabledControlPressed( 1, moveBackKey ) ) then
            curLocation.x = curLocation.x - xVect
            curLocation.y = curLocation.y - yVect
        end

        if ( IsControlPressed( 1, rotateLeftKey ) or IsDisabledControlPressed( 1, rotateLeftKey ) ) then
            curHeading = curHeading + rotationSpeed
        elseif ( IsControlPressed( 1, rotateRightKey ) or IsDisabledControlPressed( 1, rotateRightKey ) ) then
            curHeading = curHeading - rotationSpeed
        end
    end
     while true do
        Citizen.Wait(0)
        if (in_noclip_mode) then
            local playerPed = PlayerPedId()

            if ( IsEntityDead( playerPed ) ) then
                turnNoClipOff()

                -- Ensure we get out of noclip mode
                Citizen.Wait( 100 )
            else
                target = playerPed

                -- Handle Noclip Movement.
                local inVehicle = IsPedInAnyVehicle( playerPed, true )

                if ( inVehicle ) then
                    target = GetVehiclePedIsUsing( playerPed )
                end

                SetEntityVelocity( playerPed, 0.0, 0.0, 0.0 )
                SetEntityRotation( playerPed, 0, 0, 0, 0, false )

                -- Prevent Conflicts/Damage
                local xVect = forwardPush * math.sin( degToRad(curHeading) ) * -1.0
                local yVect = forwardPush * math.cos( degToRad(curHeading) )

                handleMovement(xVect,yVect)

                -- Update player postion.
                SetEntityCoordsNoOffset( target, curLocation.x, curLocation.y, curLocation.z, true, true, true )
                SetEntityHeading( target, curHeading - rotationSpeed )
            end
        end
     end
end)

function LocalPed()
	return GetPlayerPed(-1)
end



--> Function :
function teleportToPlayer(targetId)
	local targetPed = GetPlayerPed(targetId)
	local targetCoords = GetEntityCoords(targetPed)

    exports.nCoreGTA:ShowNotification("~w~Vous avez étais téléporter sur : " ..GetPlayerName(targetId) .. " (ID : " .. targetId)
	SetEntityCoords(LocalPed(), targetCoords, 1, 0, 0, 1)
end

function teleportToWayPoint()
	local waypoint = GetFirstBlipInfoId(8)
	local ped = LocalPed()
	if DoesBlipExist(waypoint) then
		local waypointCoords = GetBlipInfoIdCoord(waypoint)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(ped, waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(ped, waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end
			Citizen.Wait(1)
		end

        exports.nCoreGTA:ShowNotification("~w~Vous avez étais téléporter sur votre point !")
	else
        exports.nCoreGTA:ShowNotification("~r~Veuillez placer un marker !")
	end
end


function RaisonDuBan(MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', "Raison du ban :")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result --Returns the result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

--> CHECK SI LE JOUEUR EST ADMIN AU SPAWN :
local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		TriggerServerEvent("GTA:CheckRoleAdmin")
        firstspawn = 1
    end
end)