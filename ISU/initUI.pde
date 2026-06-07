TextElement provinceName;
RectElement provinceBox;
TextElement provinceController;
TextElement provinceNeighbours;

RectElement activeTroopInfo;
TextElement activeTroopOwner;
TextElement activeTroopHealth;
TextElement activeTroopStrength;

RectElement wealthBox;
TextElement wealthValue;
ImageElement wealthSymbol;

void initUI() {
  initProvinceView();
  initTroopView();
  initWealthView();
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
  wealthSymbol = new ImageElement(new int[] {1480, 20}, new int[] {100, 100}, loadImage("money.png"));
}
