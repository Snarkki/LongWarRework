class X2Ability_LWR extends XMBAbility config (LWRAbility);

var config bool RESUPPLY_AWC;
var config int PSIRELOAD_CD;
var config int LWR_PSYBLADE_DMG;
var config int LWR_PSYBLADE_AP;
var config int ReaperBreachAmmo;
var config int ReaperBreachCD;
var config int ReaperBreachEnvironmentalDamage;
var config float ReaperBreachRange, ReaperBreachRadius;
var config bool ReaperBreachOnly;
var config int BullRushCD;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(LWR_PsiReload());
	Templates.AddItem(LWR_Psyblades());
	Templates.AddItem(LWR_ReaperBreach());
	Templates.AddItem(LWR_BullRush());
	return Templates;
}

// Resupply
// (AbilityName="F_Resupply", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Refill the ammo of all allies. Charge-based.
static function X2AbilityTemplate LWR_PsiReload()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Condition_UnitProperty              EnemyCondition;
	local X2Condition_UnitProperty              FriendCondition;
	local X2Effect_PsiReload					EffectReload;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_WantsReload			ReloadCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_PsiReload');

	Template.IconImage = "img:///LWR_package.PsiReload";
    //Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.DisplayTargetHitChance = false;
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PSIRELOAD_CD;
	Template.AbilityCooldown = Cooldown;

	// Targets must want a reload
	ReloadCondition = new class 'X2Condition_WantsReload';
	ReloadCondition.PrimaryWantsReload = true;
	Template.AbilityTargetConditions.AddItem(ReloadCondition);


	// Add resupply effect
	EffectReload = new class'X2Effect_PsiReload';
	EffectReload.TargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AddTargetEffect(EffectReload);


    Template.ActivationSpeech = 'Inspire';
    Template.bShowActivation = true;
    Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate LWR_Psyblades()
{
	local XMBEffect_ConditionalBonus Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddDamageModifier(default.LWR_PSYBLADE_DMG);
	Effect.AddArmorPiercingModifier(default.LWR_PSYBLADE_AP);

	// Restrict to the weapon matching this ability
	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	return Passive('LWR_Psyblades', "img:///UILibrary_SOHunter.UIPerk_keenedge", false, Effect);
}

static function X2AbilityTemplate LWR_ReaperBreach()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local XMBAbilityMultiTarget_Radius      RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitInventory			InventoryCondition;
	local AdditionalCooldownInfo			AdditionalCooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_ReaperBreach');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_SOCombatEngineer.UIPerk_breach";
	Template.Hostility = eHostility_Offensive;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	Template.TargetingMethod = class'X2TargetingMethod_ReaperBreach';

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.ReaperBreachAmmo;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.AbilityCosts.AddItem(ActionPointCost(eCost_WeaponConsumeAll));
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ReaperBreachCD;
	AdditionalCooldown.AbilityName = 'ReaperBreach';
	AdditionalCooldown.bUseAbilityCooldownNumTurns = true;
	Cooldown.AditionalAbilityCooldowns.AddItem(AdditionalCooldown);
	Template.AbilityCooldown = Cooldown;
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	
	if (default.ReaperBreachOnly)
	{
		InventoryCondition = new class'X2Condition_UnitInventory';
		InventoryCondition.RelevantSlot = eInvSlot_PrimaryWeapon;
		InventoryCondition.RequireWeaponCategory = 'vektor_rifle';
		Template.AbilityShooterConditions.AddItem(InventoryCondition);
	}

	WeaponDamageEffect = new class'X2Effect_ReaperBreach';
	WeaponDamageEffect.EnvironmentalDamageAmount = default.ReaperBreachEnvironmentalDamage;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.ReaperBreachRange;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'XMBAbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ReaperBreachRadius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	return Template;	
}
static function X2AbilityTemplate LWR_BullRush()
{

	local X2AbilityTemplate Template;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2Effect_Persistent StunnedEffect;
	local X2AbilityToHitCalc_StandardMelee ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;

	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWR_BullRush');

		// Standard melee attack setup
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_SOCombatEngineer.UIPerk_bullrush";;
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BullRushCD;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	AdjacencyCondition.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	// Create a stun effect that removes 2 actions and has a 100% chance of success if the attack hits.
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	StunnedEffect.VisualizationFn = EffectFlyOver_Visualization;
	Template.AddTargetEffect(StunnedEffect);

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

