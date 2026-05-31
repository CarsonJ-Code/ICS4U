TextElement provinceName;
RectElement provinceBox;
TextElement provinceController;
TextElement provinceNeighbours;

void initProvinceView(){
  provinceBox = new RectElement(new int[] {0, 500}, new int[]{200, 400}, color(#444444));
  provinceName = new TextElement(new int[] {10, 550}, new int[]{180, 100}, "None", 24, color(#FFFFFF));
  provinceController = new TextElement(new int[] {10, 650}, new int[]{180, 100}, "None", 24, color(#FFFFFF));
  provinceNeighbours = new TextElement(new int[] {10, 750}, new int[]{180, 900}, "None", 18, color(#FFFFFF));
}
