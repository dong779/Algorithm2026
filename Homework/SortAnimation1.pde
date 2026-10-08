int[] values;
int algoType = 1; // 1: 버블 정렬, 2: 선택 정렬, 3: 삽입 정렬

// 정렬 상태 변수
int i = 0;
int j = 0;
int minIndex = 0;   // 선택 정렬용
int insertIdx = 1;  // 삽입 정렬용
int currentKey = 0; // 변수명을 'key' 대신 'currentKey'로 변경하여 내장 변수 충돌 방지
boolean isSorting = false;

void setup() {
  size(800, 500);
  resetArray();
}

void draw() {
  background(30);
  
  // 정렬 진행 (애니메이션 속도를 위해 프레임당 5번 연산)
  if (isSorting) {
    for (int speed = 0; speed < 5; speed++) {
      if (algoType == 1) {
        stepBubbleSort();
      } else if (algoType == 2) {
        stepSelectionSort();
      } else if (algoType == 3) {
        stepInsertionSort();
      }
    }
  }

  // 막대그래프 그리기
  for (int k = 0; k < values.length; k++) {
    if (isSorting && (k == j || k == j + 1 || k == minIndex || k == insertIdx)) {
      fill(255, 90, 90); // 비교 중인 요소는 빨간색
    } else {
      fill(100, 180, 255); // 일반 요소는 파란색
    }
    noStroke();
    rect(k * 10, height - values[k], 8, values[k]);
  }

  // 상단 안내 텍스트 출력
  fill(255);
  textSize(15);
  String name = (algoType == 1) ? "1. Bubble Sort" : (algoType == 2) ? "2. Selection Sort" : "3. Insertion Sort";
  text("Current: " + name, 20, 30);
  text("[1, 2, 3] Change Algo | [SPACE] Start/Pause | [R] Reset", 20, 55);
}

// 1. 버블 정렬 한 단계
void stepBubbleSort() {
  if (i < values.length) {
    if (j < values.length - i - 1) {
      if (values[j] > values[j + 1]) {
        int temp = values[j];
        values[j] = values[j + 1];
        values[j + 1] = temp;
      }
      j++;
    } else {
      j = 0;
      i++;
    }
  } else {
    isSorting = false;
  }
}

// 2. 선택 정렬 한 단계
void stepSelectionSort() {
  if (i < values.length - 1) {
    if (j < values.length) {
      if (values[j] < values[minIndex]) {
        minIndex = j;
      }
      j++;
    } else {
      int temp = values[i];
      values[i] = values[minIndex];
      values[minIndex] = temp;
      i++;
      minIndex = i;
      j = i + 1;
    }
  } else {
    isSorting = false;
  }
}

// 3. 삽입 정렬 한 단계
void stepInsertionSort() {
  if (insertIdx < values.length) {
    if (j == 0) {
      currentKey = values[insertIdx];
      j = insertIdx;
    }
    
    if (j > 0 && values[j - 1] > currentKey) {
      values[j] = values[j - 1];
      j--;
    } else {
      values[j] = currentKey;
      insertIdx++;
      j = 0;
    }
  } else {
    isSorting = false;
  }
}

// 배열 초기화 및 변수 리셋
void resetArray() {
  values = new int[width / 10];
  for (int k = 0; k < values.length; k++) {
    values[k] = int(random(50, height - 50));
  }
  i = 0;
  j = 0;
  minIndex = 0;
  insertIdx = 1;
  isSorting = false;
}

// 키보드 입력 처리 (프로세싱 내장 key 변수와 충돌 안 나도록 수정됨)
void keyPressed() {
  if (key == '1') { algoType = 1; resetArray(); }
  if (key == '2') { algoType = 2; resetArray(); }
  if (key == '3') { algoType = 3; resetArray(); }
  if (key == ' ') { isSorting = !isSorting; } // 스페이스바: 시작/정지
  if (key == 'r' || key == 'R') { resetArray(); }
}
