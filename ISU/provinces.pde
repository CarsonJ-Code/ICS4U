ArrayList<Province> provinces = new ArrayList<Province>();

class Province {
  ArrayList<ArrayList<float[]>> coords;
  int controller;
  String name;

  Province(ArrayList<ArrayList<float[]>> coordsArg, String nameArg) {
    coords = coordsArg;
    name = nameArg;
    controller = 0;
  }

  Province(ArrayList<ArrayList<float[]>> coordsArg, String nameArg, int controllerArg) {
    coords = coordsArg;
    name = nameArg;
    controller = controllerArg;
  }

  void draw() {

    for (int i = 0; i < coords.size(); i++) {
      ArrayList<float[]> currPoly = coords.get(i);
      beginShape();
      for (int j = 0; j < currPoly.size(); j++) {
        float[] point = posToScreenSpace(currPoly.get(j));
        vertex(point[0], point[1]);
      }
      endShape();
    }
  }
}

void loadProvinces() {
  JSONObject geojson = loadJSONObject("Isles.geojson");
  JSONArray features = geojson.getJSONArray("features");

  for (int i = 0; i < features.size(); i++) {
    JSONObject feature  = features.getJSONObject(i);
    JSONObject geometry = feature.getJSONObject("geometry");
    JSONObject properties = feature.getJSONObject("properties");
    JSONArray  coords   = geometry.getJSONArray("coordinates");
    String     geomType = geometry.getString("type");
    String         name = properties.isNull("SETTL_NAME") ? "Unknown" : properties.getString("SETTL_NAME");

    ArrayList<ArrayList<float[]>> provCoords = new ArrayList<ArrayList<float[]>>();


    if (geomType.equals("Polygon")) {
      // Only process the outer ring (index 0), skip holes (index 1+)
      JSONArray outerRing = coords.getJSONArray(0);
      ArrayList<float[]> shape = new ArrayList<float[]>();

      for (int j = 0; j < outerRing.size(); j++) {
        JSONArray point = outerRing.getJSONArray(j);
        shape.add(new float[]{ point.getFloat(0), -point.getFloat(1) });
      }
      provCoords.add(shape);
    } else if (geomType.equals("MultiPolygon")) {
      // Each polygon in the multipolygon becomes its own shape entry
      for (int p = 0; p < coords.size(); p++) {
        JSONArray polygon  = coords.getJSONArray(p);
        JSONArray outerRing = polygon.getJSONArray(0);
        ArrayList<float[]> shape = new ArrayList<float[]>();

        for (int j = 0; j < outerRing.size(); j++) {
          JSONArray point = outerRing.getJSONArray(j);
          shape.add(new float[]{ point.getFloat(0), -point.getFloat(1) });
        }

        provCoords.add(shape);
      }
    }
    provinces.add(new Province(provCoords, name));
  }
}
