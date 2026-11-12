import java.util.*;

// --- 전역 변수 설정 ---
String[] sampleExpressions = {
  "3 + 4 * 2 / ( 1 - 5 ) ^ 2",
  "( 10 + 5 ) * 2 - 8 / 4",
  "5 + 3 * ( 8 - 2 ) / 3",
  "2 ^ 3 ^ 2",
  "( 4 + 5 ) * ( 6 - 2 ) / 3 + 1"
};
int currentExprIndex = 0;

String inputExpr = "";
ArrayList<String> tokens;
ArrayList<String> postfixTokens;
String postfixStr = "";
float finalResult = 0;
String errorMessage = "";

void setup() {
  size(800, 520);
  textSize(16);
  
  // 첫 번째 수식 로드
  loadExpression(currentExprIndex);
}

void draw() {
  background(30);
  
  // 타이틀
  fill(255, 204, 0);
  textSize(22);
  text("Stack-Based Infix to Postfix Calculator", 40, 45);
  
  textSize(14);
  fill(180);
  text("Click anywhere on the screen to switch to a new expression!", 40, 75);
  
  // 영역별 박스 및 텍스트 출력
  drawBox(40, 110, 720, 75, color(45, 45, 55), "1. Current Infix Expression:", inputExpr, color(255));
  drawBox(40, 205, 720, 75, color(45, 45, 55), "2. Converted Postfix Expression:", postfixStr, color(100, 255, 150));
  
  if (errorMessage.equals("")) {
    drawBox(40, 300, 720, 75, color(45, 45, 55), "3. Evaluation Result:", nf(finalResult, 0, 4), color(255, 150, 100));
  } else {
    drawBox(40, 300, 720, 75, color(80, 30, 30), "Error Occurred:", errorMessage, color(255, 100, 100));
  }
  
  // 하단 안내
  fill(130);
  textSize(13);
  text("[Mouse Click] Next Expression   |   [Keyboard] Type & Press [Enter] to calculate", 40, 425);
  
  // 직접 입력 모드 텍스트 표시
  fill(200, 220, 255);
  textSize(14);
  text("Live Input Buffer: " + inputExpr, 40, 475);
}

// 수식 인덱스를 받아 로드 및 처리
void loadExpression(int index) {
  inputExpr = sampleExpressions[index];
  processExpression(inputExpr);
}

// 마우스 클릭 시 새로운 수식으로 변경
void mousePressed() {
  currentExprIndex = (currentExprIndex + 1) % sampleExpressions.length;
  loadExpression(currentExprIndex);
}

// 키보드 입력 처리 (직접 수식을 타이핑하고 싶을 때)
void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (inputExpr.length() > 0) {
      inputExpr = inputExpr.substring(0, inputExpr.length() - 1);
    }
  } else if (keyCode == ENTER || keyCode == RETURN) {
    processExpression(inputExpr);
  } else if (key >= 32 && key <= 126) {
    inputExpr += key;
  }
}

// 수식 처리 메인 함수
void processExpression(String expr) {
  errorMessage = "";
  try {
    tokens = tokenize(expr);
    postfixTokens = infixToPostfix(tokens);
    postfixStr = String.join(" ", postfixTokens);
    finalResult = evaluatePostfix(postfixTokens);
  } catch (Exception e) {
    errorMessage = e.getMessage();
    postfixStr = "-";
    finalResult = 0;
  }
}

// --- UI 박스 렌더링 헬퍼 함수 ---
void drawBox(float x, float y, float w, float h, color bgCol, String label, String val, color txtCol) {
  fill(bgCol);
  noStroke();
  rect(x, y, w, h, 10);
  
  fill(180);
  textSize(13);
  text(label, x + 20, y + 25);
  
  fill(txtCol);
  textSize(18);
  text(val, x + 20, y + 53);
}

// --- 연산자 우선순위 반환 ---
int getPrecedence(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  if (op.equals("^")) return 3;
  return 0;
}

// --- 1. 토큰화 (Tokenization) ---
ArrayList<String> tokenize(String expr) {
  ArrayList<String> list = new ArrayList<String>();
  int i = 0;
  int n = expr.length();
  
  while (i < n) {
    char c = expr.charAt(i);
    if (Character.isWhitespace(c)) {
      i++;
      continue;
    }
    
    // 숫자(정수 및 실수) 파싱
    if (Character.isDigit(c) || c == '.') {
      String numStr = "";
      while (i < n && (Character.isDigit(expr.charAt(i)) || expr.charAt(i) == '.')) {
        numStr += expr.charAt(i);
        i++;
      }
      list.add(numStr);
      continue;
    }
    
    // 연산자 및 괄호 파싱
    if ("+-*/^()".indexOf(c) != -1) {
      list.add(String.valueOf(c));
      i++;
      continue;
    }
    
    throw new IllegalArgumentException("Unsupported character: '" + c + "'");
  }
  return list;
}

// --- 2. 중위 표기식 -> 후위 표기식 변환 (Shunting-yard 알고리즘) ---
ArrayList<String> infixToPostfix(ArrayList<String> infixTokens) {
  ArrayList<String> output = new ArrayList<String>();
  Stack<String> stack = new Stack<String>();
  
  for (String token : infixTokens) {
    char c = token.charAt(0);
    
    if (Character.isDigit(c)) {
      output.add(token);
    } 
    else if (token.equals("(")) {
      stack.push(token);
    } 
    else if (token.equals(")")) {
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        output.add(stack.pop());
      }
      if (stack.isEmpty()) {
        throw new IllegalArgumentException("Mismatched parentheses.");
      }
      stack.pop(); 
    } 
    else {
      while (!stack.isEmpty() && !stack.peek().equals("(") &&
             (getPrecedence(stack.peek()) > getPrecedence(token) ||
              (getPrecedence(stack.peek()) == getPrecedence(token) && !token.equals("^")))) {
        output.add(stack.pop());
      }
      stack.push(token);
    }
  }
  
  while (!stack.isEmpty()) {
    String top = stack.pop();
    if (top.equals("(")) {
      throw new IllegalArgumentException("Mismatched parentheses.");
    }
    output.add(top);
  }
  
  return output;
}

// --- 3. 후위 표기식 계산 (Stack 기반 연산) ---
float evaluatePostfix(ArrayList<String> postTokens) {
  Stack<Float> stack = new Stack<Float>();
  
  for (String token : postTokens) {
    char c = token.charAt(0);
    
    if (Character.isDigit(c)) {
      stack.push(Float.parseFloat(token));
    } else {
      if (stack.size() < 2) {
        throw new IllegalArgumentException("Invalid expression format.");
      }
      float b = stack.pop(); 
      float a = stack.pop(); 
      float res = 0;
      
      if (token.equals("+")) res = a + b;
      else if (token.equals("-")) res = a - b;
      else if (token.equals("*")) res = a * b;
      else if (token.equals("/")) {
        if (b == 0) throw new ArithmeticException("Division by zero.");
        res = a / b;
      }
      else if (token.equals("^")) res = pow(a, b);
      
      stack.push(res);
    }
  }
  
  if (stack.size() != 1) {
    throw new IllegalArgumentException("Invalid expression format.");
  }
  
  return stack.pop();
}
