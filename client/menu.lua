--||@SuperCoolNinja.||--
local menuConfig = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/ConfigMenu.json'))

local players_lists = {}

function getOnlinePlayers()
	for k,v in pairs(players_lists) do --Permet de clean la liste des joueurs pour evité des duplis.
		players_lists[k] = nil
	end

	for _, player in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerConnected(player) then
			local playerName = GetPlayerName(player)
			local serverID = GetPlayerServerId(player)
			table.insert(players_lists, {title = playerName, name = tostring(playerName), id = player, serverid = tonumber(serverID)})
		end
	end
	return players_lists
end

--> MENU :
local adminMenu = {
	opened = false,
	title = "",
	currentmenu = "menuAdminMain",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.26,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["menuAdminMain"] = {
			title = "Menu Admin",
			name = "menuAdminMain",
			buttons = {
				{name = "Liste Joueurs", action = "Liste Joueurs"},
				{name = "Mes Pouvoirs", action = "Mes Pouvoirs"},
			}
		},

		["Liste Joueurs"] = { --> Affiche la liste des joueurs
			title = "Liste Joueurs",
			name = "Liste Joueurs",
			buttons = players_lists
		},


		["Mes Pouvoirs"] = {
			title = "Mes Pouvoirs",
			name = "Mes Pouvoirs",
			buttons = {
				{name = "Vous téléporter sur votre point", action = "tptopoint"},
				{name = "Devenir Invincible/Normal", action = "godmode"},
				{name = "Mode No-Clip", action = "noclip"},
			}
		},

		["Action Joueur"] = { --> Affiche le menu action :
			title = "Action Joueur",
			name = "Action Joueur",
			buttons = { 
				{name = "Se téléporter sur lui", action = "tptoplayer"}, --> se tp sur le joueur.
				{name = "Bannir", action = "banjoueur"}, --> bannir le joueur.
			}
		},
		
  	}
}


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function LocalPed()
	return GetPlayerPed(-1)
end

function CloseCreator()
	Citizen.CreateThread(function()
		adminMenu.opened = false
		adminMenu.menu.from = 1
		adminMenu.menu.to = 10
	end)
end

function OpenMenu(open_menu)
	adminMenu.currentmenu = open_menu
	adminMenu.opened = true
	adminMenu.selectedbutton = 1
end

function drawMenuButton(button,x,y,selected)
	local menu = adminMenu.menu

	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)

	for i=1, #menuConfig do 
		if selected then
			SetTextColour(menuConfig[i].couleurTextSelectMenu.r, menuConfig[i].couleurTextSelectMenu.g, menuConfig[i].couleurTextSelectMenu.b, menuConfig[i].couleurTextSelectMenu.a)
		else
			SetTextColour(menuConfig[i].couleurTextMenu.r, menuConfig[i].couleurTextMenu.g, menuConfig[i].couleurTextMenu.b, menuConfig[i].couleurTextMenu.a)
		end

		if selected then
			DrawRect(x,y,menu.width,menu.height,menuConfig[i].couleurRectSelectMenu.r,menuConfig[i].couleurRectSelectMenu.g,menuConfig[i].couleurRectSelectMenu.b,menuConfig[i].couleurRectSelectMenu.a)
		else
			DrawRect(x,y,menu.width,menu.height,0,0,0,150)
		end
	end

	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = adminMenu.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

function drawMenuRight(txt,x,y,selected)
	local menu = adminMenu.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
	local menu = adminMenu.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	for i=1, #menuConfig do 
		DrawRect(x,y,menu.width,menu.height, menuConfig[i].couleurTopMenu.r, menuConfig[i].couleurTopMenu.g, menuConfig[i].couleurTopMenu.b, menuConfig[i].couleurTopMenu.a)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do 
		count = count + 1 
	end
	return count
end

local backlock = false
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if isPAdmin then --> Si le joueur est admin il peut accedez au menu admin logique non ?.
			if IsControlJustReleased(0, 168) then  --> Key F7
				OpenMenu("menuAdminMain")
			end
		end

		if adminMenu.opened then
			DisableControlAction(0, 140, true) --> DESACTIVER LA TOUCHE POUR PUNCH
			DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT
			local ped = LocalPed()
			local menu = adminMenu.menu[adminMenu.currentmenu]
			drawMenuTitle(menu.title, adminMenu.menu.x,adminMenu.menu.y + 0.08)
			local y = adminMenu.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			for i,button in pairs(menu.buttons) do
				if i >= adminMenu.menu.from and i <= adminMenu.menu.to then
					if i == adminMenu.selectedbutton then
						selected = true
					else
						selected = false
					end
				drawMenuButton(button,adminMenu.menu.x,y,selected)
				y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end
		end

		if adminMenu.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustPressed(1,188) then
				if adminMenu.selectedbutton > 1 then
					adminMenu.selectedbutton = adminMenu.selectedbutton -1
					if buttoncount > 10 and adminMenu.selectedbutton < adminMenu.menu.from then
						adminMenu.menu.from = adminMenu.menu.from -1
						adminMenu.menu.to = adminMenu.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if adminMenu.selectedbutton < buttoncount then
					adminMenu.selectedbutton = adminMenu.selectedbutton +1
					if buttoncount > 10 and adminMenu.selectedbutton > adminMenu.menu.to then
						adminMenu.menu.to = adminMenu.menu.to + 1
						adminMenu.menu.from = adminMenu.menu.from + 1
					end
				end
			end
		end
	end
end)


local thisPlayer = nil
local thisPlayerServerID = nil
function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = adminMenu.currentmenu
    local btn = button.action
	local btnPlayer = button.name

	if this == "menuAdminMain" then
		if btn == "Liste Joueurs" then
			getOnlinePlayers()
			Wait(250)
			OpenMenu("Liste Joueurs")
		elseif btn == "Mes Pouvoirs" then
			OpenMenu("Mes Pouvoirs")
		end
	elseif this == "Liste Joueurs" then
		if btnPlayer then
			thisPlayerID = button.id --> On stock le player séléctionner sur notre var thisPlayerID.
			thisPlayerServerID = button.serverid
			OpenMenu("Action Joueur")
		end
	elseif this == "Action Joueur" then
		if btn == "tptoplayer" then
			teleportToPlayer(thisPlayerID)
			CloseCreator()
		elseif btn == "banjoueur" then
			local reasonBan = RaisonDuBan(50)
            if tostring(reasonBan) == nil then
				exports.nCoreGTA:ShowNotification("Veuillez inserer une raison correct !")
                return nil
            end
			TriggerServerEvent("GTA:BannirJoueur", thisPlayerServerID, tostring(reasonBan))
		end
	elseif this == "Mes Pouvoirs" then
		if btn == "tptopoint" then
			teleportToWayPoint()
		elseif btn == "godmode" then
			TriggerServerEvent("GTA:ServeurGodMode")
		elseif btn == "noclip" then
			toggleNoClipMode()
		end
	end
end

function Back()
	CloseCreator()
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


function table.HasValue( t, val )
	for k, v in pairs( t ) do
		if ( v == val ) then return true end
	end
	return false
end