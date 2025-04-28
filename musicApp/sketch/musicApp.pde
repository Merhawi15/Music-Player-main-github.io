import ddf.minim.*;

Minim minim;
AudioPlayer player;
PImage albumCover;
boolean isPlaying = false;

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

  // Load Album Cover Image
  albumCover = loadImage("assets/images/ME-JU.jpg");
  imageMode(CENTER);
  image(albumCover, appWidth / 2, albumY + albumHeight / 2, albumWidth * 0.8, albumHeight * 0.8);  // Image positioned inside the album rectangle

  // 12 Button Squares below Album
  float buttonWidth = appWidth / 12;
  float buttonHeight = buttonWidth;
  float buttonY = albumY + albumHeight + 20;  // Positioned below album

  // Button positions and custom button shapes
  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    rect(buttonX, buttonY, buttonWidth, buttonHeight);  // Draw the square for each button

    // Draw custom shapes inside specific squares
    if (i == 5) {
      drawPlayButton(buttonX, buttonY, buttonWidth, buttonHeight);  // Play button
    } else if (i == 6) {
      drawStopButton(buttonX, buttonY, buttonWidth, buttonHeight);  // Stop button
    }
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
  rect(barWidth - smallRectWidth - 10, smallRectY, smallRectWidth, smallRectHeight);  // First small rectangle
  rect(barWidth - smallRectWidth * 2 - 20, smallRectY, smallRectWidth, smallRectHeight);  // Second small rectangle
  
  // Quit Small Square in the Corner with X
  float quitSize = 40;
  rect(appWidth - quitSize - 10, 10, quitSize, quitSize);  // Draw the quit square
  drawQuitX(appWidth - quitSize - 10, 10, quitSize);  // Draw the X inside the quit button

  // Load the music file
  minim = new Minim(this);
  player = minim.loadFile("assets/audio/USO.mp3");  // Load the music file from the 'assets/audio' folder
}

void draw() {
  // Add any dynamic UI or interactivity here
}

void mousePressed() {
  int appWidth = displayWidth;
  int appHeight = displayHeight;

  // Button positions (based on 12 button squares)
  float buttonWidth = appWidth / 12;
  float buttonHeight = buttonWidth;
  float buttonY = appHeight * 1/10 + appHeight * 1/5 + 20;  // Positioned below album
  
  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      // Handle button functionality
      if (i == 5) {
        // Play Button (Rotated Triangle)
        if (!isPlaying) {
          player.play();  // Play the music
          isPlaying = true;  // Update the state to playing
        }
      } else if (i == 6) {
        // Stop Button (Square)
        player.close();  // Stop the music
        isPlaying = false;
      }
    }
  }

  // Quit Button in the top-right corner
  float quitSize = 40;
  if (mouseX > appWidth - quitSize - 10 && mouseX < appWidth - 10 && mouseY > 10 && mouseY < quitSize + 10) {
    exit();  // Close the app
  }
}

// Draw play button with a traditional triangle (▶️) inside the square
void drawPlayButton(float x, float y, float w, float h) {
  float triangleSize = w * 0.6;  // Size of the play button
  float x1 = x + w / 2 - triangleSize / 2;
  float x2 = x + w / 2 + triangleSize / 2;
  float y1 = y + h / 2 - triangleSize / 2;
  float y2 = y + h / 2 + triangleSize / 2;

  // Draw the play button (▶️)
  triangle(x + w / 2 - triangleSize / 2, y + h / 2 - triangleSize / 2,  // Top-left corner
           x + w / 2 + triangleSize / 2, y + h / 2,  // Right corner
           x + w / 2 - triangleSize / 2, y + h / 2 + triangleSize / 2);  // Bottom-left corner
}

// Draw stop button with a square inside the square
void drawStopButton(float x, float y, float w, float h) {
  rect(x + w / 4, y + h / 4, w / 2, h / 2);  // Draw the stop square
}

// Draw X inside the quit button square
void drawQuitX(float x, float y, float size) {
  float margin = 10;
  float lineWidth = 5;
  // Draw X by drawing two diagonal lines
  line(x + margin, y + margin, x + size - margin, y + size - margin);  // First line
  line(x + size - margin, y + margin, x + margin, y + size - margin);  // Second line
}
