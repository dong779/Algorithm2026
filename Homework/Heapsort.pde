int[] arr;

void setup() {
  intArr(16);
  printArr();
  
  heapSort(); 
  
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void heapSort() {
  int n = arr.length;

  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(n, i);
  }

  for (int i = n - 1; i > 0; i--) {
    swap(0, i);
    
    heapify(i, 0);
  }
}

void heapify(int n, int i) {
  int largest = i;       
  int left = 2 * i + 1; 
  int right = 2 * i + 2;

  if (left < n && arr[left] > arr[largest]) {
    largest = left;
  }

  // 오른쪽 자식이 현재 가장 큰 값보다 크다면
  if (right < n && arr[right] > arr[largest]) {
    largest = right;
  }

  if (largest != i) {
    swap(i, largest);
    heapify(n, largest);
  }
}

void swap(int idx1, int idx2) {
  int tmp = arr[idx1];
  arr[idx1] = arr[idx2];
  arr[idx2] = tmp;
}

void draw() {
}
