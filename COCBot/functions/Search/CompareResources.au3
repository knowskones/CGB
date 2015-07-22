; #FUNCTION# ====================================================================================================================
; Name ..........: CompareResources
; Description ...: Compaires Resources while searching for a village to attack
; Syntax ........: CompareResources()
; Parameters ....:
; Return values .: True if compaired resources match the search conditions, False if not
; Author ........: (2014)
; Modified ......: AtoZ, Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......: VillageSearch, GetResources
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func CompareResources($pMode) ;Compares resources and returns true if conditions meet, otherwise returns false

	If $iChkSearchReduction = 1 Then
		If ($iChkEnableAfter[$pMode] = 0 And $SearchCount <> 0 And Mod($SearchCount, $ReduceCount) = 0) Or ($iChkEnableAfter[$pMode] = 1 And $SearchCount - $iEnableAfterCount[$pMode] > 0 And Mod($SearchCount - $iEnableAfterCount[$pMode], $ReduceCount) = 0) Then
			If $iAimGold[$pMode] - $ReduceGold >= 0 Then $iAimGold[$pMode] -= $ReduceGold
			If $iAimElixir[$pMode] - $ReduceElixir >= 0 Then $iAimElixir[$pMode] -= $ReduceElixir
			If $iAimDark[$pMode] - $ReduceDark >= 0 Then $iAimDark[$pMode] -= $ReduceDark
			If $iAimTrophy[$pMode] - $ReduceTrophy >= 0 Then $iAimTrophy[$pMode] -= $ReduceTrophy
			If $iAimGoldPlusElixir[$pMode] - $ReduceGoldPlusElixir >= 0 Then $iAimGoldPlusElixir[$pMode] -= $ReduceGoldPlusElixir

			If $iCmbMeetGE[$pMode] = 2 Then
				SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode]) & $iAimTHtext[$pMode] & " for: " & $sModeText[$pMode], $COLOR_GREEN, "Lucida Console", 7.5)
			Else
				SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$pMode]) & " [E]:" & StringFormat("%7s", $iAimElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode]) & $iAimTHtext[$pMode] & " for: " & $sModeText[$pMode], $COLOR_GREEN, "Lucida Console", 7.5)
			EndIf
		EndIf
	EndIf

	Local $G = (Number($searchGold) >= Number($iAimGold[$pMode])), $E = (Number($searchElixir) >= Number($iAimElixir[$pMode])), $D = (Number($searchDark) >= Number($iAimDark[$pMode])), $T = (Number($searchTrophy) >= Number($iAimTrophy[$pMode])), $GPE = ((Number($searchGold) + Number($searchElixir)) >= Number($iAimGoldPlusElixir[$pMode]))

	If $OptBullyMode = 1 And ($SearchCount >= $ATBullyMode) Then
		Local $bullymodeactive = 1
	Else
		Local $bullymodeactive = 0
	EndIf
	Local $CompRes
	While True
		If $iChkMeetOne[$pMode] = 1 Then
			$CompRes = True

			If $iCmbMeetGE[$pMode] = 0 Then
				If $G = True And $E = True Then ExitLoop
			EndIf

			If $iChkMeetDE[$pMode] = 1 Then
				If $D = True Then ExitLoop
			EndIf

			If $iChkMeetTrophy[$pMode] = 1 Then
				If $T = True Then ExitLoop
			EndIf

			If $iCmbMeetGE[$pMode] = 1 Then
				If $G = True Or $E = True Then ExitLoop
			EndIf

			If $iChkMeetTH[$pMode] = 1 Or $iChkMeetTHO[$pMode] = 1 Or $OptTrophyMode = 1 Or $bullymodeactive = 1 Then
				If $searchTH = "-" Then
					If ($iCmbSearchMode <> $LB And $iChkMeetTHO[$DB] = 1) Or ($iCmbSearchMode <> $DB And $iChkMeetTHO[$LB] = 1) Or $OptTrophyMode = 1 Then
						$searchTH = checkTownhallADV()
					Else
						$searchTH = checkTownhall()
						If $searchTH = "-" Then checkTownhallADV()
					EndIf

					If SearchTownHallLoc() = False And $searchTH <> "-" Then
						$THLoc = "In"
					ElseIf $searchTH <> "-" Then
						$THLoc = "Out"
					Else
						$THLoc = $searchTH
						$THx = 0
						$THy = 0
					EndIf
					$THString = " [TH]:" & StringFormat("%2s", $searchTH) & ", " & $THLoc
				EndIf
			EndIf

			If $iChkMeetTH[$pMode] = 1 Then
				If $searchTH <> "-" And $searchTH <= ($iCmbTH[$pMode] + 6) Then ExitLoop
			EndIf

			If $iChkMeetTHO[$pMode] = 1 Then
				If $THLoc = "Out" Then ExitLoop
			EndIf

			If $iCmbMeetGE[$pMode] = 2 Then
				If $GPE = True Then ExitLoop
			EndIf

			If $iChkWeakBase[$pMode] = 1 Then
				_WinAPI_DeleteObject($hBitmapFirst)
				$hBitmapFirst = _CaptureRegion2()
				Local $resultHere = DllCall($pFuncLib, "str", "CheckConditionForWeakBase", "ptr", $hBitmapFirst, "int", ($iCmbWeakMortar[$pMode] + 1), "int", ($iCmbWeakWizTower[$pMode] + 1), "int", 10)
				If $resultHere[0] = "Y" Then ExitLoop
			EndIf

			$CompRes = False
			ExitLoop
		Else
			$CompRes = False
			If $iChkMeetDE[$pMode] = 1 Then
				If $D = False Then ExitLoop
			EndIf

			If $iCmbMeetGE[$pMode] = 0 Then
				If $G = False Or $E = False Then ExitLoop
			EndIf

			If $iCmbMeetGE[$pMode] = 1 Then
				If $G = False And $E = False Then ExitLoop
			EndIf

			If $iCmbMeetGE[$pMode] = 2 Then
				If $GPE = False Then ExitLoop
			EndIf

			If $iChkMeetTrophy[$pMode] = 1 Then
				If $T = False Then ExitLoop
			EndIf

			If $iChkMeetTH[$pMode] = 1 Or $iChkMeetTHO[$pMode] = 1 Or $OptTrophyMode = 1 Or $bullymodeactive = 1 Then
				If $searchTH = "-" Then
					If ($iCmbSearchMode <> $LB And $iChkMeetTHO[$DB] = 1) Or ($iCmbSearchMode <> $DB And $iChkMeetTHO[$LB] = 1) Or $OptTrophyMode = 1 Then
						$searchTH = checkTownhallADV()
					Else
						$searchTH = checkTownhall()
						If $searchTH = "-" Then checkTownhallADV()
					EndIf

					If SearchTownHallLoc() = False And $searchTH <> "-" Then
						$THLoc = "In"
					ElseIf $searchTH <> "-" Then
						$THLoc = "Out"
					Else
						$THLoc = $searchTH
						$THx = 0
						$THy = 0
					EndIf
					$THString = " [TH]:" & StringFormat("%2s", $searchTH) & ", " & $THLoc
				EndIf
			EndIf

			If $iChkMeetTH[$pMode] = 1 Then
				If $searchTH = "-" Or $searchTH > ($iCmbTH[$pMode] + 6) Then ExitLoop
			EndIf

			If $iChkMeetTHO[$pMode] = 1 Then
				If $THLoc <> "Out" Then ExitLoop
			EndIf

			If $iChkWeakBase[$pMode] = 1 Then
				_WinAPI_DeleteObject($hBitmapFirst)
				$hBitmapFirst = _CaptureRegion2()
				Local $resultHere = DllCall($pFuncLib, "str", "CheckConditionForWeakBase", "ptr", $hBitmapFirst, "int", ($iCmbWeakMortar[$pMode] + 1), "int", ($iCmbWeakWizTower[$pMode] + 1), "int", 10)
				If $resultHere[0] <> "Y" Then ExitLoop
			EndIf

			$CompRes = True
			ExitLoop
		EndIf
	WEnd
	$SearchTHLResult = 0
	If $searchTH <> "-" And $searchTH <= $YourTH Then $SearchTHLResult = 1
	If $CompRes = True Then
		Return True
	Else
		Return False
	EndIf


EndFunc   ;==>CompareResources
