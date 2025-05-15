import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
PImage albumImg;
PFont mvBoliFont;

void setup() {
  // Full screen
  fullScreen();
  int appWidth = displayWidth;
  int appHeight = displayHeight;

  // Load font (ensure it's in the "data" folder and named "MV Boli.ttf")
  mvBoliFont = createFont("MV Boli.ttf", 36);

  // Load audio and image
  minim = new Minim(this);
  song = minim.loadFile("assets/audio/USO.mp3");
  albumImg = loadImage("assets/images/ME-JU.jpg");

  // Title Bar above Album
  float titleHeight = 60;
  fill(220);  // light gray
  rect(0, 0, appWidth, titleHeight);

  // Title Text
  fill(0);  // black text
  textFont(mvBoliFont);
  textAlign(CENTER, CENTER);
  text("YEET music by merhawi haile", appWidth / 2, titleHeight / 2);

  // Album Rectangle
  float albumX = appWidth * 1/4;
  float albumY = titleHeight + 20;
  float albumWidth = appWidth * 1/2;
  float albumHeight = appHeight * 1/5;

  // Album Image
  image(albumImg, albumX, albumY, albumWidth, albumHeight);

  // 12 Button Squares
  float buttonWidth = appWidth / 12;
  float buttonHeight = buttonWidth;
  float buttonY = albumY + albumHeight + 20;

  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    rect(buttonX, buttonY, buttonWidth, buttonHeight);

    float centerX = buttonX + buttonWidth / 2;
    float centerY = buttonY + buttonHeight / 2;
    float size = buttonWidth / 3;

    // Rewind ⏪
    if (i == 4) {
      float gap = 5;
      triangle(centerX + size + gap, centerY - size / 2, centerX + size + gap, centerY + size / 2, centerX + gap, centerY);
      triangle(centerX, centerY - size / 2, centerX, centerY + size / 2, centerX - size, centerY);
    }

    // Play ▶️
    if (i == 5) {
      triangle(centerX - size / 2, centerY - size / 2, centerX - size / 2, centerY + size / 2, centerX + size / 2, centerY);
    }

    // Stop ■
    if (i == 6) {
      rect(centerX - size / 2, centerY - size / 2, size, size);
    }

    // Fast Forward ⏩
    if (i == 7) {
      float gap = 5;
      triangle(centerX - size - gap, centerY - size / 2, centerX - size - gap, centerY + size / 2, centerX - gap, centerY);
      triangle(centerX, centerY - size / 2, centerX, centerY + size / 2, centerX + size, centerY);
    }
  }

  // Bar Below Buttons
  float barY = buttonY + buttonHeight + 20;
  float barHeight = 40;
  rect(0, barY, appWidth, barHeight);

  // Two small rectangles to the right
  float smallW = appWidth * 0.1;
  float smallH = 20;
  float smallY = barY + barHeight + 10;
  rect(appWidth - smallW - 10, smallY, smallW, smallH);
  rect(appWidth - smallW * 2 - 20, smallY, smallW, smallH);

  // Quit button (top right)
  float quitSize = 40;
  rect(appWidth - quitSize - 10, 10, quitSize, quitSize);
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
