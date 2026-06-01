import java.util.*;

/**
 * Graph — weighted, undirected graph with Dijkstra shortest-path.
 *
 * Usage:
 *   Graph g = new Graph();
 *   g.addNode(0);
 *   g.addNode(1);
 *   g.addEdge(0, 1, 4.0);
 *   ArrayList<Integer> path = g.shortestPath(0, 1);
 *   float dist = g.shortestDistance(0, 1);
 */
class Graph {

  // ── Internal types ──────────────────────────────────────────────────────────

  class Edge {
    int   to;
    float weight;
    Edge(int to, float weight) {
      this.to     = to;
      this.weight = weight;
    }
    int getNode() {
      return to;
    }
  }

  // Comparable entry used by Dijkstra's priority queue
  class Entry implements Comparable<Entry> {
    int   node;
    float cost;
    Entry(int node, float cost) {
      this.node = node;
      this.cost = cost;
    }
    public int compareTo(Entry other) {
      return Float.compare(this.cost, other.cost);
    }
  }

  // ── Storage ─────────────────────────────────────────────────────────────────

  private HashMap<Integer, ArrayList<Edge>> adj;   // adjacency list
  private boolean directed;                         // true → directed graph

  // ── Constructors ─────────────────────────────────────────────────────────────

  /** Creates an undirected graph. */
  Graph() {
    this(false);
  }

  /** Creates a directed or undirected graph. */
  Graph(boolean directed) {
    this.directed = directed;
    adj = new HashMap<Integer, ArrayList<Edge>>();
  }

  // ── Mutation ─────────────────────────────────────────────────────────────────

  /** Adds a node if it does not already exist. */
  void addNode(int id) {
    if (!adj.containsKey(id)) adj.put(id, new ArrayList<Edge>());
  }

  /**
   * Adds a weighted edge between from and to (weight-1 default for unweighted use).
   * Nodes are created automatically if missing.
   */
  void addEdge(int from, int to, float weight) {
    addNode(from);
    addNode(to);
    adj.get(from).add(new Edge(to, weight));
    if (!directed) adj.get(to).add(new Edge(from, weight));
  }

  /** Convenience overload — unit weight. */
  void addEdge(int from, int to) {
    addEdge(from, to, 1.0);
  }

  /** Removes a node and all its incident edges. */
  void removeNode(int id) {
    adj.remove(id);
    for (ArrayList<Edge> edges : adj.values()) {
      Iterator<Edge> it = edges.iterator();
      while (it.hasNext()) {
        if (it.next().to == id) it.remove();
      }
    }
  }

  /** Removes a specific edge (both directions for undirected). */
  void removeEdge(int from, int to) {
    removeDirectedEdge(from, to);
    if (!directed) removeDirectedEdge(to, from);
  }

  private void removeDirectedEdge(int from, int to) {
    if (!adj.containsKey(from)) return;
    Iterator<Edge> it = adj.get(from).iterator();
    while (it.hasNext()) {
      if (it.next().to == to) {
        it.remove();
        break;
      }
    }
  }

  // ── Queries ───────────────────────────────────────────────────────────────────

  /** Returns true if the node exists in the graph. */
  boolean hasNode(int id) {
    return adj.containsKey(id);
  }

  /** Returns true if there is a direct edge from → to. */
  boolean hasEdge(int from, int to) {
    if (!adj.containsKey(from)) return false;
    for (Edge e : adj.get(from)) if (e.to == to) return true;
    return false;
  }

  /** Returns all node IDs. */
  Set<Integer> nodes() {
    return adj.keySet();
  }

  /** Returns neighbour IDs of a node. */
  ArrayList<Integer> neighbours(int id) {
    ArrayList<Integer> ns = new ArrayList<Integer>();
    if (!adj.containsKey(id)) return ns;
    for (Edge e : adj.get(id)) ns.add(e.to);
    return ns;
  }

  String neighboursAsString(int id) {
    String neighbours = "";
    boolean first = true;
    if (!adj.containsKey(id)) return neighbours;
    for (Edge e : adj.get(id)) {
      int nodeID = e.getNode();
      if (first) neighbours += provinceNames.get(nodeID);
      else neighbours += (", " + provinceNames.get(nodeID));
      first = false;
    }
    return neighbours;
  }

  /** Number of nodes. */
  int nodeCount() {
    return adj.size();
  }

  /** Number of directed edges stored. */
  int edgeCount() {
    int total = 0;
    for (ArrayList<Edge> edges : adj.values()) total += edges.size();
    return directed ? total : total / 2;
  }

  // ── Shortest path (Dijkstra) ──────────────────────────────────────────────────

  /**
   * Returns the ordered list of node IDs forming the shortest path from start to end,
   * inclusive. Returns an empty list if no path exists.
   */
  ArrayList<Integer> shortestPath(int start, int end) {
    if (!adj.containsKey(start) || !adj.containsKey(end)) return new ArrayList<Integer>();

    HashMap<Integer, Float>   dist = new HashMap<Integer, Float>();
    HashMap<Integer, Integer> prev = new HashMap<Integer, Integer>();
    PriorityQueue<Entry>      pq   = new PriorityQueue<Entry>();

    for (int n : adj.keySet()) dist.put(n, Float.MAX_VALUE);
    dist.put(start, 0.0);
    pq.add(new Entry(start, 0.0));

    while (!pq.isEmpty()) {
      Entry cur = pq.poll();
      if (cur.cost > dist.get(cur.node)) continue;  // stale entry
      if (cur.node == end) break;                    // found

      for (Edge e : adj.get(cur.node)) {
        float newCost = dist.get(cur.node) + e.weight;
        if (newCost < dist.get(e.to)) {
          dist.put(e.to, newCost);
          prev.put(e.to, cur.node);
          pq.add(new Entry(e.to, newCost));
        }
      }
    }

    // Reconstruct path
    ArrayList<Integer> path = new ArrayList<Integer>();
    if (!prev.containsKey(end) && start != end) return path; // unreachable

    for (Integer at = end; at != null; at = prev.get(at)) path.add(0, at);
    return path;
  }

  /**
   * Returns the total cost of the shortest path, or Float.MAX_VALUE if unreachable.
   */
  float shortestDistance(int start, int end) {
    ArrayList<Integer> path = shortestPath(start, end);
    if (path.isEmpty()) return Float.MAX_VALUE;

    float total = 0;
    for (int i = 0; i < path.size() - 1; i++) {
      int from = path.get(i), to = path.get(i + 1);
      for (Edge e : adj.get(from)) {
        if (e.to == to) {
          total += e.weight;
          break;
        }
      }
    }
    return total;
  }

  /** Returns a human-readable description of the graph. */
  String describe() {
    StringBuilder sb = new StringBuilder();
    sb.append("Graph [" + nodeCount() + " nodes, " + edgeCount() + " edges]\n");
    for (int node : adj.keySet()) {
      sb.append("  " + node + " → ");
      ArrayList<Edge> edges = adj.get(node);
      for (int i = 0; i < edges.size(); i++) {
        sb.append(edges.get(i).to + "(" + edges.get(i).weight + ")");
        if (i < edges.size() - 1) sb.append(", ");
      }
      sb.append("\n");
    }
    return sb.toString();
  }
}
