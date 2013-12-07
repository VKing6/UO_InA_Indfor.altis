
	{
		_x addAction["<t color='#ffa200'>Virtual Ammobox</t>", compile preprocessFileLineNumbers "VAS\open.sqf","",1500];
		_x allowDamage false;
	} forEach [ammo1,ammo2,ammo3];