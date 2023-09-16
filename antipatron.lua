script_name('antipatron')
script_author('shmelev.fan')
script_version('0.1.3-alpha')
script_version_number(4)

local samp = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

local update_state = false
local update_url = 'https://raw.githubusercontent.com/n0x3d/antipatron/main/update.ini'
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = 'https://raw.githubusercontent.com/n0x3d/antipatron/main/antipatron.lua'
local script_path = thisScript().path

local hidden = false
local toggle = false
local warnings = {'(����������): ��������! ��������� �����, ������ �����, ����� ���� ���������!',
'(����������): �������! �����! ���, [�������], ���� ��������?',
'(����������): ������, ����. ����, �� ����������� � ����� ��������� �������� ���������.'}

function main()
	if not isSampLoaded() then return false end
	repeat wait(200) until isSampAvailable()
	sampRegisterChatCommand('unhide', function() lua_thread.create(function() if hidden then sampSendDialogResponse(1018, 0, 0, '') sampAddChatMessage('(����������): ������ ������.', 0xEAB676) wait(500) hidden = false end end) end)
	sampRegisterChatCommand('antipatron', function() if not toggle then sampAddChatMessage('(����������): ����-���� ��������� �������� {34C924}�����������{EAB676}.', 0xEAB676) toggle = true else sampAddChatMessage('(����������): ����-���� ��������� �������� {BF0000}�������������{EAB676}.', 0xEAB676) toggle = false end end)
	
	sampAddChatMessage('(����������): ������ �� ����� ����� ��������� ���������. ��������� {FFFFFF}/antipatron{EAB676}. �����: {FFFFFF}shmelev.fan{EAB676}.', 0xEAB676)
	
	downloadUrlToFile(update_url, update_path, function (id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.update_info.version_number) > thisScript().version_num then 
				sampAddChatMessage('(����������): ���������� ����������, ������ {FFFFFF}'..updateIni.update_info.version..'{EAB676}.', 0xEAB676)
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
					sampAddChatMessage('(����������): ������ ������� ������� �� ������ {FFFFFF}'..updateIni.update_info.version..'{EAB676}.', 0xEAB676)
					thisScript():reload()
				end
			end)
			break
		end
	end
end

function samp.onShowDialog(id, style, title)
	if hidden then hidden = not hidden sampAddChatMessage('(����������): ������ ������� ��� ������ ������. ���������� ������ ������ �������������.', 0xEAB676) end
	if id == 1018 and title == '{34C924}��� ��������� �����������' and toggle then
		sampAddChatMessage(warnings[math.random(1,3)], 0xEAB676)
		sampAddChatMessage('(����������): ������ �����. ����� ������� ��� ������� {FFFFFF}/unhide.{EAB676}', 0xEAB676)
		lua_thread.create(function() wait(math.random(50, 100)) sampSetDialogClientside(true) sampCloseCurrentDialogWithButton(1) end)
		hidden = true
	end		
end

function samp.onSendSpawn()
	if hidden then hidden = not hidden sampAddChatMessage('(����������): �� ������. ���������� ������ ������ �������������.', 0xEAB676) end
end