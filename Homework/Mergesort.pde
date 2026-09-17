int[] arr;

void setup() {
  intArr(16);
  printArr();
  
  mergeSort(0, arr.length - 1); 
  
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

void mergeSort(int p, int r) {
  if (p < r) {  
    int q = (p + r) / 2;   
    mergeSort(p, q);         
    mergeSort(q + 1, r);
    merge(p, q, r);        
  }
}

void merge(int p, int q, int r) {
  int[] temp = new int[r - p + 1]; 
  int i = p;      
  int j = q + 1;  
  int k = 0;       

  while (i <= q && j <= r) {
    if (arr[i] <= arr[j]) {
      temp[k++] = arr[i++];
    } else {
      temp[k++] = arr[j++];
    }
  }

  while (i <= q) {
    temp[k++] = arr[i++];
  }
  
  while (j <= r) {
    temp[k++] = arr[j++];
  }

  for (i = 0; i < temp.length; i++) {
    arr[p + i] = temp[i];
  }

void swap(int idx1, int idx2) {
  int tmp = arr[idx1];
  arr[idx1] = arr[idx2];
  arr[idx2] = tmp;
}

void draw() {
}
