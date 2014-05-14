// #define DEBUG_MODE_FULL
#include "\x\cba\addons\main\script_macros_common.hpp"


PARAMS_1(_vehicle);
private ["_warning","_threatList","_sortedThreatList","_relativeBearing","_clock","_direction","_distance","_range","_show"];
TRACE_1("Starting RWR Script",_vehicle);

_show = false;

while { (player == driver _vehicle || player == gunner _vehicle) && {alive player} && {alive _vehicle} } do {
	TRACE_1("Starting RWR Loop",_vehicle);
	_warning = "<t align='center' size='1.2'>RWR</t><br/>";
	
	_threatList = (getPos _vehicle) nearEntities ["O_APC_Tracked_02_AA_F", 5000];
	_sortedThreatList = [_threatList,[_vehicle],{_x distance _input0},"ASCEND",
		{!(terrainIntersect[
			[(getPosATL _input0) select 0,(getPosATL _input0) select 1, ((getPosATL _input0) select 2)+4],
			[(getPosATL _x) select 0, (getPosATL _x) select 1, ((getPosATL _x) select 2)+2]
		])}
	] call BIS_fnc_sortBy;
	
	if (count _sortedThreatList >= 1) then {
		{
			_relativeBearing = [_vehicle,_x] call BIS_fnc_relativeDirTo;
			if (_relativeBearing < 0) then { _relativeBearing = _relativeBearing + 360 };
			//VK_relBearing = _relativeBearing;
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
				case (_clock <= 2): { "↗ "};
				case (_clock == 3): { "→ " };
				case (_clock <= 5): { "↘ " };
				case (_clock == 6): { "↓ " };
				case (_clock <= 8): { "↙ " };
				case (_clock == 9): { "← " };
				case (_clock <= 11): { "↖ " };
				default { "X " };
			};
			_distance = _vehicle distance _x;
			_range = switch (true) do {
				case (2500 < _distance): { "Far" };
				case (1250 < _distance): { "<t color='#FFFF00'>Medium</t>" }; // && _distance <= 2250
				case (_distance <= 1250): { "<t color='#FF0000'>Close</t>" };
				default { "ERROR" };
			};
			_show = true;
			TRACE_5("",_x,_relativeBearing,_clock,_direction,_range);
			_warning = format ["%1<t align='left'><t color='#BFFF00'>AAA:</t> %2%3 o'clock %4</t><br/>",_warning,_direction,_clock,_range];
			// TRACE_1("",_warning);
		} forEach _sortedThreatList;
		
		TRACE_1("Updating RWR",_vehicle);
		hint parseText _warning;
		
	} else {
		if (_show) then {
			TRACE_1("Clearing RWR",_vehicle);
			hint "";
			_show = false;
		};	
	};
	
	sleep 0.5;
};
hint "";
TRACE_1("Exiting RWR Script",_vehicle);