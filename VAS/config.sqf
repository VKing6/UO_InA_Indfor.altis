//Allow player to respawn with his loadout? If true unit will respawn with all ammo from initial save! Set to false to disable this and rely on other scripts!
vas_onRespawn = true;
//Preload Weapon Config?
vas_preload = true;
//If limiting weapons its probably best to set this to true so people aren't loading custom loadouts with restricted gear.
vas_disableLoadSave = false;
//Amount of save/load slots
vas_customslots = 19; //9 is actually 10 slots, starts from 0 to whatever you set, so always remember when setting a number to minus by 1, i.e 12 will be 11.
//Disable 'VAS hasn't finished loading' Check !!! ONLY RECOMMENDED FOR THOSE THAT USE ACRE AND OTHER LARGE ADDONS !!!
vas_disableSafetyCheck = false;
/*
	NOTES ON EDITING!
	YOU MUST PUT VALID CLASS NAMES IN THE VARIABLES IN AN ARRAY FORMAT, NOT DOING SO WILL RESULT IN BREAKING THE SYSTEM!
	PLACE THE CLASS NAMES OF GUNS/ITEMS/MAGAZINES/BACKPACKS/GOGGLES IN THE CORRECT ARRAYS! TO DISABLE A SELECTION I.E
	GOGGLES vas_goggles = [""]; AND THAT WILL DISABLE THE ITEM SELECTION FOR WHATEVER VARIABLE YOU ARE WANTING TO DISABLE!
	
														EXAMPLE
	vas_weapons = ["srifle_EBR_ARCO_point_grip_F","arifle_Khaybar_Holo_mzls_F","arifle_TRG21_GL_F","Binocular"];
	vas_magazines = ["30Rnd_65x39_case_mag","20Rnd_762x45_Mag","30Rnd_65x39_caseless_green"];
	vas_items = ["ItemMap","ItemGPS","NVGoggles"];
	vas_backpacks = ["B_Bergen_sgg_Exp","B_AssaultPack_rgr_Medic"];
	vas_goggles = [""];				

												Example for side specific (TvT)
	switch(playerSide) do
	{
		//Blufor
		case west:
		{
			vas_weapons = ["srifle_EBR_F","arifle_MX_GL_F"];
			vas_items = ["muzzle_snds_H","muzzle_snds_B","muzzle_snds_L","muzzle_snds_H_MG"]; //Removes suppressors from VAS
			vas_goggles = ["G_Diving"]; //Remove diving goggles from VAS
		};
		//Opfor
		case west:
		{
			vas_weapons = ["srifle_EBR_F","arifle_MX_GL_F"];
			vas_items = ["muzzle_snds_H","muzzle_snds_B","muzzle_snds_L","muzzle_snds_H_MG"]; //Removes suppressors from VAS
			vas_goggles = ["G_Diving"]; //Remove diving goggles from VAS
		};
	};
*/

//If the arrays below are empty (as they are now) all weapons, magazines, items, backpacks and goggles will be available
//Want to limit VAS to specific weapons? Place the classnames in the array!
vas_weapons = [
	// Binoculars
	"Binocular","Laserdesignator","Rangefinder",
	// Rifles
	


	
	
	"tb_arifle_mk21","tb_arifle_mk21c","tb_arifle_mk21_m203","tb_arifle_mk21c_m203","arifle_Mk20_F","arifle_Mk20C_F","arifle_Mk20_GL_F","arifle_Mk20_black_F","arifle_Mk20C_black_F","arifle_Mk20_GL_black_F","arifle_TRG20_F","arifle_TRG21_F","arifle_TRG21_GL_F","tb_lmg_mk23","tb_lmg_mk24","tb_sgun_m1014","srifle_EBR_F","arifle_SDAR_F","SMG_01_F","SMG_02_F","hgun_PDW2000_F",
	// Pistols
	"hgun_P07_F","hgun_Rook40_F","hgun_ACPC2_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F",
	// Launchers
	"launch_NLAW_F","TMR_launch_NLAW_MPV_F","launch_I_Titan_short_F","launch_I_Titan_F","tb_launcher_mk13"
];
//Want to limit VAS to specific magazines? Place the classnames in the array!
vas_magazines = [
	// Rifle Magazines
	"30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Yellow","20Rnd_556x45_UW_mag","20Rnd_762x51_Mag","tb_100Rnd_556x45_box","tb_100Rnd_556x45_box_tracer_yellow","150Rnd_762x51_Box","tb_150Rnd_762x51_Box_Tracer_yellow","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01_Tracer_Green","tb_8Rnd_12ga_slug","tb_8Rnd_12ga_buck",
	// Pistol Magazines
	"30Rnd_9x21_Mag","16Rnd_9x21_Mag","9Rnd_45ACP_Mag",
	// GL Magazines
	"1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F","UGL_FlareCIR_F",
	// Launcher Magazines
	"Titan_AA","Titan_AP","Titan_AT","tb_mk13_heat","tb_mk13_hedp","tb_mk13_smoke",
	// Thrown
	"HandGrenade","MiniGrenade","SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellYellow","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue","I_IR_Grenade",
	// Put
	"ATMine_Range_Mag","APERSMine_Range_Mag","APERSBoundingMine_Range_Mag","SLAMDirectionalMine_Wire_Mag","APERSTripMine_Wire_Mag","ClaymoreDirectionalMine_Remote_Mag","SatchelCharge_Remote_Mag","DemoCharge_Remote_Mag","Laserbatteries"
];
//Want to limit VAS to specific items? Place the classnames in the array!
vas_items = [
	// NV Goggles
	"NVGoggles_INDEP",
	// Items 
	"FirstAidKit","I_UavTerminal","ItemCompass","ItemGPS","ItemMap","ItemRadio","ACRE_PRC148","ACRE_PRC119","ACRE_PRC117F","ItemWatch","Medikit","MineDetector","ToolKit",
	// Accsessories
	"tb_acc_c79","tb_acc_m145","tb_acc_commp4","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","optic_Arco","optic_MRCO","optic_Hamr","optic_DMS","optic_LRPS","optic_MRD","optic_NVS","optic_Yorris","acc_flashlight","acc_pointer_IR","tmr_acc_bipod","muzzle_snds_acp","muzzle_snds_L","muzzle_snds_M","tmr_muzzle_snds_L_smg","tmr_muzzle_snds_acp_smg","tb_acc_suppressorLMG556","tb_acc_suppressorLMG762",
	// Uniforms
	"U_I_CombatUniform","U_I_CombatUniform_shortsleeve","U_I_CombatUniform_tshirt","U_I_GhillieSuit","U_I_HeliPilotCoveralls","U_I_pilotCoveralls","U_I_Wetsuit",
	// Vests
	"V_BandollierB_rgr","V_BandollierB_blk","V_Chestrig_blk","V_Chestrig_oli","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_PlateCarrier_NOR_M98","V_PlateCarrier1_blk","V_RebreatherIA","V_TacVest_oli","V_TacVest_FR_black",
	// Helmets
	"H_Booniehat_dgtl","H_CrewHelmetHeli_I","H_HelmetB","H_HelmetB_camo","H_HelmetB_grass","H_HelmetB_light","H_HelmetB_nor_m98","H_HelmetB_ru_oli","H_HelmetCrew_I","H_HelmetIA","H_HelmetIA_camo","H_HelmetIA_net","H_MilCap_dgtl","H_PilotHelmetFighter_I","H_PilotHelmetHeli_I"
];
//Want to limit backpacks? Place the classnames in the array!
vas_backpacks = [
	"B_AssaultPack_khk","B_AssaultPack_rgr","B_AssaultPack_blk","B_TacticalPack_rgr","B_TacticalPack_blk","B_TacticalPack_oli","B_FieldPack_blk","B_FieldPack_oli","B_Carryall_oli","B_Carryall_khk","B_Kitbag_sgg","I_UAV_01_backpack_F","B_Parachute","I_Mortar_01_support_F","I_Mortar_01_weapon_F","I_HMG_01_support_F","I_HMG_01_support_high_F","I_HMG_01_weapon_F","I_GMG_01_weapon_F","I_HMG_01_high_weapon_F","I_GMG_01_high_weapon_F"
];
//Want to limit goggles? Place the classnames in the array!
vas_glasses = [];


/*
	NOTES ON EDITING:
	THIS IS THE SAME AS THE ABOVE VARIABLES, YOU NEED TO KNOW THE CLASS NAME OF THE ITEM YOU ARE RESTRICTING. THIS DOES NOT WORK IN 
	CONJUNCTION WITH THE ABOVE METHOD, THIs IS ONLY FOR RESTRICTING / LIMITING ITEMS FROM VAS AND NOTHING MORE
	
														EXAMPLE
	vas_r_weapons = ["srifle_EBR_F","arifle_MX_GL_F"];
	vas_r_items = ["muzzle_snds_H","muzzle_snds_B","muzzle_snds_L","muzzle_snds_H_MG"]; //Removes suppressors from VAS
	vas_r_goggles = ["G_Diving"]; //Remove diving goggles from VAS
	
												Example for side specific (TvT)
	switch(playerSide) do
	{
		//Blufor
		case west:
		{
			vas_r_weapons = ["srifle_EBR_F","arifle_MX_GL_F"];
			vas_r_items = ["muzzle_snds_H","muzzle_snds_B","muzzle_snds_L","muzzle_snds_H_MG"]; //Removes suppressors from VAS
			vas_r_goggles = ["G_Diving"]; //Remove diving goggles from VAS
		};
		//Opfor
		case west:
		{
			vas_r_weapons = ["srifle_EBR_F","arifle_MX_GL_F"];
			vas_r_items = ["muzzle_snds_H","muzzle_snds_B","muzzle_snds_L","muzzle_snds_H_MG"]; //Removes suppressors from VAS
			vas_r_goggles = ["G_Diving"]; //Remove diving goggles from VAS
		};
	};
*/

//Below are variables you can use to restrict certain items from being used.
//Remove Weapon
vas_r_weapons = [];
vas_r_backpacks = [];
//Magazines to remove from VAS
vas_r_magazines = [];
//Items to remove from VAS
vas_r_items = [];
//Goggles to remove from VAS
vas_r_glasses = [];
