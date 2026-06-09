// province box
TextElement provinceName;
RectElement provinceBox;
TextElement provinceController;
TextElement provinceNeighbours;

// troop box
RectElement activeTroopInfo;
TextElement activeTroopOwner;
TextElement activeTroopHealth;
TextElement activeTroopStrength;

// wealth box
RectElement wealthBox;
TextElement wealthValue;
ImageElement wealthSymbol;

// intro elements
ImageElement normanCrest;
ImageElement angloCrest;
ImageElement norseCrest;

// troop buttons
ImageElement summonCavalry;
ImageElement summonMercenary;
ImageElement summonLevy;
ImageElement summonArcher;

void initUI() {
  initProvinceView();
  initTroopView();
  initWealthView();
  initStartView();
  initSummonButtons();
}

void initProvinceView() {
  provinceBox = new RectElement(new int[] {0, 500}, new int[]{200, 400}, color(#444444));
  provinceName = new TextElement(new int[] {10, 550}, new int[]{180, 100}, "None", 24, color(#FFFFFF));
  provinceController = new TextElement(new int[] {10, 650}, new int[]{180, 100}, "None", 24, color(#FFFFFF));
  provinceNeighbours = new TextElement(new int[] {10, 750}, new int[]{180, 900}, "None", 18, color(#FFFFFF));
}

void initTroopView() {
  activeTroopInfo = new RectElement(new int[] {1400, 500}, new int[]{200, 400}, color(#444444));
  activeTroopOwner = new TextElement(new int[] {1410, 550}, new int[]{180, 100}, "None", 24, color(#FFFFFF));
  activeTroopHealth = new TextElement(new int[] {1410, 650}, new int[]{180, 100}, "None", 24, color(#FFFFFF));
  activeTroopStrength = new TextElement(new int[] {1410, 750}, new int[]{180, 900}, "None", 18, color(#FFFFFF));
}

void initWealthView() {
  wealthBox = new RectElement(new int[] {1400, 0}, new int[]{200, 200}, color(#444444));
  wealthValue = new TextElement(new int[] {1420, 50}, new int[]{180, 100}, "0", 72, color(#FFFFFF));
  wealthSymbol = new ImageElement(new int[] {1480, 20}, new int[] {100, 100}, loadImage("images/money.png"));
}

void initStartView() {
  normanCrest = new ImageElement(new int[] {33, 200}, new int[] {500, 500}, loadImage("images/Norman.png"));
  angloCrest = new ImageElement(new int[] {566, 200}, new int[] {500, 500}, loadImage("images/Anglo.png"));
  norseCrest = new ImageElement(new int[] {1100, 200}, new int[] {500, 500}, loadImage("images/Norse.png"));
}

void initSummonButtons() {
  summonCavalry = new ImageElement(new int[] {10, 10}, new int[] {100, 100}, loadImage("images/cavalry.png"));
  summonMercenary = new ImageElement(new int[] {120, 10}, new int[] {100, 100}, loadImage("images/mercenary.png"));
  summonLevy = new ImageElement(new int[] {230, 10}, new int[] {100, 100}, loadImage("images/levy.png"));
  summonArcher = new ImageElement(new int[] {340, 10}, new int[] {100, 100}, loadImage("images/archer.png"));
}
