//Allow player to respawn with his loadout? If true unit will respawn with all ammo from initial save! Set to false to disable this and rely on other scripts!
vas_onRespawn = false;
//Preload Weapon Config?
vas_preload = true;
//If limiting weapons its probably best to set this to true so people aren't loading custom loadouts with restricted gear.
vas_disableLoadSave = false;
//Amount of save/load slots
vas_customslots = 19; //9 is actually 10 slots, starts from 0 to whatever you set, so always remember when setting a number to minus by 1, i.e 12 will be 11.

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
*/

//If the arrays below are empty (as they are now) all weapons, magazines, items, backpacks and goggles will be available
//Want to limit VAS to specific weapons? Place the classnames in the array!
vas_weapons = [];
//Want to limit VAS to specific magazines? Place the classnames in the array!
vas_magazines = [];
//Want to limit VAS to specific items? Place the classnames in the array!
vas_items = [];
//Want to limit backpacks? Place the classnames in the array!
vas_backpacks = [];
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
*/


//Below are variables you can use to restrict certain items from being used.
//Remove Weapon
vas_r_weapons = ["launch_RPG32_F","LMG_Zafir_F","arifle_Katiba_F","arifle_Katiba_C_F","arifle_Katiba_GL_F","launch_B_Titan_F","launch_B_Titan_short_F","launch_O_Titan_F","launch_O_Titan_short_F","arifle_MXC_F","arifle_MX_F","arifle_MX_GL_F","arifle_MX_SW_F","arifle_MXM_F","srifle_DMR_01_F"];
// modified by naong
vas_r_backpacks = [
	"B_UAV_01_backpack_F","O_UAV_01_backpack_F",
	"B_Mortar_01_support_F","B_Mortar_01_weapon_F","B_HMG_01_weapon_F","B_HMG_01_support_F","B_HMG_01_high_weapon_F","B_HMG_01_support_high_F","B_HMG_01_A_weapon_F","B_GMG_01_weapon_F","B_GMG_01_high_weapon_F","B_GMG_01_A_weapon_F",// "B_AA_01_weapon_F","B_AT_01_weapon_F",
	"O_Mortar_01_support_F","O_Mortar_01_weapon_F","O_HMG_01_weapon_F","O_HMG_01_support_F","O_HMG_01_high_weapon_F","O_HMG_01_support_high_F","O_GMG_01_weapon_F","O_GMG_01_high_weapon_F"
];
//Magazines to remove from VAS
vas_r_magazines = ["30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_Tracer","RPG32_F","RPG32_HE_F","TMR_RPG32_TB_F","TMR_RPG32_Smoke_F","150Rnd_762x51_Box","150Rnd_762x51_Box_Tracer","NLAW_F","TMR_NLAW_MPV_F","INKO_NLAW_USED","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag_Tracer","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag_Tracer","3Rnd_HE_Grenade_shell","3Rnd_Smoke_Grenade_shell","3Rnd_SmokeRed_Grenade_shell","3Rnd_SmokeGreen_Grenade_shell","3Rnd_SmokeYellow_Grenade_shell","3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell","3Rnd_UGL_FlareWhite_F","3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareYellow_F","3Rnd_UGL_FlareCIR_F","HandGrenade_Stone","10Rnd_762x51_Mag"];
//Items to remove from VAS1
vas_r_items = [
	// Items
	"optic_Yorris","optic_Nightstalker",
	"B_UavTerminal","O_UavTerminal","NVGoggles","NVGoggles_OPFOR",
	// Uniforms
	"U_BasicBody",
	"U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt","U_B_CombatUniform_mcam_vest","U_B_GhillieSuit","U_B_HeliPilotCoveralls","U_B_Wetsuit","U_O_CombatUniform_ocamo","U_O_GhillieSuit","U_B_CombatUniform_mcam_worn","U_B_CombatUniform_wdl",
	"U_O_CombatUniform_oucamo","U_O_SpecopsUniform_ocamo","U_O_SpecopsUniform_blk","U_O_OfficerUniform_ocamo","U_O_PilotCoveralls","U_O_Wetsuit","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_Rangemaster",
	"U_B_CombatUniform_wdl_tshirt","U_B_CombatUniform_wdl_vest","U_B_CombatUniform_sgg","U_B_CombatUniform_sgg_tshirt","U_B_CombatUniform_sgg_vest","U_B_SpecopsUniform_sgg","U_B_SpecopsUniform_sgg","U_B_PilotCoveralls",
	"U_Competitor","U_NikosBody","U_MillerBody","U_KerryBody","U_OrestesBody","U_AttisBody","U_AntigonaBody","U_IG_Menelaos","U_C_Novak","U_OI_Scientist",
	"U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_IG_Guerilla3_1","U_IG_Guerilla3_2","U_BG_Guerilla1_1","U_BG_Guerilla2_1","U_IG_leader","U_BG_Guerilla2_2","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_BG_Guerilla3_2","U_BG_leader","U_OG_Guerilla1_1","U_OG_Guerilla2_1","U_OG_Guerilla2_2","U_OG_Guerilla2_3","U_OG_Guerilla3_1","U_OG_Guerilla3_2","U_OG_leader",
	"U_B_CTRG_1","U_B_CTRG_2","U_B_CTRG_3",
	"U_C_Poor_1","U_C_Poor_2","U_C_Scavenger_1","U_C_Scavenger_2","U_C_Farmer","U_C_Fisherman","U_C_WorkerOveralls","U_C_FishermanOveralls","U_C_WorkerCoveralls","U_C_HunterBody_grn","U_C_HunterBody_brn","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_C_Commoner2_1","U_C_Commoner2_2","U_C_Commoner2_3","U_C_PriestBody","U_C_Poor_shorts_1","U_C_Poor_shorts_2","U_C_Commoner_shorts","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2",
	// Vests
    "V_RebreatherB","V_RebreatherIR",
	"V_HarnessOSpec_gry","V_HarnessOSpec_brn","V_HarnessOGL_gry","V_HarnessO_gry","V_TacVestCamo_khk","V_TacVestIR_blk","V_TacVest_blk_POLICE","V_TacVest_camo","V_PlateCarrierSpec_rgr","V_PlateCarrier1_blk","V_BandollierB_cbr","V_BandollierB_khk","V_BandollierB_blk","V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier3_rgr","V_PlateCarrierGL_rgr","V_Chestrig_khk","V_Chestrig_blk","V_TacVest_khk","V_TacVest_brn","V_TacVest_blk","V_HarnessO_brn","V_HarnessOGL_brn","V_PlateCarrier_Kerry","V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG","V_I_G_resistanceLeader_F",
	// Helmet
	"H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_HelmetCrew_O","H_PilotHelmetFighter_O","H_CrewHelmetHeli_O","H_PilotHelmetHeli_O",
	"H_HelmetCrew_B","H_CrewHelmetHeli_B","H_PilotHelmetFighter_B","H_PilotHelmetHeli_B",
	"H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan",
	"H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Shemag_olive_hs",
	// Silly hats
	"H_Booniehat_khk","H_Cap_red","H_Cap_blu","H_MilCap_ocamo","H_Cap_tan","H_Cap_blk_CMMG","H_Cap_brn_SPECOPS","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_Raven","H_Cap_blk_ION","H_BandMask_blk","H_BandMask_khk","H_BandMask_reaper","H_BandMask_demon","H_MilCap_oucamo","H_MilCap_rucamo","H_MilCap_gry","H_MilCap_blue","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_khk","H_Bandanna_sgg","H_Bandanna_gry","H_Bandanna_camo","H_Bandanna_mcamo","H_Beret_blk_POLICE","H_Beret_red","H_Beret_grn_SF","H_Beret_brn_SF","H_Beret_ocamo","H_Watchcap_blk","H_Watchcap_khk","H_Watchcap_camo","H_Watchcap_sgg","H_TurbanO_blk","H_Beret_02","H_Bandanna_khk_hs","H_Booniehat_khk_hs"
];
//Goggles to remove from VAS
vas_r_glasses = [];