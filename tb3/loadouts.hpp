	class TB3_Gear {
		class ExampleSide {
			class ExampleUnit {
				weapons[] = {"arifle_Mk20_F"};
				magazines[] = {	}; //do not use if using specific allocation of magazines
				backpack[] = {"B_Kitbag_sgg"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"30Rnd_556x45_Stanag_Tracer_Yellow",1},
						{"HandGrenade",2},
						{"SmokeShell",1},
						{"Chemlight_green",5}
					};
					backpackItems[] = {
						{"NVGoggles_INDEP",1},
						{"acc_pointer_IR",1}
					};
				headgear[] = {"H_HelmetIA_net"};
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {{"30Rnd_556x45_Stanag",1}};
					uniformItems[] = {
						{"FirstAidKit",2},
						{"H_Booniehat_indp",1}
					};
				goggles[] = {"G_Lowprofile"};
				vest[] = {"V_PlateCarrier3_rgr"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",6},
						{"30Rnd_556x45_Stanag_Tracer_Yellow",2},
						{"HandGrenade",2},
						{"SmokeShell",1}
					};
					vestItems[] = {
						{"ACRE_PRC148",1}
					};
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass",	"ItemWatch","ItemGPS","Binocular"};
				items[] = {	}; //do not use if using specific allocation of items
				
				priKit[] = {"optic_MRCO"};
				secKit[] = {};
			};
			class ExampleVehicle {
				vehCargoWeapons[] = {{"launch_NLAW_F",8}};
				vehCargoMagazines[] = {
					{"30Rnd_556x45_Stanag",20},
					{"30Rnd_556x45_Stanag_Tracer_Yellow",20},
					{"200Rnd_65x39_cased_Box",4},
					{"200Rnd_65x39_cased_Box_Tracer",4},
					{"HandGrenade",12},
					{"SmokeShell",12},
					{"1Rnd_HE_Grenade_shell",20}
				};
				vehCargoItems[] = {
					{"FirstAidKit",15},
					{"Medikit",1},
					{"I_UavTerminal",1},
					{"ToolKit",1}
				};
				vehCargoRucks[] = {
					{"B_Kitbag_sgg",15}
				};
			};
		};
		class INDinf {
			class PL {
				weapons[] = {"tb_arifle_mk21_m203","Rangefinder"};
				priKit[] = {"optic_Hamr","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_net"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA2_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",5},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"1Rnd_HE_Grenade_shell",7},
						{"1Rnd_SmokeRed_Grenade_shell",2},
						{"1Rnd_SmokeGreen_Grenade_shell",2},
						{"HandGrenade",2},
						{"Chemlight_green",4},
						{"I_IR_Grenade",1}
					};
					vestItems[] = {
						{"FirstAidKit",1}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",6},
						{"30Rnd_556x45_Stanag_Tracer_Red",2},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"SmokeShellRed",2},
						{"SmokeShellGreen",2},
						{"I_IR_Grenade",1},
						{"1Rnd_SmokeRed_Grenade_shell",2},
						{"1Rnd_HE_Grenade_shell",6},
						{"Chemlight_green",6}
					};
					backpackItems[] = {
						{"FirstAidKit",2}
					};
					
				magazines[] = {}; items[] = {};
			};
			class PSG {
				weapons[] = {"tb_arifle_mk21","Rangefinder","launch_NLAW_F"};
				priKit[] = {"optic_Hamr","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform_shortsleeve"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA2_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",6},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"HandGrenade",3},
						{"SmokeShell",3},
						{"Chemlight_green",4},
						{"I_IR_Grenade",1}
					};
					vestItems[] = {
						{"FirstAidKit",1}
					};
					
				backpack[] = {"B_AssaultPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",6},
						{"30Rnd_556x45_Stanag_Tracer_Red",2},
						{"HandGrenade",3},
						{"SmokeShellRed",3},
						{"SmokeShellGreen",3},
						{"I_IR_Grenade",1},
						{"Chemlight_green",6}
					};
					backpackItems[] = {
						{"FirstAidKit",2}
					};
					
				magazines[] = {}; items[] = {};
			};
			class FAC1 {
				weapons[] = {"tb_arifle_mk21_m203","Laserdesignator"};
				priKit[] = {"optic_Hamr","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_net"};
				goggles[] = {"G_Tactical_Clear"};
				
				uniform[] = {"U_I_CombatUniform_shortsleeve"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA1_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",5},
						{"30Rnd_556x45_Stanag_Tracer_Red",2},
						{"1Rnd_HE_Grenade_shell",6},
						{"1Rnd_SmokeRed_Grenade_shell",2},
						{"HandGrenade",2},
						{"Chemlight_green",4},
						{"I_IR_Grenade",1},
						{"Laserbatteries",1}
					};
					vestItems[] = {
						{"FirstAidKit",1},
						{"I_UavTerminal",1},
						{"ACRE_PRC148_UHF",1}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",5},
						{"30Rnd_556x45_Stanag_Tracer_Red",2},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"SmokeShellRed",2},
						{"SmokeShellGreen",2},
						{"SmokeShellYellow",2},
						{"I_IR_Grenade",2},
						{"1Rnd_SmokeRed_Grenade_shell",2},
						{"1Rnd_SmokeGreen_Grenade_shell",2},
						{"1Rnd_SmokePurple_Grenade_shell",2},
						{"Chemlight_green",6}
					};
					backpackItems[] = {
						{"FirstAidKit",2}
					};
					
				magazines[] = {}; items[] = {};
			};
			class FAC2 {
				weapons[] = {"tb_arifle_mk21","Laserdesignator"};
				priKit[] = {"optic_Hamr","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_camo"};
				goggles[] = {"G_Tactical_Clear"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA1_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",8},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"SmokeShellGreen",2},
						{"Chemlight_green",4},
						{"I_IR_Grenade",1},
						{"Laserbatteries",1}
					};
					vestItems[] = {
						{"FirstAidKit",1},
						{"I_UavTerminal",1},
						{"ACRE_PRC148_UHF",1}
					};
					
				backpack[] = {"I_UAV_01_backpack_F"};
					backpackMagazines[] = {};
					backpackItems[] = {};
					
				magazines[] = {}; items[] = {};
			};
			class Pio {
				weapons[] = {"tb_arifle_mk21"};
				priKit[] = {"optic_Holosight","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIAGL_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",8},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"HandGrenade",3},
						{"SmokeShell",2},
						{"Chemlight_green",4},
						{"Chemlight_red",6}
					};
					vestItems[] = {
						{"FirstAidKit",1}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",2},
						{"SmokeShellRed",2},
						{"SatchelCharge_Remote_Mag",2},
						{"Chemlight_green",4}
					};
					backpackItems[] = {
						{"FirstAidKit",1},
						{"MineDetector",1}
					};
					
				magazines[] = {}; items[] = {};
			};
			class PCLS {
				weapons[] = {"tb_arifle_mk21"};
				priKit[] = {"optic_Holosight","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_camo"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA2_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",8},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"Chemlight_green",4},
						{"Chemlight_blue",4},
						{"I_IR_Grenade",1}
					};
					vestItems[] = {
						{"FirstAidKit",2}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",4},
						{"SmokeShellYellow",2},
						{"SmokeShellGreen",2}
					};
					backpackItems[] = {
						{"FirstAidKit",22}
					};
					
				magazines[] = {}; items[] = {};
			};
			
			class SL {
				weapons[] = {"tb_arifle_mk21_m203","Rangefinder"};
				priKit[] = {"optic_Hamr","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_net"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA2_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",5},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"1Rnd_HE_Grenade_shell",7},
						{"1Rnd_SmokeRed_Grenade_shell",2},
						{"1Rnd_SmokeGreen_Grenade_shell",2},
						{"HandGrenade",2},
						{"Chemlight_green",4},
						{"I_IR_Grenade",1}
					};
					vestItems[] = {
						{"FirstAidKit",1}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",6},
						{"30Rnd_556x45_Stanag_Tracer_Red",2},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"SmokeShellGreen",2},
						{"1Rnd_HE_Grenade_shell",6},
						{"Chemlight_green",4},
						{"tb_100Rnd_556x45_box_tracer_red",1}
					};
					backpackItems[] = {
						{"FirstAidKit",2}
					};
					
				magazines[] = {}; items[] = {};
			};
			class TL {
				weapons[] = {"tb_arifle_mk21_m203","Rangefinder"};
				priKit[] = {"optic_Hamr","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_net"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1},
						{"ACRE_PRC148",1}
					};
					
				vest[] = {"V_PlateCarrierIA2_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",5},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"1Rnd_HE_Grenade_shell",7},
						{"1Rnd_SmokeRed_Grenade_shell",2},
						{"1Rnd_SmokeGreen_Grenade_shell",2},
						{"HandGrenade",2},
						{"Chemlight_green",4},
						{"I_IR_Grenade",1}
					};
					vestItems[] = {
						{"FirstAidKit",1}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",6},
						{"30Rnd_556x45_Stanag_Tracer_Red",2},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"SmokeShellGreen",2},
						{"1Rnd_HE_Grenade_shell",6},
						{"Chemlight_green",4},
						{"tb_100Rnd_556x45_box_tracer_red",1}
					};
					backpackItems[] = {
						{"FirstAidKit",2}
					};
					
				magazines[] = {}; items[] = {};
			};
			class CLS {
				weapons[] = {"tb_arifle_mk21"};
				priKit[] = {"optic_Holosight","acc_pointer_IR"};
				secKit[] = {};
				
				assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS","NVGoggles_INDEP"};
				
				headgear[] = {"H_HelmetIA_camo"};
				goggles[] = {"G_Shades_Black"};
				
				uniform[] = {"U_I_CombatUniform"};
					uniformMagazines[] = {
						{"30Rnd_556x45_Stanag",3},
						{"SmokeShell",2},
						{"Chemlight_green",2}
					};
					uniformItems[] = {
						{"FirstAidKit",1}
					};
					
				vest[] = {"V_PlateCarrierIA2_dgtl"};
					vestMagazines[] = {
						{"30Rnd_556x45_Stanag",8},
						{"30Rnd_556x45_Stanag_Tracer_Red",1},
						{"HandGrenade",2},
						{"SmokeShell",2},
						{"Chemlight_green",4},
						{"Chemlight_blue",4},
						{"I_IR_Grenade",1}
					};
					vestItems[] = {
						{"FirstAidKit",2}
					};
					
				backpack[] = {"B_TacticalPack_blk"};
					backpackMagazines[] = {
						{"30Rnd_556x45_Stanag",4},
						{"SmokeShellYellow",2},
						{"SmokeShellGreen",2}
					};
					backpackItems[] = {
						{"FirstAidKit",22}
					};
					
				magazines[] = {}; items[] = {};
			};
			class AR {};
			class R {};
			
			class VC {};
			
			class Pilot {};
		};	
	};