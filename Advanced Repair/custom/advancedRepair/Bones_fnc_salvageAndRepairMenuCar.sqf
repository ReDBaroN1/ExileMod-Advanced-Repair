private _vehicle = _this select 0;
LastCarWrenched = _vehicle;
private _vehicleAllHitPointsDamage = getAllHitPointsDamage _vehicle;
private _vehicleDamage = (_vehicleAllHitPointsDamage select 2);
private _vehicleHitNames = (_vehicleAllHitPointsDamage select 0);
private _vehiclePartNames = (_vehicleAllHitPointsDamage select 1);

ASL_Show_RepairWheel_Options_Menu_Array = [["Wheels Repair Menu",true]];
ASL_Show_RepairGlass_Options_Menu_Array = [["Glass Repair Menu",true]];
ASL_Show_SalvageWheel_Options_Menu_Array = [["Wheels Salvage Menu",true]];
ASL_Show_SalvageGlass_Options_Menu_Array = [["Glass Salvage Menu",true]];

{
    private _partDisplayName = (_vehicleHitNames select _forEachIndex) select [3];
    private _partDisplayHitpoint = round(100-((_vehicleDamage select _forEachIndex) * 100));
    if (toLower(_x) find "wheel" >= 0) then {
        private _menuItemName = format ["Repair Wheel: %1 (%2%3)", _partDisplayName, _partDisplayHitpoint, "/100"];
        private _menuItemExpression = format ["['repairWheel','%1'] Call salvage_setup",(_vehicleHitNames select _forEachIndex)];
        private _enableMenuItem = ["0","1"] select (_vehicleDamage select _forEachIndex > 0);
        ASL_Show_RepairWheel_Options_Menu_Array pushBack [_menuItemName,[0],"",-5,[["expression",_menuItemExpression]],"1",_enableMenuItem];

        private _menuItemName = format ["Salvage Wheel: %1 (%2%3)", _partDisplayName, _partDisplayHitpoint, "/100"];
        private _menuItemExpression = format ["['salvageWheel','%1'] Call salvage_setup",(_vehicleHitNames select _forEachIndex)];
        private _enableMenuItem = ["0","1"] select (_vehicleDamage select _forEachIndex < 0.2);
        ASL_Show_SalvageWheel_Options_Menu_Array pushBack [_menuItemName,[0],"",-5,[["expression",_menuItemExpression]],"1",_enableMenuItem];
    };
    if (toLower(_x) find "glass" >= 0) then {
        private _menuItemName = format ["Repair Glass: %1 (%2%3)", _partDisplayName, _partDisplayHitpoint, "/100"];
        private _menuItemExpression = format ["['repairGlass','%1'] Call salvage_setup",(_vehicleHitNames select _forEachIndex)];
        private _enableMenuItem = ["0","1"] select (_vehicleDamage select _forEachIndex > 0);
        ASL_Show_RepairGlass_Options_Menu_Array pushBack [_menuItemName,[0],"",-5,[["expression",_menuItemExpression]],"1",_enableMenuItem];

        private _menuItemName = format ["Salvage Glass: %1 (%2%3)", _partDisplayName, _partDisplayHitpoint, "/100"];
        private _menuItemExpression = format ["['salvageGlass','%1'] Call salvage_setup",(_vehicleHitNames select _forEachIndex)];
        private _enableMenuItem = ["0","1"] select (_vehicleDamage select _forEachIndex < 0.2);
        ASL_Show_SalvageGlass_Options_Menu_Array pushBack [_menuItemName,[0],"",-5,[["expression",_menuItemExpression]],"1",_enableMenuItem];
    };
} forEach _vehiclePartNames;


private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");

ASL_Show_Repair_Options_Menu_Array = 
[
	["Repair "+_vehicleName ,true]
];

private _bodyDamage = _vehicleDamage select (_vehicleHitNames find "HitBody");
private _bodyDisplayHitpoint = round(100-((_bodyDamage) * 100));
private _enableBodyRepair = ["0","1"] select (_bodyDamage > 0);
ASL_Show_Repair_Options_Menu_Array pushBack [format ["Repair Body (%1%2)", _bodyDisplayHitpoint, "/100"],[0],"",-5,[["expression","['repairCarHull'] Call salvage_setup"]],"1",_enableBodyRepair];

ASL_Show_Repair_Options_Menu_Array pushBack	["Repair Wheels",[0],"#USER:ASL_Show_RepairWheel_Options_Menu_Array",-5,[],"1","1"];
ASL_Show_Repair_Options_Menu_Array pushBack ["Repair Glass",[0],"#USER:ASL_Show_RepairGlass_Options_Menu_Array",-5,[],"1","1"];

private _engineDamage = _vehicleDamage select (_vehicleHitNames find "HitEngine");
private _enableEngineRepair = ["0","1"] select (_engineDamage > 0);
private _enableEngineSalvage = ["0","1"] select (_engineDamage < 0.2);
private _engineDisplayHitpoint = round(100-((_engineDamage) * 100));

ASL_Show_Repair_Options_Menu_Array pushBack	[format ["Repair Engine (%1%2)", _engineDisplayHitpoint, "/100"],[0],"",-5,[["expression","['repairCarEngine'] Call salvage_setup"]],"1",_enableEngineRepair];

private _fueltankDamage = _vehicleDamage select (_vehicleHitNames find "HitFuel");
private _enableFueltankRepair = ["0","1"] select (_fueltankDamage > 0);
private _enableFueltankSalvage = ["0","1"] select (_fueltankDamage < 0.2);
private _fueltankDisplayHitpoint = round(100-((_fueltankDamage) * 100));

ASL_Show_Repair_Options_Menu_Array pushBack	[format ["Repair Fueltank (%1%2)", _fueltankDisplayHitpoint , "/100"],[0],"",-5,[["expression","['repairFueltank'] Call salvage_setup"]],"1",_enableFueltankRepair];
//ASL_Show_Repair_Options_Menu_Array pushBack	["Repair All",[0],"",-5,[["expression","['repairAllCar'] Call salvage_setup"]],"1","1"];
ASL_Show_Repair_Options_Menu_Array pushBack ["Salvage Wheels",[0],"#USER:ASL_Show_SalvageWheel_Options_Menu_Array",-5,[],"1","1"];
ASL_Show_Repair_Options_Menu_Array pushBack ["Salvage Glass",[0],"#USER:ASL_Show_SalvageGlass_Options_Menu_Array",-5,[],"1","1"];
ASL_Show_Repair_Options_Menu_Array pushBack	["Salvage Engine",[0],"",-5,[["expression","['salvageCarEngine'] Call salvage_setup"]],"1",_enableEngineSalvage];
ASL_Show_Repair_Options_Menu_Array pushBack	["Salvage Fueltank",[0],"",-5,[["expression","['salvageFueltank'] Call salvage_setup"]],"1",_enableFueltankSalvage];
/*
diag_log format ["_vehicleAllHitPointsDamage: %1",str _vehicleAllHitPointsDamage];
diag_log format ["ASL_Show_RepairWheel_Options_Menu_Array: %1",str ASL_Show_RepairWheel_Options_Menu_Array];
diag_log format ["ASL_Show_RepairGlass_Options_Menu_Array: %1",str ASL_Show_RepairGlass_Options_Menu_Array];
diag_log format ["ASL_Show_SalvageWheel_Options_Menu_Array: %1",str ASL_Show_SalvageWheel_Options_Menu_Array];
diag_log format ["ASL_Show_SalvageGlass_Options_Menu_Array: %1",str ASL_Show_SalvageGlass_Options_Menu_Array];
diag_log format ["ASL_Show_Repair_Options_Menu_Array: %1",str ASL_Show_Repair_Options_Menu_Array];
*/


showCommandingMenu "";
showCommandingMenu "#USER:ASL_Show_Repair_Options_Menu_Array";

salvage_setup = {

_vehicle = LastCarWrenched;
_action = _this select 0;
if (_action in ["salvageWheel","repairWheel","salvageGlass","repairGlass"]) then {
    _part = _this select 1;
    [_action,_vehicle,_part] execVM 'Custom\advancedRepair\Bones_fnc_salvageAndRepair.sqf';
} else {
   [_action,_vehicle] execVM 'Custom\advancedRepair\Bones_fnc_salvageAndRepair.sqf';
};

};