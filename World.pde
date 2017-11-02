import java.util.*; //<>// //<>// //<>//

class World {

  Node [][] grid;
  Vector<Node> open_list;
  Vector<Node> closed_list;
  Vector<Node> path_list;
  Vector<Node> obstacle_list;

  World() {
    grid = new Node[col][row];
    open_list = new Vector<Node>();
    closed_list = new Vector<Node>();
    path_list = new Vector<Node>();
    obstacle_list = new Vector<Node>();
    init_grid();
  }

  void init_grid() {
    for (int i=0; i<col; i++)
      for (int j=0; j<row; j++) 
        grid[i][j] = new Node(i * cell_tam + cell_tam / 2, j * cell_tam + cell_tam / 2);
  }

  void draw_world() {
    for (int i=0; i<col; i++)
      line(cell_tam*i, 0, cell_tam*i, height);

    for (int j=0; j<row; j++) 
      line(0, cell_tam*j, width, cell_tam*j);



    fill(0);
    for (Node n : closed_list)
      n.draw_node();

    fill(135, 0, 142);
    for (Node n : open_list)
      n.draw_node();
    //Vector<Node> vec = get_neighbors(test_init);

    fill(232, 193, 2);
    for (Node n : path_list)
      ellipse(n.x, n.y, 10, 10);
      
    fill(255);
    for (Node n : obstacle_list)
      ellipse(n.x, n.y, 10, 10);

    fill(255);
    test_init.draw_node();
    fill(150);
    test_end.draw_node();
  }

  boolean aSTAR(Node init, Node end) {
    open_list = new Vector<Node>();
    closed_list = new Vector<Node>();
    path_list = new Vector<Node>();
    init.f = init.heuristic(end);
    int index = 0, C = 1;
    open_list.add(init);

    while (!open_list.isEmpty()) {
      Node N = least_f(open_list);
      open_list.remove(is_in(N,open_list));
      closed_list.add(N);

      if (is_goal(N, end)) {
        path_list = build_path(N);
        return true;
      }

      Vector<Node> sucessors = get_neighbors(N);
      for (Node n : sucessors) {
        n.g = N.g + C;

        index = is_in(n, open_list);
        if (index != open_list.size()) {
          if (open_list.get(index).g > n.g) {
            exit();
          }
        } else if (is_in(n, closed_list) != closed_list.size()) {
          Node viejo = closed_list.get(is_in(n, closed_list));
          if (viejo.g > n.g)
            exit();
        } else {
          n.f = n.g + n.heuristic(end);
          open_list.add(n);
        }
      }
    }
    return false;
  }

  Vector<Node> get_neighbors(Node n) {
    /*
     *
     *  HAY QUE MODIFICAR EL GRID PARA QUE GET NEIGHBORS DETECTE SI UN VECINO TIENE NINIOS
     *
     */
    Vector<Node> neighbors = new Vector<Node>();
    int x = n.x / cell_tam;
    int y = n.y / cell_tam;

    if (x > 0)
      neighbors.add(grid[x-1][y]);
    if (x < col - 1)
      neighbors.add(grid[x+1][y]);
    if (y > 0)
      neighbors.add(grid[x][y-1]);
    if (y < row - 1)
      neighbors.add(grid[x][y+1]);

    return set_parents(neighbors, n);
    //return neighbors;
  }

  Vector<Node> set_parents(Vector<Node> v_nodes, Node parent) {
    Vector<Node> aux = new Vector<Node>();
    for (Node n : v_nodes) {
      if (n != parent.parent && !n.obstacle && is_in(n,open_list) == open_list.size() && is_in(n,closed_list) == closed_list.size()) {
        n.parent = parent;
        aux.add(n);
      }
    }
    return aux;
  }

  Node least_f(Vector<Node> v_nodes) {

    Node aux = v_nodes.firstElement();

    for (Node n : v_nodes)
      if (n.f < aux.f)
        aux = n;

    return aux;
  }

  int is_in(Node a, Vector<Node> v_nodes) {
    int index = 0;

    for (Node n : v_nodes) {
      if (is_goal(a, n))
        break;
      index++;
    }  
    return index;
  }

  boolean is_goal(Node a, Node b) {
    if (a.x == b.x && a.y == b.y)
      return true;
    return false;
  }

  void set_obstacles() {

    for (int i = 0; i < col; i++) 
      for (int j = 0; j < row; j++) 
        if (random(0, 100) > 75) {
          grid[i][j].obstacle = true;
          obstacle_list.add(new Node(grid[i][j].x, grid[i][j].y));
        }
  }

  Vector<Node> build_path(Node n) {
    Vector<Node> path = new Vector<Node>();
    Node aux = n;
    path.add(aux);
    while (aux.parent != null) {
      aux = aux.parent;
      path.add(aux);
    }
    return path;
  }
}