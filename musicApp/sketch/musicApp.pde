import ddf.minim.*;

Minim minim;
AudioPlayer player;
PImage album;

boolean isPlaying = false;  // To track play/pause state

void setup() {
  fullScreen();
  minim = new Minim(this);
  player = minim.loadFile("assets/audio/USO.mp3");
  album = loadImage("assets/images/ME-JU.jpg");
  album.resize(400, 250); // Album resized to a rectangular shape (wider than tall)

  textAlign(CENTER, CENTER);
  textFont(createFont("MV Boli", 48));  // Larger text font
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
  rect(centerX - 250, 50, 500, 80);  // Bigger title rectangle
  fill(0, 0, 139);
  text("YEET music - Merhawi Haile", centerX, 90);  // Larger text

  // Album Image (now a rectangle)
  image(album, centerX - 200, 150);

  // Buttons
  float btnY = 500;  // Move buttons lower for spacing
  float btnSize = 80;  // Bigger button size
  float totalButtonWidth = btnSize * 4; // Total width of all buttons

  // Calculate starting X position for the buttons to be centered
  float buttonX = centerX - totalButtonWidth / 2;

  // Fast Backward Button (Before Play/Pause)
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Fast Backward Square
  fill(0);
  // Fast backward symbol (⏪) - two triangles to the left
  triangle(buttonX + 35, btnY + 20, buttonX + 35, btnY + 60, buttonX + 5, btnY + 40);  // Left triangle
  triangle(buttonX + 55, btnY + 20, buttonX + 55, btnY + 60, buttonX + 25, btnY + 40);  // Right triangle

  // Play/Pause Button (same position)
  buttonX += btnSize;  // Move to next button position
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Play/Pause Square
  fill(0);

  if (isPlaying) {
    // Pause Button (Two rectangles)
    rect(buttonX + 20, btnY + 20, 15, 40);  // Left rectangle
    rect(buttonX + 50, btnY + 20, 15, 40);   // Right rectangle
  } else {
    // Play Button (Triangle)
    triangle(buttonX + 25, btnY + 20, buttonX + 25, btnY + 60, buttonX + 55, btnY + 40);
  }

  // Stop Button (next to Play/Pause, no space between)
  buttonX += btnSize;  // Move to next button position
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Stop Square
  fill(0);
  rect(buttonX + 15, btnY + 20, 40, 40);  // Stop symbol (a square)

  // Fast Forward Button (after Stop)
  buttonX += btnSize;  // Move to next button position
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);  // Fast Forward Square
  fill(0);
  // Fast forward symbol (⏩) - two triangles to the right
  triangle(buttonX + 25, btnY + 20, buttonX + 25, btnY + 60, buttonX + 55, btnY + 40);  // Left triangle
  triangle(buttonX + 45, btnY + 20, buttonX + 45, btnY + 60, buttonX + 75, btnY + 40);  // Right triangle

  // Music Progress Bar (bigger)
  float barY = 620;  // Move progress bar lower
  float barWidth = 500;  // Larger progress bar
  fill(220);
  rect(centerX - 250, barY, barWidth, 25);  // Larger bar

  // Progress fill
  if (player.isPlaying()) {
    float progress = map(player.position(), 0, player.length(), 0, barWidth);
    fill(0, 0, 139);
    rect(centerX - 250, barY, progress, 25);
  }

  // Time Text - dynamic (larger text)
  int currentMillis = player.position();
  int totalMillis = player.length();

  String currentTime = nf(currentMillis / 60000, 2) + ":" + nf((currentMillis / 1000) % 60, 2);
  String totalTime = nf(totalMillis / 60000, 2) + ":" + nf((totalMillis / 1000) % 60, 2);

  fill(0);
  textSize(20);  // Larger text size
  text(currentTime + " / " + totalTime, centerX, barY + 35);

  // Quit Button (top-right corner)
  fill(200);
  rect(width - 70, 20, 40, 40);  // Bigger quit button
  fill(255, 0, 0);
  textSize(24);
  text("X", width - 50, 40);
}

void mousePressed() {
  float centerX = width / 2;
  float btnY = 500;
  float btnSize = 80;
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
  if (mouseX > width - 70 && mouseX < width - 30 && mouseY > 20 && mouseY < 60) {
    exit();
  }
}
