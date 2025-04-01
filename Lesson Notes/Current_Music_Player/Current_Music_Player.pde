void setup() {
  // Initialize the program in fullscreen mode
  fullScreen();
  
  // Get the width and height of the screen
  int appWidth = displayWidth;
  int appHeight = displayHeight;
  
  // Set the size and position of the large rectangle
  float rectWidth = appWidth * 0.40;  // 40% of the screen width
  float rectHeight = appHeight * 0.40;  // 40% of the screen height
  float rectX = appWidth * 0.30;  // Position the rectangle 30% from the left
  float rectY = appHeight * 0.25;  // Position the rectangle 25% from the top
  
  // Set the size of each square and the number of squares
  float squareSize = 100;  // Each square will be 100px by 100px
  int numSquares = 12;  // Total of 12 squares
  float totalSquaresWidth = numSquares * squareSize;  // Total width of all squares together
  float squareY = rectY + rectHeight + 20;  // Y position for the squares (just below the large rectangle)
  
  // Draw the large rectangle at the specified position
  rect(rectX, rectY, rectWidth, rectHeight); 
  
  // Calculate the starting X position for the first square, so that all squares are centered horizontally
  float startX = rectX + (rectWidth - totalSquaresWidth) / 2;
  
  // Loop to draw the squares
  for (int i = 0; i < numSquares; i++) {
    // Calculate the X position of each square based on its index
    float squareX = startX + (i * squareSize);
    
    // Draw the square at the calculated position
    rect(squareX, squareY, squareSize, squareSize);
  }
  
  // Set the size of the button to be drawn in the top-right corner
  float buttonSize = 50;

  // Calculate the X and Y position for the button (top-right corner of the screen)
  float buttonX = appWidth - buttonSize;  // X position is the screen width minus the button width
  float buttonY = 0;  // Y position is at the very top (0 pixels from the top)

  // Draw the button at the calculated position in the top-right corner
  rect(buttonX, buttonY, buttonSize, buttonSize);
}

void draw() {
  // The draw function is empty because we don't need continuous updates right now
  // Typically used for animations or dynamic content, but it's not needed here
}

void mousePressed() {
  // The mousePressed function is empty for now
  // If you wanted to add interactivity (e.g., clicking the button), you would write code here
}

void keyPressed() {
  // The keyPressed function is empty for now
  // If you wanted to add interactivity with the keyboard, you would write code here
}
