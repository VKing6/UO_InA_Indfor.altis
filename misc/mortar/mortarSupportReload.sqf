_timer = 300;

while { alive mortarSupport } do
{
	mortarSupport removeMagazines "8Rnd_82mm_Mo_Shells";
	mortarSupport removeMagazines "8Rnd_82mm_Mo_Smoke_white";
	mortarSupport removeMagazines "8Rnd_82mm_Mo_Flare_white";
	[-1, {_this vehicleChat "Mortar magazines removed"}, mortarSupport] call CBA_fnc_globalExecute;
	sleep 1;
	mortarSupport addMagazines ["8Rnd_82mm_Mo_Smoke_white",2];
	mortarSupport addMagazines ["8Rnd_82mm_Mo_Flare_white",4];
	[-1, {_this vehicleChat "Mortar magazines reloaded"}, mortarSupport] call CBA_fnc_globalExecute;
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 20 minutes"}, mortarSupport] call CBA_fnc_globalExecute;	
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 15 minutes"}, mortarSupport] call CBA_fnc_globalExecute;	
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 10 minutes"}, mortarSupport] call CBA_fnc_globalExecute;	
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 5 minutes"}, mortarSupport] call CBA_fnc_globalExecute;	
	sleep _timer;
};