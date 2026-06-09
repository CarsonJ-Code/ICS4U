void init() {
  provinceGraph = new Graph();
  loadProvinces();
  for (Province province : provinces) {
    province.findBounding();
    province.findCentre();
  }

  initUI();

  populateEdges();

  troops = new ArrayList<Troop>();
  createCavalry(1, 1);
  createCavalry(2, 2);
  createCavalry(3,3);

  // add edges from Leinster to Wales and Ulster to Southern Scotland to fix Dijkstra's
  addBridges();
}
