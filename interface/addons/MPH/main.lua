local _, MPH = ...

MPH = LibStub("AceAddon-3.0"):NewAddon(MPH, "MPH", "AceConsole-3.0", "AceEvent-3.0")

--Stronghly inspired by the Simcraft AddOn, thank you to them! 

local GetApplicants = _G.C_LFGList.GetApplicants
local GetApplicantInfo = _G.C_LFGList.GetApplicantInfo
local GetApplicantMemberInfo = _G.C_LFGList.GetApplicantMemberInfo

local REGIONS = {"us", "kr", "eu", "tw", "cn", "oc"}

function MPH:OnInitialize()
  MPH:RegisterChatCommand('mph', 'PrintMPH')
end

function MPH:OnEnable()
    self:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED')
    self:RegisterEvent('GROUP_ROSTER_UPDATE')
end

function MPH:OnDisable()

end

function MPH:LFG_LIST_APPLICANT_LIST_UPDATED()
  local output, err = MPH:GenerateOutput()
    
    MphCopyFrameScrollText:SetText(output)

  if err == false then 
    MphCopyFrameScrollText:HighlightText()
  end
end

function MPH:GROUP_ROSTER_UPDATE()
    local output, err = MPH:GenerateOutput()
 
        MphCopyFrameScrollText:SetText(output)
 
    if err == false then
        MphCopyFrameScrollText:HighlightText()
    end
end

--Just some helper functions
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
--End helper functions

function LookupRegion(id)
    return id ~= nil and REGIONS[id] or "us"
end

-- Main function, grabs applicants and formats them nicely in JSON for the website

function MPH:GenerateOutput()
  local realmName = GetRealmName()
  local output = ""
  local err = false 

  local region = LookupRegion(GetCurrentRegion())

  local applicants = GetApplicants()

  local numberOfPartyMembers = GetNumGroupMembers()


  if applicants ~= nil then 
    if #applicants <= 0 then 
      err = true 
      output = "Your group has no applicants."
    end
  end 

  if applicants == nil and numberOfPartyMembers == 0 then 
    err = true 
    output = "No applicants found. Check to make sure your group is listed in the Premade Groups menu."
  end 

  if applicants ~= nil and #applicants > 0 or numberOfPartyMembers > 1 then

            output = "{\"region\": \"" .. region .. "\"},\n"

            if IsInRaid() == true then 
              output = output .. "{\"groupType\":\"raid\"},\n"
              for i = 1, 40 do -- For each raid member
                local unit = "raid" .. i
                if UnitExists(unit) and not UnitIsUnit(unit, "player") then -- If this raid member exists and isn't the player
                  name = GetRaidRosterInfo(i)
                  -- fix for the above function sometimes returning nil when joining a raid for the first time
                  -- just making sure we aren't getting a nil name
                  if name ~= nil then
                    local role = UnitGroupRolesAssigned(unit)
                    output = output .. "{"
                    local exploded = explode("-", name)
                    output = output .. "\"character\": \"" .. exploded[1] .. "\"," 
                    local server = #exploded > 1 and FixRealmName(exploded[2]) or FixRealmName(realmName)
                    output = output .. "\"server\": \"" .. server .. "\","
                    output = output .. "\"playerType\": \"groupMember\","
                    output = output .. "\"role\": \"" .. role .. "\"},\n"
                  end
                end
              end
            else 
              output = output .. "{\"groupType\":\"dungeon\"},\n"
              for i = 0, 5 do -- For each party members
                local unit = "party" .. i
                if UnitExists(unit) and not UnitIsUnit(unit, "player") then
                  output = output .. "{"
                  local name, server = UnitName(unit)
                  local role = UnitGroupRolesAssigned(unit)
                  output = output .. "\"character\": \"" .. name .. "\","
                  -- lil fix for realm name being "nil" if player is from client's realm
                  if server == "" or server == nil then 
                    server = realmName
                  end
                  output = output .. "\"server\": \"" .. FixRealmName(server) .. "\","
                  output = output .. "\"playerType\": \"groupMember\","
                  output = output .. "\"role\": \"" .. role .. "\"},\n"
                end
              end
            end

        if applicants ~= nil then

           for i=1, #applicants do
              local id, status, pendingStatus, numMembers, isNew, comment = GetApplicantInfo(applicants[i])
              for j=1, numMembers do 
                output = output .. "{"
                local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole  = C_LFGList.GetApplicantMemberInfo(applicants[i], j)
                local exploded = explode("-", name)
                output = output .. "\"character\": \"" .. exploded[1] .. "\","

                local server = ""
                --Players from our server don't get a fancy server in their names.
                --So we get our own server and replace it there if we don't get one 
                --from the name. A bit hacky!
                if #exploded > 1 then 
                  server = exploded[2]
                else
                  server = realmName
                end

                server = FixRealmName(server);

                output = output .. "\"server\": \"" .. server .. "\","
                output = output .. "\"playerType\": \"applicant\","
                output = output .. "\"role\": \"" .. assignedRole .. "\"},\n"
              end 
          end
        end

        output = string.sub(output,1,-3) -- trim trailing comma and newline
  end 

  return output, err

end 

function MPH:PrintMPH()
  
  local output, err = MPH:GenerateOutput()
  -- show the appropriate frames
  MphCopyFrame:Show()
  MphCopyFrameScroll:Show()
  MphCopyFrameScrollText:Show()
  MphCopyFrameScrollText:SetText(output)
  if err == false then 
    MphCopyFrameScrollText:HighlightText()
  end
end

-- this mess receives a server name that might need spaces in it and returns it properly spaced
-- this is necessary because the wow ingame api strips spaces, but the web api needs the spaces
function FixRealmName(server)

  if server ~= nil then
    server = string.gsub(server, "AeriePeak", "Aerie Peak")
    server = string.gsub(server, "AltarofStorms", "Altar of Storms")
    server = string.gsub(server, "AlteracMountains", "Alterac Mountains")
    server = string.gsub(server, "Area52", "Area 52")
    server = string.gsub(server, "ArgentDawn", "Argent Dawn")
    server = string.gsub(server, "BlackDragonflight", "Black Dragonflight")
    server = string.gsub(server, "BlackwaterRaiders", "Blackwater Raiders")
    server = string.gsub(server, "BlackwingLair", "Blackwing Lair")
    server = string.gsub(server, "Blade'sEdge", "Blade's Edge")
    server = string.gsub(server, "BleedingHollow", "Bleeding Hollow")
    server = string.gsub(server, "BloodFurnace", "Blood Furnace")
    server = string.gsub(server, "BootyBay", "Booty Bay")
    server = string.gsub(server, "BoreanTundra", "Borean Tundra")
    server = string.gsub(server, "BronzeDragonflight", "Bronze Dragonflight")
    server = string.gsub(server, "BurningBlade", "Burning Blade")
    server = string.gsub(server, "BurningLegion", "Burning Legion")
    server = string.gsub(server, "BurningSteppes", "Burning Steppes")
    server = string.gsub(server, "CenarionCircle", "Cenarion Circle")
    server = string.gsub(server, "ChamberofAspects", "Chamber of Aspects")
    server = string.gsub(server, "Chantséternels", "Chants éternels ")
    server = string.gsub(server, "ColinasPardas", "Colinas Pardas")
    server = string.gsub(server, "ConfrérieduThorium", "Confrérie du Thorium")
    server = string.gsub(server, "ConseildesOmbres", "Conseil des Ombres")
    server = string.gsub(server, "CultedelaRivenoire", "Culte de la Rive noire")
    server = string.gsub(server, "DarkIron", "Dark Iron")
    server = string.gsub(server, "DarkmoonFaire", "Darkmoon Faire")
    server = string.gsub(server, "DasKonsortium", "Das Konsortium")
    server = string.gsub(server, "DasSyndikat", "Das Syndikat")
    server = string.gsub(server, "DefiasBrotherhood", "Defias Brotherhood")
    server = string.gsub(server, "DemonSoul", "Demon Soul")
    server = string.gsub(server, "DerRatvonDalaran", "Der Rat von Dalaran")
    server = string.gsub(server, "DerabyssischeRat", "Der abyssische Rat")
    server = string.gsub(server, "DieArguswacht", "Die Arguswacht")
    server = string.gsub(server, "DieSilberneHand", "Die Silberne Hand")
    server = string.gsub(server, "DieTodeskrallen", "Die Todeskrallen")
    server = string.gsub(server, "DieewigeWacht", "Die ewige Wacht")
    server = string.gsub(server, "DunModr", "Dun Modr")
    server = string.gsub(server, "EarthenRing", "Earthen Ring")
    server = string.gsub(server, "EchoIsles", "Echo Isles")
    server = string.gsub(server, "EmeraldDream", "Emerald Dream")
    server = string.gsub(server, "FestungderStürme", "Festung der Stürme")
    server = string.gsub(server, "GrimBatol", "Grim Batol")
    server = string.gsub(server, "GrizzlyHills", "Grizzly Hills")
    server = string.gsub(server, "HowlingFjord", "Howling Fjord")
    server = string.gsub(server, "KhazModan", "Khaz Modan")
    server = string.gsub(server, "KirinTor", "Kirin Tor")
    server = string.gsub(server, "KulTiras", "Kul Tiras")
    server = string.gsub(server, "KultderVerdammten", "Kult der Verdammten")
    server = string.gsub(server, "LaCroisadeécarlate", "La Croisade écarlate")
    server = string.gsub(server, "LaughingSkull", "Laughing Skull")
    server = string.gsub(server, "LesClairvoyants", "Les Clairvoyants")
    server = string.gsub(server, "LesSentinelles", "Les Sentinelles")
    server = string.gsub(server, "LichKing", "Lich King")
    server = string.gsub(server, "Lightning'sBlade", "Lightning's Blade")
    server = string.gsub(server, "LosErrantes", "Los Errantes")
    server = string.gsub(server, "MarécagedeZangar", "Marécage de Zangar")
    server = string.gsub(server, "MoonGuard", "Moon Guard")
    server = string.gsub(server, "Pozzodell'Eternità", "Pozzo dell'Eternità")
    server = string.gsub(server, "ScarletCrusade", "Scarlet Crusade")
    server = string.gsub(server, "ScarshieldLegion", "Scarshield Legion")
    server = string.gsub(server, "ShadowCouncil", "Shadow Council")
    server = string.gsub(server, "ShatteredHalls", "Shattered Halls")
    server = string.gsub(server, "ShatteredHand", "Shattered Hand")
    server = string.gsub(server, "SilverHand", "Silver Hand")
    server = string.gsub(server, "SistersofElune", "Sisters of Elune")
    server = string.gsub(server, "SteamwheedleCartel", "Steamwheedle Cartel")
    server = string.gsub(server, "TarrenMill", "Tarren Mill")
    server = string.gsub(server, "Templenoir", "Temple noir")
    server = string.gsub(server, "TheForgottenCoast", "The Forgotten Coast")
    server = string.gsub(server, "TheMaelstrom", "The Maelstrom")
    server = string.gsub(server, "TheScryers", "The Scryers")
    server = string.gsub(server, "TheSha'tar", "The Sha'tar")
    server = string.gsub(server, "TheUnderbog", "The Underbog")
    server = string.gsub(server, "TheVentureCo", "The Venture Co")
    server = string.gsub(server, "ThoriumBrotherhood", "Thorium Brotherhood")
    server = string.gsub(server, "TolBarad", "Tol Barad")
    server = string.gsub(server, "Twilight'sHammer", "Twilight's Hammer")
    server = string.gsub(server, "TwistingNether", "Twisting Nether")
    server = string.gsub(server, "WyrmrestAccord", "Wyrmrest Accord")
    server = string.gsub(server, "ZirkeldesCenarius", "Zirkel des Cenarius")

    -- russian servers!
    server = string.gsub(server, "Ревущийфьорд", "Ревущий-фьорд")
    server = string.gsub(server, "СвежевательДуш", "Свежеватель-Душ")
    server = string.gsub(server, "Ясеневыйлес", "Ясеневый-лес")
    server = string.gsub(server, "ЧерныйШрам", "Черный-Шрам")
    server = string.gsub(server, "СтражСмерти", "Страж-Смерти")
    server = string.gsub(server, "Борейскаятундра", "Борейская-тундра")
    server = string.gsub(server, "ВечнаяПесня", "Вечная-Песня")
    server = string.gsub(server, "ПиратскаяБухта", "Пиратская-Бухта")
  end

  return server

end