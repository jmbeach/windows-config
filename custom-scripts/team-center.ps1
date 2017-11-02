function tc-start-4tier-hylatest () {
	explorer "C:\Siemens\TC101YFAITEST\portal\TC101YFAITEST.lnk"
}

function tc-kill-4tier-hylatest () {
	taskkill /f /t /IM Teamcenter.exe
	taskkill /f /t /IM tcserver.exe
	taskkill /f /t /IM ImR_Activator.exe
	taskkill /f /t /IM ImplRepo_Service.exe
	taskkill /f /t /IM VisView.exe
	rm -r C:\Users\j.beach\FCCCache
	rm -r C:\Users\j.beach\Teamcenter
}
