int[] arr;

void setup() {
  intArr(16);
  printArr();
  
  quickSort(0, arr.length - 1); 
  
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

void quickSort(int p, int r) {
  if (p < r) {
    int q = partition(p, r);
    quickSort(p, q - 1);     
    quickSort(q + 1, r);     
  }
}

int partition(int p, int r) {
  int x = arr[r]; 
  int i = p - 1; 

  for (int j = p; j < r; j++) {
    if (arr[j] <= x) { 
      i++;             
      swap(i, j);     
    }
  }
  
  swap(i + 1, r);
  
  return i + 1;
}

void swap(int idx1, int idx2) {
  int tmp = arr[idx1];
  arr[idx1] = arr[idx2];
  arr[idx2] = tmp;
}

void draw() {
}
