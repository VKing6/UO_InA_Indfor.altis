_timer = 300;

while { alive mortarHE } do
{
	mortarHE removeMagazines "8Rnd_82mm_Mo_Smoke_white";
	mortarHE removeMagazines "8Rnd_82mm_Mo_Flare_white";
	mortarHE removeMagazines "8Rnd_82mm_Mo_Shells";
	[-1, {_this vehicleChat "Mortar magazines removed"}, mortarHE] call CBA_fnc_globalExecute;
	sleep 1;
	mortarHE addMagazines ["8Rnd_82mm_Mo_Shells", 5];
	[-1, {_this vehicleChat "Mortar magazines reloaded"}, mortarHE] call CBA_fnc_globalExecute;
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 20 minutes"}, mortarHE] call CBA_fnc_globalExecute;	
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 15 minutes"}, mortarHE] call CBA_fnc_globalExecute;	
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 10 minutes"}, mortarHE] call CBA_fnc_globalExecute;	
	sleep _timer;
	[-1, {_this vehicleChat "Mortar reload in 5 minutes"}, mortarHE] call CBA_fnc_globalExecute;	
	sleep _timer;
};

