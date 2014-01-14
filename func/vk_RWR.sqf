// #define DEBUG_MODE_FULL
#include "\x\cba\addons\main\script_macros_common.hpp"

PARAMS_1(_vehicle);
private ["_warning","_threatList","_relativeBearing","_clock","_direction","_distance","_range"];
while { (player == driver _vehicle || player == gunner _vehicle) && {alive player} && {alive _vehicle} } do {
	_warning = "";
	_threatList = (getPos _vehicle) nearEntities ["O_APC_Tracked_02_AA_F", 3500];
	{
		if !(terrainIntersect[getPosATL _vehicle,getPosATL _x]) then {
			_relativeBearing = [_vehicle,_x] call BIS_fnc_relativeDirTo;
			_clock = switch (true) do {
				case ((345 < _relativeBearing) || (_relativeBearing <= 15)): { 12 };
				case (15 < _relativeBearing && _relativeBearing <= 45): { 1 };
				case (45 < _relativeBearing && _relativeBearing <= 75): { 2 };
				case (75 < _relativeBearing && _relativeBearing <= 105): { 3 };
				case (105 < _relativeBearing && _relativeBearing <= 135): { 4 };
				case (135 < _relativeBearing && _relativeBearing <= 165): { 5 };
				case (165 < _relativeBearing && _relativeBearing <= 195): { 6 };
				case (195 < _relativeBearing && _relativeBearing <= 225): { 7 };
				case (225 < _relativeBearing && _relativeBearing <= 255): { 8 };
				case (255 < _relativeBearing && _relativeBearing <= 285): { 9 };
				case (285 < _relativeBearing && _relativeBearing <= 315): { 10 };
				case (315 < _relativeBearing && _relativeBearing <= 345): { 11 };
				default { 88 };
			};
			_direction = switch (true) do {
				case (_clock == 12): { "↑ " };
				case (_clock < 6): { "→ " };
				case (_clock > 6): { "← " };
				default { "↓ " };
			};
			_distance = _vehicle distance _x;
			_range = switch (true) do {
				case (_distance <= 1000): { "Close" };
				case (1000 < _distance || _distance <= 2000): { "Medium" };
				case (2000 < _distance): { "Far" };
			};
			
			TRACE_5("",_x,_relativeBearing,_clock,_direction,_range);
			// _warning = _warning+ "AAA: "+_direction+_clock+" o'clock\n";
			_warning = format ["%1AAA: %2%3 o'clock %4\n",_warning,_direction,_relativeBearing,_range];
			TRACE_1("",_warning);
		};
	} forEach _threatList;
	// _vehicle vehicleChat format["%1",_warning];
	player sideChat _warning;
	// if (player == driver _vehicle) then {
		hint format ["%1",_warning];
	// };
	sleep 0.25;
};