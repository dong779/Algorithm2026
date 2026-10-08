int[] values;
int algoType = 1; 

int i = 0;
int j = 0;
int minIndex = 0;   
int insertIdx = 1; 
int currentKey = 0;
boolean isSorting = false;

void setup() {
  size(800, 500);
  resetArray();
}

void draw() {
  background(30);
  
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


  for (int k = 0; k < values.length; k++) {
    if (isSorting && (k == j || k == j + 1 || k == minIndex || k == insertIdx)) {
      fill(255, 90, 90); 
    } else {
      fill(100, 180, 255);
    }
    noStroke();
    rect(k * 10, height - values[k], 8, values[k]);
  }

  fill(255);
  textSize(15);
  String name = (algoType == 1) ? "1. Bubble Sort" : (algoType == 2) ? "2. Selection Sort" : "3. Insertion Sort";
  text("Current: " + name, 20, 30);
  text("[1, 2, 3] Change Algo | [SPACE] Start/Pause | [R] Reset", 20, 55);
}

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

void keyPressed() {
  if (key == '1') { algoType = 1; resetArray(); }
  if (key == '2') { algoType = 2; resetArray(); }
  if (key == '3') { algoType = 3; resetArray(); }
  if (key == ' ') { isSorting = !isSorting; } 
  if (key == 'r' || key == 'R') { resetArray(); }
}
