private ["_obj","_time"];
_obj = _this select 0;
	_time = _this select 1;
	sleep _time;
	deleteVehicle _obj;