int rows = 3;
int cols = 8; // 열의 개수
int[][] grid = new int[rows][cols];
int[][] dp = new int[cols][4];      
int[][] parent = new int[cols][4];  
int[] bestPebbles = new int[cols];  
int[] currentStepBestPattern = new int[cols]; // 각 단계별로 선택된 최적의 패턴 임시 저장

int[][] patterns = {
  {1, 0, 0}, // 패턴 0: 1행
  {0, 1, 0}, // 패턴 1: 2행
  {0, 0, 1}, // 패턴 2: 3행
  {1, 0, 1}  // 패턴 3: 1행, 3행
};

boolean[][] compatible = {
  {false, true,  true,  false}, 
  {true,  false, true,  true},  
  {true,  true,  false, false}, 
  {false, true,  false, false}  
};

int maxTotalScore = 0;
int cellSize = 80;
int marginX = 60;
int marginY = 100;

int stepState = 0; // 0: 초기화 완료, 1 ~ cols-1: 각 열 DP 계산 중, cols: 역추적 및 완료
String statusMessage = "";

void setup() {
  size(760, 440);
  textAlign(CENTER, CENTER);
  resetSimulation();
}

void draw() {
  background(245);
  
  // 상단 안내 텍스트
  fill(30);
  textSize(19);
  text("Pebble Placement Problem (Step-by-Step DP)", width / 2, 35);
  
  textSize(14);
  fill(180, 50, 50);
  text("Max Score: " + (stepState >= cols ? maxTotalScore : "Calculating..."), width / 2, 62);
  
  textSize(13);
  fill(50, 120, 50);
  text(statusMessage, width / 2, height - 25);
  
  // 그리드 및 상태 그리기
  for (int c = 0; c < cols; c++) {
    int chosenPattern = -1;
    if (stepState >= cols) {
      chosenPattern = bestPebbles[c];
    } else if (c <= stepState) {
      chosenPattern = currentStepBestPattern[c];
    }
    
    for (int r = 0; r < rows; r++) {
      int x = marginX + c * cellSize;
      int y = marginY + r * cellSize;
      
      // 셀 배경 (현재 계산 중인 열은 주황빛 테두리 강조)
      stroke(180);
      strokeWeight(2);
      if (stepState < cols && c == stepState) {
        stroke(255, 140, 0);
        strokeWeight(4);
      }
      fill(255);
      rect(x, y, cellSize, cellSize);
      
      // 계산이 완료되었거나 진행된 열의 조약돌 표시 (노란색 원)
      if (chosenPattern != -1 && patterns[chosenPattern][r] == 1) {
        fill(255, 215, 0, 220);
        noStroke();
        ellipse(x + cellSize / 2, y + cellSize / 2, cellSize * 0.7, cellSize * 0.7);
        stroke(180);
        strokeWeight(2);
      }
      
      // 셀 점수 숫자 표시
      fill(20);
      textSize(18);
      text(grid[r][c], x + cellSize / 2, y + cellSize / 2);
    }
    
    // 하단 열 번호 및 패턴 표시 (따옴표 오류 수정 완료)
    fill(100);
    textSize(12);
    if (stepState >= cols) {
      text("Col " + c + "\n(P" + chosenPattern + ")", marginX + c * cellSize + cellSize / 2, marginY + rows * cellSize + 25);
    } else if (c <= stepState) {
      text("Col " + c + "\n(P" + chosenPattern + ")", marginX + c * cellSize + cellSize / 2, marginY + rows * cellSize + 25);
    } else {
      text("Col " + c + "\n(Wait)", marginX + c * cellSize + cellSize / 2, marginY + rows * cellSize + 25);
    }
  }
}

// 아무 키나 누를 때 실행
void keyPressed() {
  if (stepState < cols) {
    stepState++;
    if (stepState < cols) {
      computeStep(stepState);
    } else {
      finalizeDP();
    }
  } else {
    resetSimulation();
  }
}

void resetSimulation() {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      grid[r][c] = int(random(-5, 16));
    }
  }
  
  stepState = 0;
  
  int bestP = 0;
  int maxVal = -999999;
  for (int p = 0; p < 4; p++) {
    dp[0][p] = getPatternScore(0, p);
    parent[0][p] = -1;
    if (dp[0][p] > maxVal) {
      maxVal = dp[0][p];
      bestP = p;
    }
  }
  currentStepBestPattern[0] = bestP;
  
  statusMessage = "[키를 누르세요] 0번 열 선택 완료 (P" + bestP + "). 다음: 1번 열 계산";
}

void computeStep(int c) {
  for (int currP = 0; currP < 4; currP++) {
    int maxPrev = -999999;
    int bestPrevP = -1;
    
    for (int prevP = 0; prevP < 4; prevP++) {
      if (compatible[prevP][currP]) {
        if (dp[c - 1][prevP] > maxPrev) {
          maxPrev = dp[c - 1][prevP];
          bestPrevP = prevP;
        }
      }
    }
    
    dp[c][currP] = maxPrev + getPatternScore(c, currP);
    parent[c][currP] = bestPrevP;
  }
  
  int bestCurrP = -1;
  int maxVal = -999999;
  for (int p = 0; p < 4; p++) {
    if (dp[c][p] > maxVal) {
      maxVal = dp[c][p];
      bestCurrP = p;
    }
  }
  currentStepBestPattern[c] = bestCurrP;
  
  if (c < cols - 1) {
    statusMessage = "[키를 누르세요] " + c + "번 열 선택 완료 (P" + bestCurrP + "). 다음: " + (c + 1) + "번 열";
  } else {
    statusMessage = "[키를 누르세요] 마지막 열 계산 완료! (다음: 최종 최적 경로 역추적)";
  }
}

void finalizeDP() {
  maxTotalScore = -999999;
  int lastBestP = -1;
  for (int p = 0; p < 4; p++) {
    if (dp[cols - 1][p] > maxTotalScore) {
      maxTotalScore = dp[cols - 1][p];
      lastBestP = p;
    }
  }
  
  int currP = lastBestP;
  for (int c = cols - 1; c >= 0; c--) {
    bestPebbles[c] = currP;
    currP = parent[c][currP];
  }
  
  statusMessage = "[완료] 역추적 완료! 최종 최적 조약돌 배치 표시 중 (아무 키나: 새 게임)";
}

int getPatternScore(int col, int p) {
  int sum = 0;
  for (int r = 0; r < rows; r++) {
    if (patterns[p][r] == 1) {
      sum += grid[r][col];
    }
  }
  return sum;
}
