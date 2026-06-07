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
  createLevy(2, 1);
  createMercenary(3, 1);
  createArcher(4, 1);

  createCavalry(10,2);

  // add edges from Leinster to Wales and Ulster to Southern Scotland to fix Dijkstra's
  addBridges();
}
