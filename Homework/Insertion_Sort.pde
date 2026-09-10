int[] arr;

void setup() {
  intArr(16);
  printArr();
  insertionSorting();
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

void insertionSorting() {
  int i, j, tmp;
  for(i = 1; i < arr.length; i++) {
    tmp = arr[i];
    j = i - 1;
    while(j >= 0 && arr[j] > tmp) {
      arr[j + 1] = arr[j];
      j--;
    }
    arr[j + 1] = tmp;
  } 
}

void draw() {
}
