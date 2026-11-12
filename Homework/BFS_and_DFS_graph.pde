import java.util.ArrayList;
import java.util.Collections;

int numNodes = 8;

// 노드 좌표 배열
float[] nodeX = new float[numNodes];
float[] nodeY = new float[numNodes];

// 인접 리스트 및 간선 데이터
ArrayList[] adjList = new ArrayList[numNodes];
ArrayList<String> orderedPairs = new ArrayList<String>();

String currentMode = "DFS"; // 기본 모드: DFS
IntList fullResultList = new IntList(); 
int animStep = 0; 
boolean[] visitedArray;

void setup() {
  size(1000, 750);
  textSize(15);
  
  for (int i = 0; i < numNodes; i++) {
    adjList[i] = new ArrayList<Integer>();
  }
  
  generateRandomGraph();
}

void draw() {
  background(30, 34, 42);
  
  // 1. 상단 안내 및 Ordered Pairs 출력
  fill(220);
  textSize(14);
  text("Mode: " + currentMode + "  |  [b] BFS  |  [d] DFS  |  [r] New Random Graph", 40, 35);
  text("Press ANY KEY to step forward (Next Node)", 40, 60);
  
  fill(100, 220, 255);
  String pairsStr = "Ordered Pairs (Edges): { ";
  for (int i = 0; i < orderedPairs.size(); i++) {
    pairsStr += orderedPairs.get(i);
    if (i < orderedPairs.size() - 1) pairsStr += ", ";
  }
  pairsStr += " }";
  text(pairsStr, 40, 90);
  
  // 2. 간선(Edge) 그리기
  stroke(160, 180, 210);
  strokeWeight(4);
  for (int u = 0; u < numNodes; u++) {
    ArrayList neighbors = adjList[u];
    for (int k = 0; k < neighbors.size(); k++) {
      int v = (Integer) neighbors.get(k);
      if (u < v) {
        line(nodeX[u], nodeY[u], nodeX[v], nodeY[v]);
      }
    }
  }
  
  // 3. 노드(Node) 및 상태 시각화
  for (int i = 0; i < numNodes; i++) {
    boolean isVisitedInAnim = false;
    int visitOrderNum = -1;
    for (int stepIdx = 0; stepIdx < animStep; stepIdx++) {
      if (fullResultList.get(stepIdx) == i) {
        isVisitedInAnim = true;
        visitOrderNum = stepIdx + 1;
        break;
      }
    }
    
    // 방문된 노드는 초록색, 미방문은 파란색
    if (isVisitedInAnim) {
      fill(50, 200, 120);
      stroke(255);
    } else {
      fill(70, 150, 230);
      stroke(255);
    }
    strokeWeight(2);
    ellipse(nodeX[i], nodeY[i], 55, 55);
    
    // 노드 번호 (0 ~ 7)
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(i, nodeX[i], nodeY[i] - 2);
    
    // 방문 순서 번호 표시
    if (isVisitedInAnim) {
      fill(255, 255, 0);
      textSize(11);
      text("#" + visitOrderNum, nodeX[i], nodeY[i] + 38);
    }
  }
  
  // 4. 하단 탐색 경로 결과 출력 ('->' 형식)
  fill(255);
  textSize(18);
  textAlign(LEFT, CENTER);
  
  String resultStr = currentMode + " Result: ";
  for (int i = 0; i < animStep; i++) {
    resultStr += fullResultList.get(i);
    if (i < animStep - 1) {
      resultStr += " -> ";
    }
  }
  text(resultStr, 40, 695);
}

// 📌 원형 대신 자유로운 무작위 위치에서 노드끼리 밀어내어 선 겹침을 방지하는 물리 정렬 함수
void solveFreeLayout() {
  for (int step = 0; step < 150; step++) {
    float minDistance = 150.0; // 노드 간 최소 확보 거리
    float centerX = width / 2.0;
    float centerY = height / 2.0 + 20;
    
    for (int i = 0; i < numNodes; i++) {
      // 화면 중앙으로 살짝 당겨주는 약한 인력 (화면 밖으로 탈출 방지)
      nodeX[i] += (centerX - nodeX[i]) * 0.015;
      nodeY[i] += (centerY - nodeY[i]) * 0.015;
      
      // 다른 노드들과의 반발력 (가까이 있으면 강하게 밀어냄)
      for (int j = 0; j < numNodes; j++) {
        if (i == j) continue;
        float dx = nodeX[i] - nodeX[j];
        float dy = nodeY[i] - nodeY[j];
        float d = sqrt(dx * dx + dy * dy);
        
        if (d < minDistance && d > 0) {
          float force = (minDistance - d) * 0.1;
          nodeX[i] += (dx / d) * force;
          nodeY[i] += (dy / d) * force;
        }
      }
      
      // 화면 경계선 침범 방지
      nodeX[i] = constrain(nodeX[i], 90, width - 90);
      nodeY[i] = constrain(nodeY[i], 140, height - 100);
    }
  }
}

// [핵심] 누를 때마다 완전히 새롭고 자유로운 모형으로 랜덤 생성
void generateRandomGraph() {
  for (int i = 0; i < numNodes; i++) {
    adjList[i].clear();
  }
  orderedPairs.clear();
  
  // 모든 노드를 화면 전체에 완전히 무작위로 뿌려줌
  for (int i = 0; i < numNodes; i++) {
    nodeX[i] = random(120, width - 120);
    nodeY[i] = random(160, height - 140);
  }
  
  // 1. 모든 노드가 끊기지 않고 연결되도록 무작위 트리 구조 생성
  boolean[] connected = new boolean[numNodes];
  connected[0] = true;
  
  for (int i = 1; i < numNodes; i++) {
    IntList pool = new IntList();
    for (int j = 0; j < i; j++) {
      if (connected[j]) pool.append(j);
    }
    int parent = pool.get(int(random(pool.size())));
    addEdge(parent, i);
    connected[i] = true;
  }
  
  // 2. 단조롭지 않도록 복잡하지 않은 수준의 추가 간선 1~2개만 무작위 삽입
  int extraEdges = int(random(1, 3));
  for (int k = 0; k < extraEdges; k++) {
    int u = int(random(numNodes));
    int v = int(random(numNodes));
    if (u != v) {
      addEdge(u, v);
    }
  }
  
  // 3. 무작위 위치에서 시작해 선이 겹치지 않도록 물리적으로 자리를 찾아 정렬
  solveFreeLayout();
  
  runTraversal();
}

void addEdge(int u, int v) {
  if (!adjList[u].contains(v)) {
    adjList[u].add(v);
    adjList[v].add(u);
    int minNode = min(u, v);
    int maxNode = max(u, v);
    String pair = "(" + minNode + ", " + maxNode + ")";
    if (!orderedPairs.contains(pair)) {
      orderedPairs.add(pair);
    }
  }
}

void runTraversal() {
  animStep = 1; 
  if (currentMode.equals("BFS")) {
    fullResultList = bfs(0);
  } else {
    fullResultList = dfs(0);
  }
}

// BFS 알고리즘 구현
IntList bfs(int start) {
  IntList order = new IntList();
  boolean[] visited = new boolean[numNodes];
  IntList q = new IntList();
  
  q.append(start);
  visited[start] = true;
  
  while (q.size() > 0) {
    int curr = q.remove(0);
    order.append(curr);
    
    ArrayList neighbors = adjList[curr];
    Collections.sort(neighbors);
    for (int k = 0; k < neighbors.size(); k++) {
      int next = (Integer) neighbors.get(k);
      if (!visited[next]) {
        visited[next] = true;
        q.append(next);
      }
    }
  }
  return order;
}

// DFS 알고리즘 구현
IntList dfs(int start) {
  IntList order = new IntList();
  boolean[] visited = new boolean[numNodes];
  IntList s = new IntList();
  
  s.append(start);
  
  while (s.size() > 0) {
    int curr = s.remove(s.size() - 1);
    
    if (!visited[curr]) {
      visited[curr] = true;
      order.append(curr);
      
      ArrayList neighbors = adjList[curr];
      Collections.sort(neighbors);
      for (int k = neighbors.size() - 1; k >= 0; k--) {
        int next = (Integer) neighbors.get(k);
        if (!visited[next]) {
          s.append(next);
        }
      }
    }
  }
  return order;
}

// 키보드 조작 함수
void keyPressed() {
  if (key == 'b' || key == 'B') {
    currentMode = "BFS";
    runTraversal();
  } else if (key == 'd' || key == 'D') {
    currentMode = "DFS";
    runTraversal();
  } else if (key == 'r' || key == 'R') {
    generateRandomGraph(); // 누를 때마다 완전히 새로운 자유 무작위 모형 생성
  } else {
    if (animStep < fullResultList.size()) {
      animStep++;
    }
  }
}
