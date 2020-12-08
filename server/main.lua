--||@SuperCoolNinja.||--

--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.3'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_MenuAdmin/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_MenuAdmin]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

local name = nil
local prenom = nil
RegisterServerEvent("GTA:BannirJoueur")
AddEventHandler("GTA:BannirJoueur", function(targetID, reason)
	local targetid = getPlayerID(targetID)
	local source = source
	TriggerEvent('GTA:GetInfoJoueurs', targetid, function(data)
		local name = data.nom
		local prenom = data.prenom

		MySQL.Sync.execute("INSERT INTO gta_joueurs_banni (`license`, `nom`, `prenom`, `isBanned`, `raison`) VALUES (@username, @nom, @prenom, @isBanned, @raison)", {['@username'] = targetid, ['@nom'] = tostring(name), ['@prenom'] = tostring(prenom), ['@isBanned'] = 1, ['@raison'] = tostring(reason)})
		DropPlayer(targetID, "VOUS AVEZ ÉTÉ BANNI DÉFINITIVEMENT RAISON : " ..reason .. ".")
		TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Joueur Bannis.")
	end)
end)

RegisterServerEvent("GTA:CheckRoleAdmin")
AddEventHandler("GTA:CheckRoleAdmin", function()
	local source = source
	local license = GetPlayerIdentifiers(source)[1]

	local isAdmin = MySQL.Sync.fetchScalar("SELECT isAdmin FROM gta_joueurs WHERE license = @license", {['@license'] = license})
	if isAdmin then
		TriggerClientEvent("GTA:UpdateRoleAdmin", source)
	end
end)


RegisterServerEvent("GTA:ServeurGodMode")
AddEventHandler("GTA:ServeurGodMode", function()
  TriggerClientEvent("GTA:toggleGodmode", source)
end)