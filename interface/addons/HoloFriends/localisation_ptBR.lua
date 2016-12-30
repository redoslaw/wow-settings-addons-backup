--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the Brazilian Portuguese localisation data

]]

if( GetLocale() == "ptBR" ) then

HOLOFRIENDS_DIALOGFACTIONMERGEFRIENDWARNING = [=[Você está prestes a fundir todos os amigos de
|cffffd200%s|r
à lista de amigos da facção.

|cffffd200AVISO|r
A lista individual de amigos será deletada!
Este passo é irrecorrigivel!
Dependendo das opções, isso pode levar a perda de dados!
Os dados da lista de amigos só são salvos localmente no seu disco rígido.

|cffffd200SUGESTÃO|r
Faça uma cópia de segurança (em um pendrive) do arquivo com a sua lista de amigos do HoloFriends:
{diretório_do_WoW}/WTF/Account/{Sua_Conta}/SavedVariables/HoloFriends.lua

|cffffd200Você tem uma cópia de segurança?|r]=]; -- Needs review

HOLOFRIENDS_LISTFEATURES39 = "marque um amigo para que ele seja monitorado e uma mensagem seja mostrada quando ele ficar online"; -- Needs review

HOLOFRIENDS_INITSHOWONLINEATLOGIN = "Lista dos seus amigos online:"; -- Needs review

HOLOFRIENDS_MSGFRIENDNOBNETNOFRIEND = "BNet indisponível no momento. Convite de amigo BNet não foi enviado."; -- Needs review
HOLOFRIENDS_MSGFRIENDNOBNETNOREMOVE = "BNet indisponível no momento. O amigo BNet não pôde ser removido."; -- Needs review
HOLOFRIENDS_MSGFRIENDNOBTAGNOFRIEND = "BattleTags estão desativados. Nenhum convite BNet foi enviado."; -- Needs review
HOLOFRIENDS_MSGFRIENDNOREALIDNOFRIEND = "RealIDs estão desativados. Nenhum convite BNet foi enviado."; -- Needs review

HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRST = "Mudar a ordem de nomes de char e nomes reais"; -- Needs review
HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRSTTT = "Se checado, o nome real do amigo de RealID será mostrado atrás do nome do char."; -- Needs review
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAME = "Mostrar nome do char perto do nome real do BNet"; -- Needs review

end
