ArrayList<Province> provinces = new ArrayList<Province>();

class Province {
  ArrayList<ArrayList<float[]>> coords;
  int controller;
  String name;

  float minX;
  float maxX;
  float minY;
  float maxY;

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

  void findBounding() {
    float[] firstCoord = coords.get(0).get(0);
    minX = firstCoord[0];
    maxX = firstCoord[0];
    minY = firstCoord[1];
    maxY = firstCoord[1];
    
    for (int i = 0; i < coords.size(); i++) {
      ArrayList<float[]> currPoly = coords.get(i);
      for (int j = 0; j < currPoly.size(); j++) {
        float[] coord = currPoly.get(j);

        if (coord[0] < minX) minX = coord[0];
        if (coord[0] > maxX) maxX = coord[0];

        if (coord[1] < minY) minY = coord[1];
        if (coord[1] > maxY) maxY = coord[1];
      }
    }
  }


  boolean inProvince(float[] test) {
    if (test[0] >= minX && test[0] <= maxX && test[1] >= minY && test[1] <= maxY) {

      // test each polygon
      for (int polyCount = 0; polyCount < coords.size(); polyCount++) {
        boolean inside = false;
        ArrayList<float[]> currPoly = coords.get(polyCount);

        // test each edge with a line
        for (int i = 0, j = currPoly.size() - 1; i < currPoly.size(); j = i, i++) {
          float[] frontPoint = currPoly.get(i);
          float[] backPoint = currPoly.get(j);
          float xIntersect = (frontPoint[0] - backPoint[0]) * (test[1] - backPoint[1]) / (frontPoint[1] - backPoint[1]) + backPoint[0];

          if ((frontPoint[1] > test[1] ^ backPoint[1] > test[1]) && (test[0] < xIntersect)) {
            inside = !inside;
          }
        }
        if (inside) return true;
      }
    }
    return false;
  }

  String getName() {
    return name;
  }
}



void loadProvinces() {
  JSONObject geojson = loadJSONObject("FinalIsles.geojson");
  JSONArray features = geojson.getJSONArray("features");

  for (int i = 0; i < features.size(); i++) {
    JSONObject feature  = features.getJSONObject(i);
    JSONObject geometry = feature.getJSONObject("geometry");
    JSONObject properties = feature.getJSONObject("properties");
    JSONArray  coords   = geometry.getJSONArray("coordinates");
    String     geomType = geometry.getString("type");
    String         name = properties.isNull("name") ? "Unknown" : properties.getString("name");

    ArrayList<ArrayList<float[]>> provCoords = new ArrayList<ArrayList<float[]>>();


    if (geomType.equals("Polygon")) {
      // Only process the outer ring (index 0), skip holes (index 1+)
      JSONArray outerRing = coords.getJSONArray(0);
      ArrayList<float[]> shape = new ArrayList<float[]>();

      for (int j = 0; j < outerRing.size(); j++) {
        JSONArray point = outerRing.getJSONArray(j);
        shape.add(new float[]{ point.getFloat(0) - 904750, -point.getFloat(1) + 1255375});
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
          shape.add(new float[]{ point.getFloat(0) - 904750, -point.getFloat(1) + 1255375});
        }

        provCoords.add(shape);
      }
    }
    provinces.add(new Province(provCoords, name));
  }
}
