import ddf.minim.*;

Minim minim;
AudioPlayer player;
PImage album;

boolean isPlaying = false;
boolean isMuted = false;
float savedVolume = 1.0;

void setup() {
  fullScreen();
  minim = new Minim(this);

  try {
    player = minim.loadFile("assets/audio/USO.mp3");
  } catch (Exception e) {
    println("Error loading audio: " + e.getMessage());
  }

  album = loadImage("assets/images/ME-JU.jpg");
  album.resize(500, 300);

  textAlign(CENTER, CENTER);
  textFont(createFont("MV Boli", 60));
  fill(0, 0, 139);
}

void draw() {
  background(255);
  float centerX = width / 2;

  noFill();
  stroke(0);
  strokeWeight(5);
  rect(50, 50, width - 100, height - 100);

  fill(200);
  rect(centerX - 300, 50, 600, 100);
  fill(0, 0, 139);
  text("YEET music - Merhawi Haile", centerX, 100);

  image(album, centerX - 250, 180);

  float btnY = 550;
  float btnSize = 100;
  float totalButtonWidth = btnSize * 7; // one extra for mute
  float buttonX = centerX - totalButtonWidth / 2;

  // Fast Backward
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  triangle(buttonX + 40, btnY + 25, buttonX + 40, btnY + 75, buttonX + 10, btnY + 50);
  triangle(buttonX + 60, btnY + 25, buttonX + 60, btnY + 75, buttonX + 30, btnY + 50);

  // Play/Pause
  buttonX += btnSize;
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  if (isPlaying) {
    rect(buttonX + 25, btnY + 30, 20, 50);
    rect(buttonX + 55, btnY + 30, 20, 50);
  } else {
    triangle(buttonX + 35, btnY + 30, buttonX + 35, btnY + 70, buttonX + 65, btnY + 50);
  }

  // Stop
  buttonX += btnSize;
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  rect(buttonX + 25, btnY + 30, 50, 50);

  // Fast Forward
  buttonX += btnSize;
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  triangle(buttonX + 35, btnY + 25, buttonX + 35, btnY + 75, buttonX + 65, btnY + 50);
  triangle(buttonX + 55, btnY + 25, buttonX + 55, btnY + 75, buttonX + 85, btnY + 50);

  // Next
  buttonX += btnSize;
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  triangle(buttonX + 35, btnY + 25, buttonX + 35, btnY + 75, buttonX + 65, btnY + 50);
  rect(buttonX + 70, btnY + 25, 10, 50);

  // Previous
  buttonX += btnSize;
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  triangle(buttonX + 65, btnY + 25, buttonX + 65, btnY + 75, buttonX + 35, btnY + 50);
  rect(buttonX + 25, btnY + 25, 10, 50);

  // Mute/Unmute (toggle button)
  buttonX += btnSize;
  fill(180);
  rect(buttonX, btnY, btnSize, btnSize);
  fill(0);
  if (isMuted) {
    line(buttonX + 30, btnY + 30, buttonX + 70, btnY + 70);
    line(buttonX + 70, btnY + 30, buttonX + 30, btnY + 70);
  } else {
    triangle(buttonX + 40, btnY + 35, buttonX + 40, btnY + 65, buttonX + 60, btnY + 50);
    rect(buttonX + 60, btnY + 40, 10, 20);
  }

  // Progress Bar
  float barY = 700;
  float barWidth = 100 * 15;
  fill(220);
  rect(centerX - barWidth / 2, barY, barWidth, 30);

  if (player.isPlaying()) {
    float progress = map(player.position(), 0, player.length(), 0, barWidth);
    fill(0, 0, 139);
    rect(centerX - barWidth / 2, barY, progress, 30);
  }

  int currentMillis = player.position();
  int totalMillis = player.length();
  String currentTime = nf(currentMillis / 60000, 2) + ":" + nf((currentMillis / 1000) % 60, 2);
  String totalTime = nf(totalMillis / 60000, 2) + ":" + nf((totalMillis / 1000) % 60, 2);
  fill(0);
  textSize(24);
  text(currentTime + " / " + totalTime, centerX, barY + 40);

  // Quit Button
  fill(200);
  rect(width - 90, 30, 50, 50);
  fill(255, 0, 0);
  textSize(30);
  text("X", width - 60, 55);
}

void mousePressed() {
  float centerX = width / 2;
  float btnY = 550;
  float btnSize = 100;
  float totalButtonWidth = btnSize * 7;
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

  // Next
  buttonX += btnSize;

  // Previous
  buttonX += btnSize;

  // Mute/Unmute
  buttonX += btnSize;
  if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
    if (isMuted) {
      player.setGain(savedVolume);  // Restore original volume
      isMuted = false;
    } else {
      savedVolume = player.getGain(); // Save current volume before muting
      player.setGain(-80);  // Mute
      isMuted = true;
    }
  }

  // Quit
  if (mouseX > width - 90 && mouseX < width - 40 && mouseY > 30 && mouseY < 80) {
    exit();
  }
}
