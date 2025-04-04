void setup() {
  // Full screen setup
  fullScreen();
  int appWidth = displayWidth;
  int appHeight = displayHeight;

  // Center Rectangle for Album
  float albumX = appWidth * 1/4;
  float albumY = appHeight * 1/10;
  float albumWidth = appWidth * 1/2;
  float albumHeight = appHeight * 1/5;

  // Draw Album Rectangle
  rect(albumX, albumY, albumWidth, albumHeight);

  // 12 Button Squares below Album
  float buttonWidth = appWidth / 12;
  float buttonHeight = buttonWidth;
  float buttonY = albumY + albumHeight + 20;  // Positioned below album

  // Button positions
  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
  }

  // Thinner Rectangle below the 12 buttons (Bar)
  float barY = buttonY + buttonHeight + 20;  // Positioned below buttons
  float barWidth = appWidth;
  float barHeight = 40;  // Thinner bar

  rect(0, barY, barWidth, barHeight);

  // Two small Rectangles below the thinner rectangle, positioned to the right
  float smallRectWidth = barWidth * 0.1;  // Small width for the rectangles
  float smallRectHeight = 20;  // Height for the small rectangles
  float smallRectY = barY + barHeight + 10;  // Positioned below the bar

  // Position the small rectangles to the right
  rect(barWidth - smallRectWidth - 10, smallRectY, smallRectWidth, smallRectHeight);  // First small rectangle
  rect(barWidth - smallRectWidth * 2 - 20, smallRectY, smallRectWidth, smallRectHeight);  // Second small rectangle
  
  // Quit Small Square in the Corner
  float quitSize = 40;
  rect(appWidth - quitSize - 10, 10, quitSize, quitSize);
}
