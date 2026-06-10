void handleAIdecisions(int faction){
    // get relevant info
    int wealth = factionWealth[faction-1];

    // get faction army
    ArrayList<Troop> factionArmy = new ArrayList<Troop>();
    for(Troop troop: troops){
        if(troop.getOwner() == faction) factionArmy.add(troop);
    }

    
}