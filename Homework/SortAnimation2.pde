import java.util.ArrayList;

int[] values;
ArrayList<int[]> history = new ArrayList<int[]>(); 
int currentStep = 0;
boolean isSorting = false;
int algoType = 1; // 1: Merge Sort, 2: Quick Sort, 3: Heap Sort

void setup() {
  size(800, 500);
  resetArray(); // 무작위 배열을 만들고 정렬 과정을 미리 계산해 둠
}

void draw() {
  background(30);
  
  // 스페이스바를 누르고(isSorting = true) 아직 끝까지 가지 않았다면 애니메이션 재생
  if (isSorting) {
    for (int speed = 0; speed < 5; speed++) {
      if (currentStep < history.size()) {
        values = history.get(currentStep);
        currentStep++;
      } else {
        isSorting = false; // 정렬 완료
        break;
      }
    }
  }

  // 막대그래프 그리기
  for (int k = 0; k < values.length; k++) {
    fill(100, 180, 255);
    noStroke();
    rect(k * 10, height - values[k], 8, values[k]);
  }

  // 상단 안내 텍스트 출력
  fill(255);
  textSize(15);
  String name = (algoType == 1) ? "1. Merge Sort" : (algoType == 2) ? "2. Quick Sort" : "3. Heap Sort";
  text("Current: " + name, 20, 30);
  
  if (isSorting) {
    text("Status: Sorting in progress... | [1, 2, 3] Change Algo | [SPACE] Pause | [R] Reset", 20, 55);
  } else {
    text("Status: Ready (Press SPACE to start sorting) | [1, 2, 3] Change Algo | [R] Reset", 20, 55);
  }
}

// 현재 배열 상태를 복사해서 history에 저장
void saveState() {
  int[] copy = new int[values.length];
  arrayCopy(values, copy);
  history.add(copy);
}

// -------------------------------------------------------------------------
// 1. 합병 정렬 (Merge Sort)
// -------------------------------------------------------------------------
void startMergeSort() {
  mergeSort(values, 0, values.length - 1);
}

void mergeSort(int[] arr, int l, int r) {
  if (l < r) {
    int m = l + (r - l) / 2;
    mergeSort(arr, l, m);
    mergeSort(arr, m + 1, r);
    merge(arr, l, m, r);
  }
}

void merge(int[] arr, int l, int m, int r) {
  int n1 = m - l + 1;
  int n2 = r - m;

  int[] L = new int[n1];
  int[] R = new int[n2];

  for (int i = 0; i < n1; i++) L[i] = arr[l + i];
  for (int j = 0; j < n2; j++) R[j] = arr[m + 1 + j];

  int i = 0, j = 0;
  int k = l;
  while (i < n1 && j < n2) {
    if (L[i] <= R[j]) {
      arr[k] = L[i];
      i++;
    } else {
      arr[k] = R[j];
      j++;
    }
    saveState(); 
    k++;
  }

  while (i < n1) {
    arr[k] = L[i];
    i++;
    k++;
    saveState();
  }

  while (j < n2) {
    arr[k] = R[j];
    j++;
    k++;
    saveState();
  }
}

// -------------------------------------------------------------------------
// 2. 퀵 정렬 (Quick Sort)
// -------------------------------------------------------------------------
void startQuickSort() {
  quickSort(values, 0, values.length - 1);
}

void quickSort(int[] arr, int low, int high) {
  if (low < high) {
    int pi = partition(arr, low, high);
    quickSort(arr, low, pi - 1);
    quickSort(arr, pi + 1, high);
  }
}

int partition(int[] arr, int low, int high) {
  int pivot = arr[high];
  int i = (low - 1);
  for (int j = low; j < high; j++) {
    if (arr[j] < pivot) {
      i++;
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
      saveState(); 
    }
  }
  int temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;
  saveState();
  
  return i + 1;
}

// -------------------------------------------------------------------------
// 3. 힙 정렬 (Heap Sort)
// -------------------------------------------------------------------------
void startHeapSort() {
  int n = values.length;

  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(values, n, i);
  }

  for (int i = n - 1; i > 0; i--) {
    int temp = values[0];
    values[0] = values[i];
    values[i] = temp;
    saveState(); 

    heapify(values, i, 0);
  }
}

void heapify(int[] arr, int n, int i) {
  int largest = i;
  int l = 2 * i + 1;
  int r = 2 * i + 2;

  if (l < n && arr[l] > arr[largest]) largest = l;
  if (r < n && arr[r] > arr[largest]) largest = r;

  if (largest != i) {
    int swap = arr[i];
    arr[i] = arr[largest];
    arr[largest] = swap;
    saveState(); 

    heapify(arr, n, largest);
  }
}

// -------------------------------------------------------------------------
// 제어 함수
// -------------------------------------------------------------------------
void resetArray() {
  // 1. 무작위 배열 생성
  values = new int[width / 10];
  for (int k = 0; k < values.length; k++) {
    values[k] = int(random(50, height - 50));
  }
  
  history.clear();
  
  // 2. [중요] 정렬을 시작하기 전의 '최초 무작위 상태'를 히스토리의 0번으로 강제 저장!
  saveState(); 
  
  // 3. 임시 배열을 복사해서 정렬 과정을 백그라운드에서 계산 후 녹화
  int[] backup = new int[values.length];
  arrayCopy(values, backup);
  
  if (algoType == 1) {
    startMergeSort();
  } else if (algoType == 2) {
    startQuickSort();
  } else if (algoType == 3) {
    startHeapSort();
  }
  
  // 정렬 계산이 끝나면 실제 화면 데이터는 다시 최초의 무작위 상태로 복원
  arrayCopy(backup, values);
  
  currentStep = 0;      // 애니메이션 재생 인덱스를 처음(0번)으로 설정
  isSorting = false;    // 스페이스바를 누르기 전까지는 대기 상태 유지
}

void keyPressed() {
  if (key == '1') { algoType = 1; resetArray(); }
  if (key == '2') { algoType = 2; resetArray(); }
  if (key == '3') { algoType = 3; resetArray(); }
  
  // 스페이스바를 누르면 정지 <-> 시작 전환
  if (key == ' ') { 
    isSorting = !isSorting; 
  } 
  
  if (key == 'r' || key == 'R') { 
    resetArray(); 
  }
}
