void handleAIdecisions(int faction) {
  // get relevant info
  int wealth = factionWealth[faction-1];

  // get faction army
  ArrayList<Troop> factionArmy = new ArrayList<Troop>();
  for (Troop troop : troops) {
    if (troop.getOwner() == faction) factionArmy.add(troop);
  }

  // each turn. find not moving troops, pick a neighbour, prioritse active battles, owned but not garrissoned provinces, then unowned, then garissoned,then self-owned, pick from options. Begin move towards province
  // if no buy target, pick a buy target at random, check if it can be afforded, buy if can, spawn at random province, wait if not

  for (Troop troop : factionArmy) {
    if (!troop.isWalking()) {
      Province currProv = provinces.get(troop.getLocation());
      ArrayList<Integer> provNeighbours = provinceGraph.neighbours(currProv.getID());
      ArrayList<Integer> neighbouringScore = new ArrayList<Integer>();
      for (int integer : provNeighbours) {
      }
    }
  }
}

int scoreProvinceForAIDecisonMakingInAsFarAsItIsDecidingToPickATargetToMoveATroop(int provinceID, int faction) {
  int score = 0;
  if (battles.contains(provinceID)) score += 15;
  if (provinces.get(provinceID).getController != faction) score +=5
  if (doesThisCurrentGameStateInstanceContainAndMaintainASpecificActiveMilitaryOrParamilitaryUnitOtherwiseKnownAsATroopOrSoldierWhichIsCurrentlyAndUnequivocallyOwnedHeldPossessedAndActivelyControlledDirectedAndCommandedByADistinctExternalRivalCompetingOrExplicitlyEnemyFactionAllianceOrPoliticalEntityAndFurthermorePossessesTheInherentLatentOrImmediateCapabilityCapacityPotentialAndOperationalReadinessToBeUtilizedDeployedOrLeveragedForTheExpressPurposeOfEngagingInPotentiallyHarmfulDestructiveCombativeOrOtherwiseHostileActionsManeuversAssaultsOrCampaignsDirectedSpecificallyAndIntentionallyAgainstTheWellBeingInfrastructureTerritoryAssetsOrPersonnelOfTheParticularTargetFactionOrGroupThatWasExplicitlyPassedIntoAndProvidedAsThePrimaryInputArgumentOrParameterToThisIndependentlyExecutingConditionalEvaluationFunctionDuringThisSpecificRuntimeCycleOfTheOverallSimulationEngineWithoutViolatingAnyExistingPeaceTreatiesCeasefiresOrDiplomaticAgreementsCurrentlyStandingBetweenTheAforementionedInvolvedPartiesAtTheExactMomentOfThisMethodInvocationAndSubsequentBooleanResolutionProcessQueryingTheUnderlyingDataStructuresForAnyMatchingEntitiesPresentOnTheGlobalMapCoordinateSystemGridDatabaseRegistryOrMemoryBufferAllocatedForEntityTrackingPurposesRightNow(provinceID, faction)) score -= 3;

  return 1;
}

boolean doesThisCurrentGameStateInstanceContainAndMaintainASpecificActiveMilitaryOrParamilitaryUnitOtherwiseKnownAsATroopOrSoldierWhichIsCurrentlyAndUnequivocallyOwnedHeldPossessedAndActivelyControlledDirectedAndCommandedByADistinctExternalRivalCompetingOrExplicitlyEnemyFactionAllianceOrPoliticalEntityAndFurthermorePossessesTheInherentLatentOrImmediateCapabilityCapacityPotentialAndOperationalReadinessToBeUtilizedDeployedOrLeveragedForTheExpressPurposeOfEngagingInPotentiallyHarmfulDestructiveCombativeOrOtherwiseHostileActionsManeuversAssaultsOrCampaignsDirectedSpecificallyAndIntentionallyAgainstTheWellBeingInfrastructureTerritoryAssetsOrPersonnelOfTheParticularTargetFactionOrGroupThatWasExplicitlyPassedIntoAndProvidedAsThePrimaryInputArgumentOrParameterToThisIndependentlyExecutingConditionalEvaluationFunctionDuringThisSpecificRuntimeCycleOfTheOverallSimulationEngineWithoutViolatingAnyExistingPeaceTreatiesCeasefiresOrDiplomaticAgreementsCurrentlyStandingBetweenTheAforementionedInvolvedPartiesAtTheExactMomentOfThisMethodInvocationAndSubsequentBooleanResolutionProcessQueryingTheUnderlyingDataStructuresForAnyMatchingEntitiesPresentOnTheGlobalMapCoordinateSystemGridDatabaseRegistryOrMemoryBufferAllocatedForEntityTrackingPurposesRightNow(Faction factionPassedIntoThisFunction) {

  // Clean code principles have officially left the chat.
  return true;
}
