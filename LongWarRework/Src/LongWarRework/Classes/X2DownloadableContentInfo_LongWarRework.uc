//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_LongWarRework.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWarRework extends X2DownloadableContentInfo config (LWRAbility);

var config array<int> MEDIUM_SPARK_RANGE;
var config int PISTOL_MOBILITY_BONUS;
var config array<name>  EnemyTemplates;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplate         Template;
    local X2AbilityTemplateManager  AbilityTemplateManager;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AbilityTemplateManager.FindAbilityTemplate('Volt');
	if (Template != none)
    {
        //  Modify template as you wish. 
        `LOG("Success, modified the template: 'VoltTemplate'",, 'LongWarRework');
        Template.PostActivationEvents.AddItem('RendActivated');
    }

	UpdateSparkRanges('SparkRifle_CV');
	UpdateSparkRanges('SparkRifle_MG');
	UpdateSparkRanges('SparkRifle_BM');
	UpdateSparkRanges('SparkRifle_LS');
	UpdateSparkRanges('SparkRifle_CG');
	//UpdatePistolMobility('Pistol_CV');
	//UpdatePistolMobility('Pistol_LS');
	//UpdatePistolMobility('Pistol_MG');
	//UpdatePistolMobility('Pistol_CG');
	//UpdatePistolMobility('Pistol_BM');
	AddPerk('AdvSergeantM1', 'ReadyForAnything');
	AddPerk('AdvSergeantM2', 'ReadyForAnything');
	AddPerk('AdvGeneralM1', 'ReadyForAnything');
	AddPerk('AdvGeneralM2', 'ReadyForAnything');
}
static function UpdateSparkRanges(Name WeaponName)

{
    local X2ItemTemplateManager                    ItemTemplateManager;
    local X2WeaponTemplate                        WeaponTemplate;

    ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();   
    // Update Vektor Rifle Items
    WeaponTemplate = X2WeaponTemplate(ItemTemplateManager.FindItemTemplate(WeaponName));
    if (WeaponTemplate != none)
	{
		`LOG("Success, modified the template: 'WeaponName'",, 'LongWarRework');
		WeaponTemplate.RangeAccuracy = default.MEDIUM_SPARK_RANGE;
	}
}

//static function UpdatePistolMobility(Name WeaponName)
//
//{
    //local X2ItemTemplateManager                    ItemTemplateManager;
    //local X2WeaponTemplate                        WeaponTemplate;
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	//local X2AbilityTemplate                 Template;	
//
    //ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();   
    //// 
    //WeaponTemplate = X2WeaponTemplate(ItemTemplateManager.FindItemTemplate(WeaponName));
    //if (WeaponTemplate != none)
	//{
		//`LOG("Success, modified the template: 'WeaponName'",, 'LongWarRework');
//
		//WeaponTemplate.Abilities.AddItem('PISTOL_LS_StatBonus');
		//WeaponTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_PistolAbilities'.default.PISTOL_MOBILITY_BONUS);
	//}
//}

static function AddPerk( name nEnemyName, name nPerkName ) 

{
    local X2CharacterTemplateManager        AllCharacters;
    local X2CharacterTemplate                CurrentUnit;
    local X2DataTemplate                    DifficultyTemplate;
    local array<X2DataTemplate>                DifficultyTemplates;

   if ( nPerkName == '' ) {
      `RedScreen("Enemy Perk add called with no perk name.");
      return;
   }

   if ( nEnemyName == '' ) {
      `RedScreen("Enemy Perk add called with no unit name.");
      return;
   }

    AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
    AllCharacters.FindDataTemplateAllDifficulties(nEnemyName, DifficultyTemplates);

    CurrentUnit = AllCharacters.FindCharacterTemplate(nEnemyName);

    if ( CurrentUnit != none ) {
      // Preventing Duplication
      CurrentUnit.Abilities.RemoveItem(nPerkName);
      CurrentUnit.Abilities.AddItem(nPerkName);
   }
}