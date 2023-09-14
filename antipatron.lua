script_name('antipatron')
script_author('shmelev.fan')
script_version('0.1.1-alpha')
script_version_number(2)

local samp = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

local update_state = false
local update_url = 'https://raw.githubusercontent.com/n0x3d/antipatron/main/update.ini'
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = 'https://raw.githubusercontent.com/n0x3d/antipatron/main/anti-patroni-spam-2023.lua'
local script_path = thisScript().path

local hidden = false
local toggle = false
local warnings = {'(антипатрон): Внимание! Очередной еблоид, скорее всего, начал флуд диалогами!',
'(антипатрон): Назаров! Шмелёв! Где, сука, фикс патронов?',
'(антипатрон): Привет, Толь. Знаю, ты разочарован в флуде диалогами передачи предметов.'}

function main()
	if not isSampLoaded() then return false end
	repeat wait(200) until isSampAvailable()
	sampRegisterChatCommand('unhide', unhide)
	sampRegisterChatCommand('antipatron', antipatron)
	
	sampAddChatMessage('(антипатрон): Скрипт на обход флуда диалогами подгружен. Активация {FFFFFF}/antipatron{EAB676}. Автор: {FFFFFF}shmelev.fan{EAB676}.', 0xEAB676)
	
	downloadUrlToFile(update_url, update_path, function (id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.update_info.version_number) > thisScript().version_num then 
				sampAddChatMessage('(антипатрон): Обнаружено обновление, версия {FFFFFF}'..updateIni.update_info.version..'{EAB676}.', 0xEAB676)
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
					sampAddChatMessage('(антипатрон): Скрипт успешно обновлён до версии {FFFFFF}'..updateIni.update_info.version..'{EAB676}.', 0xEAB676)
					thisScript():reload()
				end
			end)
			break
		end
	end
end

function samp.onShowDialog(id, style, title)
	if id == 1018 and title == '{34C924}Вам поступило предложение' and toggle and not hidden then
		sampAddChatMessage(warnings[math.random(0,2)], 0xEAB676)
		sampAddChatMessage('(антипатрон): Диалог скрыт. Чтобы вернуть его введите {FFFFFF}/unhide.{EAB676}', 0xEAB676)
		lua_thread.create(function() wait(math.random(100, 300)) sampSetDialogClientside(true) sampCloseCurrentDialogWithButton(1) end)
		hidden = true
	end		
end

function antipatron()
	if not toggle then sampAddChatMessage('(антипатрон): Анти-флуд диалогами передачи {34C924}активирован{EAB676}.', 0xEAB676) toggle = true else sampAddChatMessage('(антипатрон): Анти-флуд диалогами передачи {BF0000}деактивирован{EAB676}.', 0xEAB676) toggle = false end
end

function unhide()
lua_thread.create(function() if hidden then sampSendDialogResponse(1018, 1, 0, '') sampAddChatMessage('(антипатрон): Диалог восстановлен.', 0xEAB676) wait(1000) hidden = false end end)
end
