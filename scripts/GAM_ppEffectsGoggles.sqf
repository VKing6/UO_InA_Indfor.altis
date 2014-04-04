/*			GAM ppEffects Goggles v1.10
					by gamma

Description:
	- Implements lens tinting to available Goggles and Glasses
				  
Install:
	Mod version:
		- Copy folders "@GAM" and "userconfig" inside zip to your MAIN Arma 3 directory
		- Add "-mod=@GAM" to your Arma 3 shortcut
		- Open "userconfig\GAM\GAM_PPEG.hpp" to customize your options

	Mission version:
		- Copy 'GAM_ppEffectsGoggles.sqf' to the mission folder
		- Include the following code in your mission "init.sqf":

// makes sure it is not already running as a mod
if (isNil {GAM_ppEffectsGoggles}) then {GAM_ppEffectsGoggles = compile preProcessFileLineNumbers 'GAM_ppEffectsGoggles.sqf'; GAM_ppEffectsGogglesInit = [true, false, 10] spawn GAM_ppEffectsGoggles};

		GAM_ppEffectsGoggles Parameters
		[_withmenu, _enableExternal, _eyeAdapt]
		[boolean, boolean, number (seconds)]

Usage:
	- Access the menu to change goggles/glasses
	  This is to facilitate experimentation since it is hard to fill an ammo crate
	  with the available glasses/goggles (can be disabled)
  
Features:
	- Affects the colouring of the screen depending on the lens used by the Goggles/Glasses
	- Detects removal and disables the effect
	- The effect is disabled on 3rd Person views
	- Simulates (exaggerates) the effect of eye adaptation when wearing and removing (10 seconds)
	- Includes key

Observations:
	- Script runs client side only
	- Script runs in a tight loop, waiting for an event based solution when able
	  currently "take" and "put" EHs are insufficient for all functionality
	- Goggles removal colour settings are mostly wip

*********************************
**** LICENSE CC BY-NC-SA 3.0 ****
Creative Commons Attribution-Non-Commercial-Share Alike 3.0 License

READ The Full License - http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
The following is a human-readable summary of the Legal Code.

You are free:
	to Share — to copy, distribute and transmit the work
	to Remix — to adapt the work

Under the following conditions:
	Attribution — You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
	Noncommercial — You may not use this work for commercial purposes.
	Share Alike — If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
	
With the understanding that:
	Waiver — Any of the above conditions can be waived if you get permission from the copyright holder.
	Public Domain — Where the work or any of its elements is in the public domain under applicable law, that status is in no way affected by the license.
	Other Rights — In no way are any of the following rights affected by the license:
		- Your fair dealing or fair use rights, or other applicable copyright exceptions and limitations;
		- The author's moral rights;
		- Rights other persons may have either in the work itself or in how the work is used, such as publicity or privacy rights.

*********************************
*/
if (isDedicated) exitWith {};

// Parameters
_withMenu = _this select 0;
_enableExternal = _this select 1; 
_eyeAdapt = _this select 2;

// Create Menu to allow in-mission choosing of Glasses/Goggles
// Main functionality does not depend on this menu and can be disabled
if (_withMenu) then {
	GAM_menuGoggles = {
		_actions = [];
		_action = player addAction ["Choose Goggles", {{player removeAction _x} forEach ((_this select 3) select 0); _nil = [] call GAM_menuChooseGoggles}, [_actions], 0, false];
		_actions set [count _actions, _action];
	};
	GAM_menuChooseGoggles = {
		_gogglesClass = [[
			"G_Diving", "G_Shades_Black", "G_Shades_Blue", "G_Sport_Blackred",
			"G_Tactical_Clear", "G_Spectacles", "G_Spectacles_Tinted", "G_Combat",
			"G_Lowprofile", "G_Shades_Green", "G_Shades_Red", "G_Squares",
			"G_Squares_Tinted", "G_Sport_BlackWhite", "G_Sport_Blackyellow", "G_Sport_Greenblack",
			"G_Sport_Checkered", "G_Sport_Red", "G_Tactical_Black", "G_Aviator",
			"G_Lady_Mirror", "G_Lady_Dark", "G_Lady_Red", "G_Lady_Blue"
		],
		/*GAM_gogglesName = */[
			"Diving Goggles", "Shades (Black)", "Shades (Blue)", "Shades (Vulcan)",
			"Tactical Glasses", "Spectacle Glasses", "Tinted Spectacles", "Combat Goggles",
			"Low Profile Goggles", "Shades (Green)", "Shades (Red)", "Square Spectacles",
			"Square Shades", "Sport Shades (Shadow)", "Sport Shades (Poison)", "Sport Shades (Yetti)",
			"Sport Shades (Style)", "Sport Shades (Fire)", "Tactical Shades", "Aviator Glasses",
			"Ladies Shades (Iridium)", "Ladies Shades (Sea)", "Fanboy Magical Rose Colored Glasses"/*"Ladies Shades (Fire)"*/, "Ladies Shades (Ice)"
		]];
		_actions = [];
		_i = 0;
		{
			_action = player addAction [(_gogglesClass select 1) select _i, {{player removeAction _x} forEach ((_this select 3) select 1); _menu = [] call GAM_menuGoggles; player addGoggles ((_this select 3) select 0)}, [_x, _actions], 0, false];
			_actions set [count _actions, _action];
			_i = _i + 1;
		} forEach (_gogglesClass select 0);
	};
	_menu = [] call GAM_menuGoggles;
};

// Main Post Process Effect Function
GAM_setGogglesEffect = {
	player setVariable ["GogglesOn", true];
	if (isNil {player getVariable "Goggles"}) then {player setVariable ["Goggles", ["Init", [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], [0.199, 0.587, 0.114, 0.0]], ["INTERNAL", "GUNNER"]]]};
	
	_ppCCBase = [0.199, 0.587, 0.114, 0.0];
	_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
	_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
	_ppCCRemove = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];

	if (cameraView in GAM_cameraViewsOn) then {
		switch (goggles player) do {
			case "": {						//"" 						- none			 				- NEUTRAL
				player setVariable ["GogglesOn", false];
				_ppCCIn = (player getVariable "Goggles") select 1;
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Diving": {				//"Diving Goggles" 			- icon_G_Diving_CA 				- NEUTRAL + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.6, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.1], [1.4, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.0, 0.4, 0.1], [0.6, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Shades_Black": {		//"Shades (Black)" 			- icon_g_shades_black_CA 		- DARK NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.4, 0.4, 0.4, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Shades_Blue": {			//"Shades (Blue)" 			- icon_g_shades_blue_CA 		- DARK + BLUE + RED
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [0.8, 0.4, 1.6, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 0.6, 1.4, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.2, 0.4, 0.0, 0.2], [1.0, 1.4, 0.6, 0.6], _ppCCBase];
			};
			case "G_Sport_Blackred": {		//"Shades (Vulcan)"			- icon_g_sport_blackred_CA 		- DARK + RED + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.6, 0.8, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.4, 1.0, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.2, 0.4, 0.2], [0.6, 1.0, 1.4, 0.6], _ppCCBase];
			};
			case "G_Tactical_Clear": {		//"Tactical Glasses"		- icon_g_tactical_CA 			- NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.1], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.2, 0.2, 0.2, 0.1], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Spectacles": {			//"Spectacle Glasses" 		- icon_g_spectacles_CA 			- NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.1], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.2, 0.2, 0.2, 0.1], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Spectacles_Tinted": {	//"Tinted Spectacles"		- icon_g_spectacles_tinted_CA	- DARK + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.6, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.4, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.0, 0.8, 0.2], [0.6, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Combat": {				//"Combat Goggles"			- icon_g_combat_CA				- DARK + LIGHTYELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.4, 1.4, 0.6, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.2, 1.2, 0.8, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.0, 0.4, 0.2], [0.8, 0.8, 1.2, 0.6], _ppCCBase];
			};
			case "G_Lowprofile": {			//"Low Profile Goggles"		- icon_g_lowprofile_CA			- DARK NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.4, 0.4, 0.4, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Shades_Green": {		//"Shades (Green)"			- icon_g_shades_green_CA		- DARK + GREEN + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [0.8, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.2, 0.0, 0.4, 0.2], [1.0, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Shades_Red": {			//"Shades (Red)"			- icon_g_shades_red_CA			- DARK + RED + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.6, 0.8, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.4, 1.0, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.2, 0.4, 0.2], [0.6, 1.0, 1.4, 0.6], _ppCCBase];
			};
			case "G_Squares": {				//"Square Spectacles"		- icon_g_squares_CA				- NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.1], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.2, 0.2, 0.2, 0.1], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Squares_Tinted": {		//"Square Shades"			- icon_g_squares_CA				- DARK + GREEN
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [0.4, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [0.6, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.4, 0.0, 0.4, 0.2], [1.4, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Sport_BlackWhite": {	//"Sport Shades (Shadow)"	- icon_g_sport_blackwhite_CA	- DARK + BLUE + GREEN
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [0.4, 0.8, 1.6, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [0.6, 1.0, 1.4, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.6, 0.2, 0.0, 0.2], [1.4, 1.0, 0.6, 0.6], _ppCCBase];
			};
			case "G_Sport_Blackyellow": {	//"Sport Shades (Poison)"	- icon_g_sport_blackyellow_CA	- DARK + YELLOW + GREEN
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.4, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.2, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.2, 0.0, 0.6, 0.2], [1.2, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Sport_Greenblack": {	//"Sport Shades (Yetti)"	- icon_g_sport_greenblack_CA	- DARK + GREEN + BLUE
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [0.4, 1.6, 1.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [0.6, 1.4, 1.2, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.6, 0.0, 0.2, 0.2], [1.4, 0.6, 1.2, 0.6], _ppCCBase];
			};
			case "G_Sport_Checkered": {		//"Sport Shades (Style)"	- icon_g_sport_checkered_CA		- DARK + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.6, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.4, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.0, 0.8, 0.2], [0.6, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Sport_Red": {			//"Sport Shades (Fire)"		- icon_g_sport_red_CA			- DARK NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.4, 0.4, 0.4, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Tactical_Black": {		//"Tactical Shades"			- icon_g_tactical_CA			- DARK NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.4, 0.4, 0.4, 0.2], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Aviator": {				//"Aviator Glasses"			- icon_g_aviators_ca			- DARK + YELLOW
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.4], [1.6, 1.6, 0.4, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.2], [1.4, 1.4, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.0, 0.8, 0.2], [0.6, 0.6, 1.4, 0.6], _ppCCBase];
			};
			case "G_Lady_Mirror": {			//"Ladies Shades (Iridium)"	- icon_g_lady_ca				- DARK NEUTRAL
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.5], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.3], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.3, 0.3, 0.3, 0.3], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			};
			case "G_Lady_Dark": {			//"Ladies Shades (Sea)"		- icon_g_lady_ca				- DARK + GREEN
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.5], [0.8, 2.0, 0.8, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.3], [0.6, 1.6, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.5, 0.0, 0.5, 0.3], [1.6, 0.6, 1.6, 0.6], _ppCCBase];
			};
			case "G_Lady_Red": {			//"Ladies Shades (Fire)"	- icon_g_lady_ca				- DARK + RED
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.5], [2.0, 0.8, 0.8, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.3], [1.6, 0.6, 0.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.0, 0.5, 0.5, 0.3], [0.6, 1.6, 1.6, 0.6], _ppCCBase];
			};
			case "G_Lady_Blue": {			//"Ladies Shades (Ice)"		- icon_g_lady_ca				- DARK + BLUE
				_ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.5], [0.8, 0.8, 2.0, 0.4], _ppCCBase];
				_ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.3], [0.6, 0.6, 1.6, 0.6], _ppCCBase];
				_ppCCRemove = [1, 1, 0, [0.5, 0.5, 0.0, 0.3], [1.6, 1.6, 0.6, 0.6], _ppCCBase];
			};
		};
		player setVariable ["Goggles", [(goggles player), _ppCCRemove, ["EXTERNAL", "GROUP"]]];
		// Initial Color
		"colorCorrections" ppEffectAdjust _ppCCIn;
		"colorCorrections" ppEffectCommit 0.3;
		"colorCorrections" ppEffectEnable true;
		sleep 0.3;
		
		// Eye Adaptation
		"colorCorrections" ppEffectAdjust _ppCCOut;
		"colorCorrections" ppEffectCommit _eyeAdapt;
		"colorCorrections" ppEffectEnable true;
	} else {
		player setVariable ["Goggles", [(goggles player), (player getVariable "Goggles") select 1, ["INTERNAL", "GUNNER"]]];
		"colorCorrections" ppEffectAdjust _ppCCIn;
		"colorCorrections" ppEffectCommit 0.3;
		"colorCorrections" ppEffectEnable true;
	};
};

// Loop checking for Goggles and View changes (effect is disabled when in 3rd Person)
GAM_cameraViewsOn = ["INTERNAL", "GUNNER"];
GAM_checkLoop = {
	while {true} do {
		_nil = [] call GAM_setGogglesEffect;
		waitUntil {(goggles player != (player getVariable "Goggles") select 0) or (cameraView in ((player getVariable "Goggles") select 2))};
	};
};
if (_enableExternal) then {
	GAM_cameraViewsOn = ["INTERNAL", "GUNNER", "EXTERNAL", "GROUP"];
	GAM_checkLoop = {
		while {true} do {
			_nil = [] call GAM_setGogglesEffect;
			waitUntil {(goggles player != (player getVariable "Goggles") select 0)};
		};
	};
};
waitUntil {!(isNull (findDisplay 46))};
_loop = [] call GAM_checkLoop;

