void setup() {
  // Set up full-screen mode
  fullScreen();
  
  int appWidth = displayWidth;
  int appHeight = displayHeight;
  float rectWidth = appWidth * 0.40;
  float rectHeight = appHeight * 0.40;
  float rectX = appWidth * 0.30;
  float rectY = appHeight * 0.25;  // Keep the rectangle slightly higher
  float squareSize = 70;  // Square size
  float squareY = rectY + rectHeight + 20;  // Place squares below the rectangle
  float squareSpacing = 10;  // Spacing between squares
  
  rect(rectX, rectY, rectWidth, rectHeight);  // Draw the rectangle
  
  // Draw 5 small squares in the middle, below the rectangle
  for (int i = 0; i < 5; i++) {  
    float squareX = rectX + (i * (squareSize + squareSpacing)) + (rectWidth - (5 * squareSize + 4 * squareSpacing)) / 2;
    rect(squareX, squareY, squareSize, squareSize);
  }
}

void draw() {
  // No continuous drawing, so leave this empty
}

void mousePressed() {
  // Add any interactivity here if needed (e.g., for buttons)
}

void keyPressed() {
  // Add any keyboard interaction here if needed
}
void setup() {
  // Set up full-screen mode
  fullScreen();
  
  int appWidth = displayWidth;
  int appHeight = displayHeight;
  float rectWidth = appWidth * 0.40;
  float rectHeight = appHeight * 0.40;
  float rectX = appWidth * 0.30;
  float rectY = appHeight * 0.25;  // Keep the rectangle slightly higher
  float squareSize = 70;  // Square size
  float squareY = rectY + rectHeight + 20;  // Place squares below the rectangle
  float squareSpacing = 10;  // Spacing between squares
  
  rect(rectX, rectY, rectWidth, rectHeight);  // Draw the rectangle
  
  // Draw 12 small squares in the middle, below the rectangle
  for (int i = 0; i < 12; i++) {  // Loop for 12 squares
    float squareX = rectX + (i * (squareSize + squareSpacing)) + (rectWidth - (12 * squareSize + 11 * squareSpacing)) / 2;
    rect(squareX, squareY, squareSize, squareSize);
  }
}

void draw() {
  // No continuous drawing, so leave this empty
}

void mousePressed() {
  // Add any interactivity here if needed (e.g., for buttons)
}

void keyPressed() {
  // Add any keyboard interaction here if needed
}
