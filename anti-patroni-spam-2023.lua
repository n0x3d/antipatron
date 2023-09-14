script_name('antipatron')
script_author('shmelev.fan')
script_version('0.1.1-alpha')
script_version_number(2)

local samp = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'

local update_state = false
local update_url = 'https://raw.githubusercontent.com/n0x3d/antipatron/main/update.ini'
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = 'https://raw.githubusercontent.com/n0x3d/antipatron/main/anti-patroni-spam-2023.lua'
local script_path = thisScript().path

local hidden = false
local toggle = false
local warnings = {'(àíòèïàòðîí): Âíèìàíèå! Î÷åðåäíîé åáëîèä, ñêîðåå âñåãî, íà÷àë ôëóä äèàëîãàìè!',
'(àíòèïàòðîí): Íàçàðîâ! Øìåë¸â! Ãäå, ñóêà, ôèêñ ïàòðîíîâ?',
'(àíòèïàòðîí): Ïðèâåò, Òîëü. Çíàþ, òû ðàçî÷àðîâàí â ôëóäå äèàëîãàìè ïåðåäà÷è ïðåäìåòîâ.'}

function main()
	if not isSampLoaded() then return false end
	repeat wait(200) until isSampAvailable()
	sampRegisterChatCommand('unhide', unhide)
	sampRegisterChatCommand('antipatron', antipatron)
	
	sampAddChatMessage('(àíòèïàòðîí): Ñêðèïò íà îáõîä ôëóäà äèàëîãàìè ïîäãðóæåí. Àêòèâàöèÿ {FFFFFF}/antipatron{EAB676}. Àâòîð: {FFFFFF}shmelev.fan{EAB676}.', 0xEAB676)
	
	downloadUrlToFile(update_url, update_path, function (id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.update_info.version_number) > thisScript().version_num then 
				sampAddChatMessage('(àíòèïàòðîí): Îáíàðóæåíî îáíîâëåíèå, âåðñèÿ {FFFFFF}'..updateIni.update_info.version..'{EAB676}.', 0xEAB676)
				update_state = true
			end
			os.remove(update_path)
		end
	end)
	
	while true do 
		wait(0)
		if update_state then
			downloadUrlToFile(script_url, script_path, function (id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
				sampAddChatMessage('(àíòèïàòðîí): Ñêðèïò óñïåøíî îáíîâë¸í äî âåðñèè {FFFFFF}'..updateIni.update_info.version..'{EAB676}.', 0xEAB676)
				thisScript():reload()
			end
		end)
		break
	end
end

function samp.onShowDialog(id, style, title)
	if id == 1018 and title == '{34C924}Âàì ïîñòóïèëî ïðåäëîæåíèå' and toggle and not hidden then
		sampAddChatMessage(warnings[math.random(0,2)], 0xEAB676)
		sampAddChatMessage('(àíòèïàòðîí): Äèàëîã ñêðûò. ×òîáû âåðíóòü åãî ââåäèòå {FFFFFF}/unhide.{EAB676}', 0xEAB676)
		lua_thread.create(function() wait(math.random(100, 300)) sampSetDialogClientside(true) sampCloseCurrentDialogWithButton(1) end)
		hidden = true
	end		
end

function antipatron()
	if not toggle then sampAddChatMessage('(àíòèïàòðîí): Àíòè-ôëóä äèàëîãàìè ïåðåäà÷è {34C924}àêòèâèðîâàí{EAB676}.', 0xEAB676) toggle = true else sampAddChatMessage('(àíòèïàòðîí): Àíòè-ôëóä äèàëîãàìè ïåðåäà÷è {BF0000}äåàêòèâèðîâàí{EAB676}.', 0xEAB676) toggle = false end
end

function unhide()
lua_thread.create(function() if hidden then sampSendDialogResponse(1018, 1, 0, '') sampAddChatMessage('(àíòèïàòðîí): Äèàëîã âîññòàíîâëåí.', 0xEAB676) wait(1000) hidden = false end end)
end
