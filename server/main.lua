--||@SuperCoolNinja.||--
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
		exports.ghmattimysql:execute("INSERT INTO gta_joueurs_banni (`license`, `nom`, `prenom`, `isBanned`, `raison`) VALUES (@username, @nom, @prenom, @isBanned, @raison)", {['@username'] = targetid, ['@nom'] = tostring(name), ['@prenom'] = tostring(prenom), ['@isBanned'] = 1, ['@raison'] = tostring(reason)})
		DropPlayer(targetID, "VOUS AVEZ ÉTÉ BANNI DÉFINITIVEMENT RAISON : " ..reason .. ".")
		TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Joueur Bannis.")
	end)
end)

RegisterServerEvent("GTA:CheckRoleAdmin")
AddEventHandler("GTA:CheckRoleAdmin", function()
	local source = source
	local license = GetPlayerIdentifiers(source)[1]

	exports.ghmattimysql:execute("SELECT * FROM gta_joueurs WHERE license = @username", {['@username'] = license}, function(result)
		if result[1].isAdmin == 1 then
			TriggerClientEvent("GTA:UpdateRoleAdmin", source)
		end
	end)
end)


RegisterServerEvent("GTA:ServeurGodMode")
AddEventHandler("GTA:ServeurGodMode", function()
  TriggerClientEvent("GTA:toggleGodmode", source)
end)