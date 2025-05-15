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

boolean isPlaying = false;

void setup() {
  fullScreen();
  mvBoliFont = loadFont("MVBoli-48.vlw");
  minim = new Minim(this);
  song = minim.loadFile("assets/audio/USO.mp3");
  albumImg = loadImage("assets/images/ME-JU.jpg");
}

void draw() {
  background(255);
  int appWidth = displayWidth;
  int appHeight = displayHeight;

  float titleHeight = 60;
  float topMargin = 20;
  float albumX = appWidth * 1/4;
  float albumWidth = appWidth * 1/2;
  float albumY = topMargin + titleHeight + 20;
  float albumHeight = appHeight * 1/3;

  // Title Bar
  fill(220);
  stroke(0);
  strokeWeight(2);
  rect(albumX, topMargin, albumWidth, titleHeight);
  fill(0);
  textFont(mvBoliFont);
  textAlign(CENTER, CENTER);
  text("YEET music by Merhawi Haile", appWidth / 2, topMargin + titleHeight / 2);

  // Album Image
  image(albumImg, albumX, albumY, albumWidth, albumHeight);

  // Buttons
  float buttonWidth = appWidth / 12;
  float buttonHeight = buttonWidth;
  float buttonY = albumY + albumHeight + 20;

  fill(180);
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
  }

  // Button Icons
  fill(0);
  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    float centerX = buttonX + buttonWidth / 2;
    float centerY = buttonY + buttonHeight / 2;
    float size = buttonWidth / 3;

    if (i == 4) {
      float gap = 5;
      triangle(centerX + size + gap, centerY - size / 2, centerX + size + gap, centerY + size / 2, centerX + gap, centerY);
      triangle(centerX, centerY - size / 2, centerX, centerY + size / 2, centerX - size, centerY);
    }

    if (i == 5) {
      if (isPlaying) {
        float barWidth = size / 4;
        rect(centerX - barWidth - 2, centerY - size / 2, barWidth, size);
        rect(centerX + 2, centerY - size / 2, barWidth, size);
      } else {
        triangle(centerX - size / 2, centerY - size / 2, centerX - size / 2, centerY + size / 2, centerX + size / 2, centerY);
      }
    }

    if (i == 6) {
      rect(centerX - size / 2, centerY - size / 2, size, size);
    }

    if (i == 7) {
      float gap = 5;
      triangle(centerX - size - gap, centerY - size / 2, centerX - size - gap, centerY + size / 2, centerX - gap, centerY);
      triangle(centerX, centerY - size / 2, centerX, centerY + size / 2, centerX + size, centerY);
    }
  }

  // Progress Bar
  float barY = buttonY + buttonHeight + 20;
  float barHeight = 40;

  // Border for progress bar
  stroke(0);
  strokeWeight(2);
  fill(155);
  rect(0, barY, appWidth, barHeight);

  // Fill progress
  if (song.length() > 0) {
    float progress = map(song.position(), 0, song.length(), 0, appWidth);
    fill(0);
    noStroke();
    rect(0, barY, progress, barHeight);
  }

  // Small rectangles with timeline
  float smallW = appWidth * 0.1;
  float smallH = 20;
  float smallY = barY + barHeight + 10;
  float rightX = appWidth - smallW - 10;
  float leftX = rightX - smallW; // No gap between
  fill(200);
  stroke(0);
  rect(leftX, smallY, smallW, smallH);
  rect(rightX, smallY, smallW, smallH);

  // Draw bigger timeline text (current time and total duration)
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(24);

  // Format current time
  int currentMillis = song.position();
  int currentSeconds = currentMillis / 1000;
  int currentMinutes = currentSeconds / 60;
  currentSeconds = currentSeconds % 60;

  // Format total time
  int totalMillis = song.length();
  int totalSeconds = totalMillis / 1000;
  int totalMinutes = totalSeconds / 60;
  totalSeconds = totalSeconds % 60;

  String currentTime = nf(currentMinutes, 1) + ":" + nf(currentSeconds, 2);
  String totalTime = nf(totalMinutes, 1) + ":" + nf(totalSeconds, 2);

  text(currentTime, leftX + smallW / 2, smallY + smallH / 2);
  text(totalTime, rightX + smallW / 2, smallY + smallH / 2);

  // Quit button
  float quitSize = 40;
  float quitX = appWidth - quitSize - 10;
  float quitY = 10;
  stroke(0);
  strokeWeight(2);
  noFill();
  rect(quitX, quitY, quitSize, quitSize, 5);

  pushMatrix();
  translate(quitX + quitSize / 2, quitY + quitSize / 2);
  rotate(radians(45));
  strokeWeight(3);
  line(-10, 0, 10, 0);
  line(0, -10, 0, 10);
  popMatrix();
}

void mousePressed() {
  int appWidth = displayWidth;
  int appHeight = displayHeight;
  float buttonWidth = appWidth / 12;
  float buttonHeight = buttonWidth;
  float titleHeight = 60;
  float topMargin = 20;
  float albumY = topMargin + titleHeight + 20;
  float albumHeight = appHeight * 1/3;
  float buttonY = albumY + albumHeight + 20;

  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      if (i == 4) {
        song.cue(max(0, song.position() - 5000));
      }
      if (i == 5) {
        if (!isPlaying) {
          song.play();
          isPlaying = true;
        } else {
          song.pause();
          isPlaying = false;
        }
      }
      if (i == 6) {
        song.pause();
        song.rewind();
        isPlaying = false;
      }
      if (i == 7) {
        song.cue(min(song.length(), song.position() + 5000));
      }
    }
  }

  float quitSize = 40;
  float quitX = appWidth - quitSize - 10;
  float quitY = 10;
  if (mouseX > quitX && mouseX < quitX + quitSize && mouseY > quitY && mouseY < quitY + quitSize) {
    exit();
  }
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
