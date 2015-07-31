;Drops Clan Castle troops, given the slot and x, y coordinates.

; #FUNCTION# ====================================================================================================================
; Name ..........: dropSpell
; Description ...: Drops Spell, given the spell and x, y coordinates.
; Syntax ........: dropSpell($x, $y, $spell)
; Parameters ....: $x                   - X location.
;                  $y                   - Y location.
;                  $spell               - spell
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func dropSpell($x, $y, $spell) ;Drop Spell
	If $spell <> -1 Then
		SetLog("Dropping " & NameOfTroop($spell) & " spell", $COLOR_BLUE)
		Click(GetXPosOfArmySlot($spell, 68, 595, 1,0,"#0001") ;Select spell (FIXME: add debug info)
		If_Sleep(500) Then Return
		Click($x, $y) ; drop it (FIXME: add debug info)
	EndIf
EndFunc   ;==>dropSpell
