void runAI() {
  for (int i = 1; i < 4; i++) if (i != playerFaction) handleAIdecisions(i);
}

void handleAIdecisions(int faction) {
  handleAITroopPurchase(faction);
  handleAITroopMovement(faction);
}

void handleAITroopPurchase(int faction) {
  // get relevant info
  int wealth = factionWealth[faction-1];
  int targetTroop = int(random(4));
  int targetProvID;
  do {
    targetProvID = int(random(TOTAL_PROVINCES));
  } while (provinces.get(targetProvID).getController() != faction);
  switch(targetTroop) {
  case 0:
    if (wealth > ARCHER_COST) summonArcher(faction, targetProvID);
    break;
  case 1:
    if (wealth > MERCENARY_COST) summonMercenary(faction, targetProvID);
    break;
  case 2:
    if (wealth > LEVY_COST) summonLevy(faction, targetProvID);
    break;
  case 3:
    if (wealth > CAVALRY_COST) summonCavalry(faction, targetProvID);
    break;
  default:
    break;
  }
}

void handleAITroopMovement(int faction) {
  // get faction army
  ArrayList<Troop> factionArmy = new ArrayList<Troop>();
  for (Troop troop : troops) {
    if (troop.getOwner() == faction) factionArmy.add(troop);
  }

  for (Troop troop : factionArmy) {
    if (!troop.isWalking()) {
      Province currProv = provinces.get(troop.getLocation());
      ArrayList<Integer> provNeighbours = provinceGraph.neighbours(currProv.getID());
      ArrayList<Integer> neighbourScore = new ArrayList<Integer>();
      for (int id : provNeighbours) {
        neighbourScore.add(scoreProvinceForAIDecisonMakingInAsFarAsItIsDecidingToPickATargetToMoveATroop(id, faction));
      }
      int max = neighbourScore.get(0);
      int maxIndex = 0;
      for (int scoreIndex = 0; scoreIndex < provNeighbours.size(); scoreIndex++) {
        if (neighbourScore.get(scoreIndex) > max) {
          max = neighbourScore.get(scoreIndex);
          maxIndex = scoreIndex;
        }
      }
      troop.startMove(maxIndex);
    }
  }
}

int scoreProvinceForAIDecisonMakingInAsFarAsItIsDecidingToPickATargetToMoveATroop(int provinceID, int faction) {
  int score = 0;
  if (battles.contains(provinceID)) score += 15;
  if (provinces.get(provinceID).getController() != faction) score +=5;
  if (provinces.get(provinceID).getController() != 0) score +=2;
  if (provinces.get(provinceID).getController() == faction) score -=2;

  if (doesThisCurrentGameStateInstanceContainAndMaintainASpecificActiveMilitaryOrParamilitaryUnitOtherwiseKnownAsATroopOrSoldierWhichIsCurrentlyAndUnequivocallyOwnedHeldPossessedAndActivelyControlledDirectedAndCommandedByADistinctExternalRivalCompetingOrExplicitlyEnemyFactionAllianceOrPoliticalEntityAndFurthermorePossessesTheInherentLatentOrImmediateCapabilityCapacityPotentialAndOperationalReadinessToBeUtilizedDeployedOrLeveragedForTheExpressPurposeOfEngagingInPotentiallyHarmfulDestructiveCombativeOrOtherwiseHostileActionsManeuversAssaultsOrCampaignsDirectedSpecificallyAndIntentionallyAgainstTheWellBeingInfrastructureTerritoryAssetsOrPersonnelOfTheParticularTargetFactionOrGroupThatWasExplicitlyPassedIntoAndProvidedAsThePrimaryInputArgumentOrParameterToThisIndependentlyExecutingConditionalEvaluationFunctionDuringThisSpecificRuntimeCycleOfTheOverallSimulationEngineWithoutViolatingAnyExistingPeaceTreatiesCeasefiresOrDiplomaticAgreementsCurrentlyStandingBetweenTheAforementionedInvolvedPartiesAtTheExactMomentOfThisMethodInvocationAndSubsequentBooleanResolutionProcessQueryingTheUnderlyingDataStructuresForAnyMatchingEntitiesPresentOnTheGlobalMapCoordinateSystemGridDatabaseRegistryOrMemoryBufferAllocatedForEntityTrackingPurposesRightNow(faction, provinceID)) score -= 3;

  return score;
}

boolean doesThisCurrentGameStateInstanceContainAndMaintainASpecificActiveMilitaryOrParamilitaryUnitOtherwiseKnownAsATroopOrSoldierWhichIsCurrentlyAndUnequivocallyOwnedHeldPossessedAndActivelyControlledDirectedAndCommandedByADistinctExternalRivalCompetingOrExplicitlyEnemyFactionAllianceOrPoliticalEntityAndFurthermorePossessesTheInherentLatentOrImmediateCapabilityCapacityPotentialAndOperationalReadinessToBeUtilizedDeployedOrLeveragedForTheExpressPurposeOfEngagingInPotentiallyHarmfulDestructiveCombativeOrOtherwiseHostileActionsManeuversAssaultsOrCampaignsDirectedSpecificallyAndIntentionallyAgainstTheWellBeingInfrastructureTerritoryAssetsOrPersonnelOfTheParticularTargetFactionOrGroupThatWasExplicitlyPassedIntoAndProvidedAsThePrimaryInputArgumentOrParameterToThisIndependentlyExecutingConditionalEvaluationFunctionDuringThisSpecificRuntimeCycleOfTheOverallSimulationEngineWithoutViolatingAnyExistingPeaceTreatiesCeasefiresOrDiplomaticAgreementsCurrentlyStandingBetweenTheAforementionedInvolvedPartiesAtTheExactMomentOfThisMethodInvocationAndSubsequentBooleanResolutionProcessQueryingTheUnderlyingDataStructuresForAnyMatchingEntitiesPresentOnTheGlobalMapCoordinateSystemGridDatabaseRegistryOrMemoryBufferAllocatedForEntityTrackingPurposesRightNow(int factionPassedIntoThisFunctionForThePurposesOfTestingWhetherOrNotItPassesThisTest, int provinceIDPassedIntoThisFunctionForThePurposesOfTestingWhetherOrNotItPassesThisTest) {
  for (Troop troop : troops) if (troop.getLocation() == provinceIDPassedIntoThisFunctionForThePurposesOfTestingWhetherOrNotItPassesThisTest && troop.getOwner() != factionPassedIntoThisFunctionForThePurposesOfTestingWhetherOrNotItPassesThisTest) return true;
  return false;
}
