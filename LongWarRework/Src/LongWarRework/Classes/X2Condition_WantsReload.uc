class X2Condition_WantsReload extends X2Condition;

var bool PrimaryWantsReload;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item PrimaryWeapon;

	if (PrimaryWantsReload)
	{
		TargetUnit = XComGameState_Unit(kTarget);
		if (TargetUnit == none)
		return 'AA_NotAUnit';

	//`LOG (TargetUnit.GetLastName() @ "checking Solace_LW condition");

		if (TargetUnit.IsAdvent() || TargetUnit.IsAlien() || TargetUnit.IsRobotic())
			return 'AA_UnitIsWrongType';

		PrimaryWeapon = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon); // TODO validate PrimaryWeapon is not null before using

		if (PrimaryWeapon.Ammo == PrimaryWeapon.GetClipSize())
		{
			return 'AA_AmmoAlreadyFull';
		}
	}

	return 'AA_Success';
}