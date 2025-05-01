import ddf.minim.*;

Minim minim;
AudioPlayer player;
PImage album;

boolean isPlaying = false;  // To track play/pause state

void setup() {
  fullScreen();
  minim = new Minim(this);
  
  // Load the audio file with error handling for metadata
  try {
    player = minim.loadFile("assets/audio/USO.mp3");
  } catch (Exception e) {
    println("Error loading audio: " + e.getMessage());
  }

  album = loadImage("assets/images/ME-JU.jpg");
  album.resize(500, 300); // Album resized to a larger rectangular shape (wider than tall)

  textAlign(CENTER, CENTER);
  textFont(createFont("MV Boli", 60));  // Larger text font
  fill(0, 0, 139); // Blue ink color
}

void draw() {
  background(255);
  float centerX = width / 2;

  // Draw a background rectangle (behind the whole music player)
  noFill();
  stroke(0);  // Black border
  strokeWeight(5);
  rect(50, 50, width - 100, height - 100);  // Border around the whole music player area

  // Title Rectangle (larger size)
  fill(200);
  rect(centerX - 300, 50, 600, 100);  // Bigger title rectangle
  fill(0, 0, 139);
  text("YEET music - Merhawi Haile", centerX, 100);  // Larger text

  // Album Image (now a larger rectangle)
  image(album, centerX - 250, 180);

  // Buttons
  float btnY = 550;  // Move buttons lower for spacing
  float btnSize = 100;  // Bigger button size
  float totalButtonWidth = btnSize * 4; // Total width of all buttons

  // Calculate starting X position for the buttons to be centered
  float buttonX = centerX - totalButtonWidth / 2;

  // Fast Backward Button (Before Play/Pause)
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Fast Backward Square
  fill(0);
  // Fast backward symbol (⏪) - two triangles to the left
  triangle(buttonX + 40, btnY + 25, buttonX + 40, btnY + 75, buttonX + 10, btnY + 50);  // Left triangle
  triangle(buttonX + 60, btnY + 25, buttonX + 60, btnY + 75, buttonX + 30, btnY + 50);  // Right triangle

  // Play/Pause Button (same position)
  buttonX += btnSize;  // Move to next button position
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Play/Pause Square
  fill(0);

  if (isPlaying) {
    // Pause Button (Two rectangles)
    rect(buttonX + 25, btnY + 30, 20, 50);  // Left rectangle
    rect(buttonX + 55, btnY + 30, 20, 50);   // Right rectangle
  } else {
    // Play Button (Triangle)
    triangle(buttonX + 35, btnY + 30, buttonX + 35, btnY + 70, buttonX + 65, btnY + 50);
  }

  // Stop Button (next to Play/Pause, no space between)
  buttonX += btnSize;  // Move to next button position
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Stop Square
  fill(0);
  rect(buttonX + 25, btnY + 30, 50, 50);  // Stop symbol (a square)

  // Fast Forward Button (after Stop)
  buttonX += btnSize;  // Move to next button position
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Fast Forward Square
  fill(0);
  // Fast forward symbol (⏩) - two triangles to the right
  triangle(buttonX + 35, btnY + 25, buttonX + 35, btnY + 75, buttonX + 65, btnY + 50);  // Left triangle
  triangle(buttonX + 55, btnY + 25, buttonX + 55, btnY + 75, buttonX + 85, btnY + 50);  // Right triangle

  // Music Progress Bar (bigger)
  float barY = 700;  // Move progress bar lower
  float barWidth = 600;  // Larger progress bar
  fill(220);
  rect(centerX - 300, barY, barWidth, 30);  // Larger bar

  // Progress fill
  if (player.isPlaying()) {
    float progress = map(player.position(), 0, player.length(), 0, barWidth);
    fill(0, 0, 139);
    rect(centerX - 300, barY, progress, 30);
  }

  // Time Text - dynamic (larger text)
  int currentMillis = player.position();
  int totalMillis = player.length();

  String currentTime = nf(currentMillis / 60000, 2) + ":" + nf((currentMillis / 1000) % 60, 2);
  String totalTime = nf(totalMillis / 60000, 2) + ":" + nf((totalMillis / 1000) % 60, 2);

  fill(0);
  textSize(24);  // Larger text size
  text(currentTime + " / " + totalTime, centerX, barY + 40);

  // Quit Button (top-right corner)
  fill(200);
  rect(width - 90, 30, 50, 50);  // Bigger quit button
  fill(255, 0, 0);
  textSize(30);
  text("X", width - 60, 55);
}

void mousePressed() {
  float centerX = width / 2;
  float btnY = 550;
  float btnSize = 100;
  float totalButtonWidth = btnSize * 4;
  float buttonX = centerX - totalButtonWidth / 2;

  // Fast Backward
  if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
    int newPos = player.position() - 5000;
    player.cue(max(newPos, 0));
  }

  // Play/Pause
  buttonX += btnSize;
  if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play();
      isPlaying = true;
    }
  }

  // Stop
  buttonX += btnSize;
  if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
    player.pause();
    player.rewind();
    isPlaying = false;
  }

  // Fast Forward
  buttonX += btnSize;
  if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
    int newPos = player.position() + 5000;
    player.cue(min(newPos, player.length()));
  }

  // Quit button (same as before)
  if (mouseX > width - 90 && mouseX < width - 40 && mouseY > 30 && mouseY < 80) {
    exit();
  }
}
