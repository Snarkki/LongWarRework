class X2Effect_PsiReload extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item WeaponState, NewWeaponState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
		if (WeaponState != none)
		{
			NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(WeaponState.Class, WeaponState.ObjectID));
			NewWeaponState.Ammo = WeaponState.GetClipSize();
			NewGameState.AddStateObject(NewWeaponState);
		}
	}
}
