class Graph {
  boolean[][] verticeArray;
  float[][] verticeLocation;
  
  Graph(boolean[][] verticeArgs, float[][] locationArgs){
   verticeArray = verticeArgs;
   verticeLocation = locationArgs;
  }
  
  ArrayList<int> dijkstraPath(int startIndex, int endIndex){
    boolean[] bordering = verticeArray[startIndex];
    
  }
}
