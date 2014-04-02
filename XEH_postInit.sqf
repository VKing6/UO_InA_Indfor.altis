	//INDFOR Skins for AH-6 / P-30
	{_x setObjectTextureGlobal [0,"\A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]} forEach allMissionObjects "Heli_Light_01_base_F";
	{_x setObjectTextureGlobal [0,"A3\Air_F\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]} forEach allMissionObjects "Heli_Light_02_base_F";
	{
		_x removeMagazine "2Rnd_GBU12_LGB_MI10";
		_x removeWeapon "GBU12BombLauncher";
		_x addMagazine "38Rnd_80mm_rockets";
		_x addWeapon "rockets_Skyfire";
		_x animate ["AddDar",1];
		_x animate ["AddGbu12",0];
	}	forEach allMissionObjects "I_Plane_Fighter_03_CAS_F";
	
	{
		_x addAction["<t color='#ffa200'>Virtual Ammobox</t>", compile preprocessFileLineNumbers "VAS\open.sqf","",1500];
		_x allowDamage false;
	} forEach [ammo1,ammo2,ammo3];
	
	_cargoCrates = execVM "func\tin_portableCrates.sqf";
	