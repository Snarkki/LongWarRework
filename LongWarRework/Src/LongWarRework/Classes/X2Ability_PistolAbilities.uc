//// This is an Unreal Script
class X2Ability_PistolAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config (LWRAbility);
//
//var config int PISTOL_MOBILITY_BONUS;
//
//static function array<X2DataTemplate> CreateTemplates()
//{
	//local array<X2DataTemplate> Templates;
	//
	//Templates.AddItem(AddPistolBonusAbility());
//
	//return Templates;
//}
//
//static function X2AbilityTemplate AddPistolBonusAbility()
//{
	//local X2AbilityTemplate                 Template;	
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'PISTOL_LS_StatBonus');
	//Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  
//
	//Template.AbilitySourceName = 'eAbilitySource_Item';
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
	//Template.bDisplayInUITacticalText = false;
	//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//
	//// Bonus to Mobility and DetectionRange stat effects
	//PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	//PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	//PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	//PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.PISTOL_MOBILITY_BONUS);
	//Template.AddTargetEffect(PersistentStatChangeEffect);
//
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//
	//return Template;	
//}