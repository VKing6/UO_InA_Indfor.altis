
	private ["_canDeleteGroup","_group","_groups","_units"];

	while {true} do {
		sleep 5;
		debugMessage = "Cleaning dead bodies and deleting groups...";
		publicVariable "debugMessage";

		while {count tin_fifo_bodies > 30} do {
			_targetBody = tin_fifo_bodies select 0;
			tin_fifo_bodies = tin_fifo_bodies - [_targetBody];
			deleteVehicle _targetBody;
		};

		debugMessage = "Dead bodies deleted.";
		publicVariable "debugMessage";

		_groups = allGroups;

		for "_c" from 0 to ((count _groups) - 1) do {
			_canDeleteGroup = true;
			_group = (_groups select _c);
			if (!isNull _group) then {
				_units = (units _group);
				{
					if (alive _x) then { _canDeleteGroup = false; };
				} forEach _units;
			};
			if (_canDeleteGroup && !isNull _group) then { deleteGroup _group; };
		};

		debugMessage = "Empty groups deleted.";
		publicVariable "debugMessage";
	};