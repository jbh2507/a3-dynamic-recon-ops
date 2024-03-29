﻿/*
 * Author: Psycho
 
 * Start to carry a unit.
 
 * Arguments:
	0: Unit Drager (Object)
	1: Unit wounded (Object)
 
 * Return value:
	-
*/

params ["_unit"];
private _target = _unit getVariable ["ais_DragDrop_Torso", objNull];

// switch to primary weapon, exit if no primary weapon is present (animation cant be played without a primary :(    )
if (primaryWeapon _unit isEqualTo "") exitWith {
	["주무장을 들고 있을때만 업을 수 있습니다."] call AIS_Core_fnc_dynamicText;
};

if (primaryWeapon _unit != "") then {
	_unit switchmove "amovpercmstpsraswrfldnon";
	_unit selectWeapon (primaryWeapon _unit);
};

if (_unit call AIS_System_fnc_checkLauncher) exitWith {
	["발사장비를 메고 있을때는 업을 수 없습니다."] call AIS_Core_fnc_dynamicText;
};
_unit setVariable ["ais_CarryDrop_Torso", true];

["W를 눌러 계속 업기"] call AIS_Core_fnc_dynamicText;

[_target,_unit] spawn {

	_target = _this select 0;
	_unit = _this select 1;
	detach _unit;
	detach _target;
	
	_pos = _unit ModelToWorld [0,1.8,0];
	_target setPos _pos;
	[_target, "grabCarried"] remoteExec ["playActionNow", 0, false];
	disableUserInput true;
	sleep 0.5;
	if (!isPlayer _target) then {_target disableAI "ANIM"};
	[_unit, "grabCarry"] remoteExec ["playActionNow", 0, false];
	_unit playActionNow "grabCarry";
	disableUserInput false;
	disableUserInput true;
	disableUserInput false;
	
	_timenow = time;
	waitUntil {!alive _target || {!alive _unit} || {_unit getVariable ["ais_unconscious", false]} || {time > _timenow + 12}};
	_state = _unit getVariable ["ais_unconscious", false];
	if (!alive _target || {!alive _unit} || {_state}) then {
		if (alive _target) then {
			[_target, "agonyStart"] remoteExec ["playActionNow", 0, false];
			_target setVariable ["ais_DragDrop_Player", objNull, true];
		};
		if (alive _unit && {!(_state)}) then {
			[_unit, "amovpknlmstpsraswrfldnon"] remoteExec ["playMoveNow", 0, false];
		};
		_unit setVariable ["ais_DragDrop_Torso", objNull];
		_unit setVariable ["ais_CarryDrop_Torso", false];
	} else {
		_target attachTo [_unit, [-0.6, 0.28, -0.05]];
		[_target, 0] remoteExec ["setDir", 0, false];
	};
	
};


true