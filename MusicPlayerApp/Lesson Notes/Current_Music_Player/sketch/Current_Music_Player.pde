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
boolean isShuffle = false;
boolean isRepeat = false;
boolean isMuted = false;

String[] titles = {
  "Main Event Jey Uso - ISH",
  "Roman Reigns - I Am Greatness",
  "John Cena - The Time Is Now"
};

String[] audioPaths = {
  "assets/audio/USO.mp3",
  "assets/audio/OTC.mp3",
  "assets/audio/U-CAN'T-SEE-ME.mp3"
};

String[] imagePaths = {
  "assets/images/ME-JU.jpg",
  "assets/images/1316.jpg",
  "assets/images/JC.jpg"
};

color[] titleColors = {
  color(0, 0, 255),
  color(255, 165, 0),
  color(0, 200, 0)
};

int currentSongIndex = 0;

// Dimensions as floats for smooth positioning
float appWidth, appHeight;
float titleHeight = 60.0;
float topMargin = 20.0;
float albumX, albumWidth, albumY, albumHeight;
float buttonWidth, buttonHeight, buttonY;
float barY, barHeight;
float quitSize, quitX, quitY;

// Volume
float volume = 0.7;  // between 0 and 1

// Button indices
final int BTN_VOL_DOWN = 1;
final int BTN_VOL_UP   = 3;
final int BTN_PREV    = 2;
final int BTN_REWIND  = 4;
final int BTN_PLAY    = 5;
final int BTN_STOP    = 6;
final int BTN_FFWD    = 7;
final int BTN_NEXT    = 9;
final int BTN_PLAYLIST = 8;
final int BTN_SHUFFLE = 10;
final int BTN_REPEAT  = 11;

// For progress bar click
boolean isSeeking = false;

void setup() {
  fullScreen();
  appWidth = (float) displayWidth;
  appHeight = (float) displayHeight;

  mvBoliFont = loadFont("MVBoli-48.vlw");
  minim = new Minim(this);

  albumX = appWidth * 0.25f;
  albumWidth = appWidth * 0.5f;
  albumY = topMargin + titleHeight + 20.0f;
  albumHeight = appHeight / 3.0f;

  buttonWidth = appWidth / 12.0f;
  buttonHeight = buttonWidth;
  buttonY = albumY + albumHeight + 20.0f;

  barY = buttonY + buttonHeight + 20.0f;
  barHeight = 40.0f;

  quitSize = 40.0f;
  quitX = appWidth - quitSize - 10.0f;
  quitY = 10.0f;

  loadCurrentSong();
}

void draw() {
  background(255);
  drawTitleBar();
  drawAlbumImage();
  drawButtons();
  drawProgressBar();
  drawTimeLabels();
  drawVolumeLabel();
  drawQuitButton();

  // Auto-next and repeat logic
  if (song != null && !song.isPlaying() && isPlaying) {
    if (isRepeat) {
      song.rewind();
      song.play();
    } else {
      autoNextSong();
    }
  }
}

void drawTitleBar() {
  fill(220);
  stroke(0);
  strokeWeight(2);
  rect(albumX, topMargin, albumWidth, titleHeight);

  fill(titleColors[currentSongIndex]);
  textFont(mvBoliFont);
  textAlign(CENTER, CENTER);
  text(titles[currentSongIndex], appWidth / 2.0f, topMargin + titleHeight / 2.0f);
}

void drawAlbumImage() {
  if (albumImg != null) {
    image(albumImg, albumX, albumY, albumWidth, albumHeight);
  } else {
    fill(200);
    rect(albumX, albumY, albumWidth, albumHeight);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Image not found", albumX + albumWidth / 2.0f, albumY + albumHeight / 2.0f);
  }
}

void drawButtons() {
  stroke(0);
  strokeWeight(1);

  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
        mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      fill(150);
    } else {
      fill(180);
    }
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 8);
  }

  fill(0);
  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    float centerX = buttonX + buttonWidth / 2.0f;
    float centerY = buttonY + buttonHeight / 2.0f;
    float size = buttonWidth / 3.0f;
    float gap = 5.0f;

    if (i == 0) {
      // Mute/unmute icon
      stroke(0);
      strokeWeight(3);
      noFill();
      float spkW = size * 0.5f;
      float spkH = size * 0.7f;
      beginShape();
      vertex(centerX - spkW * 0.5, centerY - spkH * 0.5);
      vertex(centerX - spkW * 0.5, centerY + spkH * 0.5);
      vertex(centerX + spkW * 0.3, centerY + spkH * 0.5);
      vertex(centerX + spkW * 0.3, centerY - spkH * 0.5);
      endShape(CLOSE);

      if (isMuted) {
        stroke(255, 0, 0);
        strokeWeight(4);
        line(centerX + spkW * 0.4, centerY - spkH * 0.5, centerX + spkW * 0.9, centerY + spkH * 0.5);
        line(centerX + spkW * 0.9, centerY - spkH * 0.5, centerX + spkW * 0.4, centerY + spkH * 0.5);
        stroke(0);
      } else {
        noFill();
        strokeWeight(3);
        arc(centerX + spkW * 0.7, centerY, size * 0.4f, size * 0.4f, -PI/4, PI/4);
        arc(centerX + spkW * 1.0, centerY, size * 0.7f, size * 0.7f, -PI/4, PI/4);
      }
      strokeWeight(1);
      fill(0);
    }

    if (i == BTN_VOL_DOWN) {
      // Volume Down: minus sign
      float lineW = size * 0.8f;
      float lineH = size * 0.15f;
      rect(centerX - lineW/2, centerY - lineH/2, lineW, lineH, 3);
    }
    if (i == BTN_VOL_UP) {
      // Volume Up: plus sign
      float lineW = size * 0.8f;
      float lineH = size * 0.15f;
      rect(centerX - lineW/2, centerY - lineH/2, lineW, lineH, 3);
      rect(centerX - lineH/2, centerY - lineW/2, lineH, lineW, 3);
    }
    if (i == BTN_PREV) {
      rect(centerX - size / 2.0f, centerY - size / 2.0f, size / 5.0f, size);
      triangle(centerX - size / 2.0f + size / 5.0f, centerY,
               centerX + size / 2.0f, centerY - size / 2.0f,
               centerX + size / 2.0f, centerY + size / 2.0f);
    }
    if (i == BTN_REWIND) {
      triangle(centerX + size + gap, centerY - size / 2.0f, centerX + size + gap, centerY + size / 2.0f, centerX + gap, centerY);
      triangle(centerX, centerY - size / 2.0f, centerX, centerY + size / 2.0f, centerX - size, centerY);
    }
    if (i == BTN_PLAY) {
      if (isPlaying) {
        float barWidth = size / 4.0f;
        rect(centerX - barWidth - 2.0f, centerY - size / 2.0f, barWidth, size);
        rect(centerX + 2.0f, centerY - size / 2.0f, barWidth, size);
      } else {
        triangle(centerX - size / 2.0f, centerY - size / 2.0f, centerX - size / 2.0f, centerY + size / 2.0f, centerX + size / 2.0f, centerY);
      }
    }
    if (i == BTN_STOP) {
      rect(centerX - size / 2.0f, centerY - size / 2.0f, size, size);
    }
    if (i == BTN_FFWD) {
      triangle(centerX - size - gap, centerY - size / 2.0f, centerX - size - gap, centerY + size / 2.0f, centerX - gap, centerY);
      triangle(centerX, centerY - size / 2.0f, centerX, centerY + size / 2.0f, centerX + size, centerY);
    }
    if (i == BTN_NEXT) {
      triangle(centerX - size, centerY - size / 2.0f, centerX - size, centerY + size / 2.0f, centerX, centerY);
      rect(centerX, centerY - size / 2.0f, size / 3.0f, size);
    }
    if (i == BTN_PLAYLIST) {
      // Playlist: three horizontal lines
      float lineHeight = size / 5.0f;
      for (int l = -1; l <= 1; l++) {
        rect(centerX - size/2, centerY + l*lineHeight, size, lineHeight/2, 2);
      }
    }
    if (i == BTN_SHUFFLE) {
      stroke(0, isShuffle ? 180 : 80, 0);
      strokeWeight(3);
      noFill();
      beginShape();
      vertex(centerX - size/2, centerY + size/2);
      vertex(centerX + size/2, centerY - size/2);
      endShape();
      beginShape();
      vertex(centerX - size/2, centerY - size/2);
      vertex(centerX + size/2, centerY + size/2);
      endShape();
      triangle(centerX + size/2-5, centerY - size/2-3, centerX + size/2+5, centerY - size/2, centerX + size/2-5, centerY - size/2+3);
      triangle(centerX + size/2-5, centerY + size/2-3, centerX + size/2+5, centerY + size/2, centerX + size/2-5, centerY + size/2+3);
      stroke(0);
      fill(0);
    }
    if (i == BTN_REPEAT) {
      stroke(0, 0, isRepeat ? 180 : 80);
      strokeWeight(3);
      noFill();
      arc(centerX, centerY, size, size, PI/3, TWO_PI-PI/3);
      float a = PI/3;
      float r = size/2;
      float ax = centerX + cos(a)*r;
      float ay = centerY + sin(a)*r;
      triangle(ax, ay, ax-8, ay-5, ax-8, ay+5);
      stroke(0);
      fill(0);
    }
  }
}

void drawProgressBar() {
  stroke(0);
  strokeWeight(2);
  fill(155);
  rect(0, barY, appWidth, barHeight);

  if (song != null && song.length() > 0) {
    float progress = map(song.position(), 0, song.length(), 0, appWidth);
    fill(0);
    noStroke();
    rect(0, barY, progress, barHeight);
  }
}

void drawTimeLabels() {
  float smallW = appWidth * 0.1f;
  float smallH = 20.0f;
  float smallY = barY + barHeight + 10.0f;
  float rightX = appWidth - smallW - 10.0f;
  float leftX = rightX - smallW;

  fill(200);
  stroke(0);
  rect(leftX, smallY, smallW, smallH);
  rect(rightX, smallY, smallW, smallH);

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(24);

  int currentMillis = song != null ? song.position() : 0;
  int currentSeconds = currentMillis / 1000;
  int currentMinutes = currentSeconds / 60;
  currentSeconds %= 60;

  int totalMillis = song != null ? song.length() : 0;
  int totalSeconds = totalMillis / 1000;
  int totalMinutes = totalSeconds / 60;
  totalSeconds %= 60;

  String currentTime = nf(currentMinutes, 1) + ":" + nf(currentSeconds, 2);
  String totalTime = nf(totalMinutes, 1) + ":" + nf(totalSeconds, 2);

  text(currentTime, leftX + smallW / 2.0f, smallY + smallH / 2.0f);
  text(totalTime, rightX + smallW / 2.0f, smallY + smallH / 2.0f);
}

void drawVolumeLabel() {
  String volText = "Volume: " + int(volume * 100) + "%";
  fill(50);
  textSize(24);
  textAlign(RIGHT, TOP);
  text(volText, appWidth - 20, buttonY - 30);
}

void drawQuitButton() {
  boolean hover = (mouseX > quitX && mouseX < quitX + quitSize && mouseY > quitY && mouseY < quitY + quitSize);
  stroke(0);
  strokeWeight(2);
  if (hover) fill(255, 220, 220);
  else noFill();
  rect(quitX, quitY, quitSize, quitSize, 5);

  pushMatrix();
  translate(quitX + quitSize / 2.0f, quitY + quitSize / 2.0f);
  rotate(radians(45));
  stroke(255, 0, 0);
  strokeWeight(3);
  line(-10, 0, 10, 0);
  line(0, -10, 0, 10);
  popMatrix();
}

void mousePressed() {
  if (mouseY > barY && mouseY < barY + barHeight) {
    float clickRatio = constrain(mouseX / appWidth, 0, 1);
    if (song != null) {
      int newPos = int(song.length() * clickRatio);
      song.cue(newPos);
    }
    return;
  }

  for (int i = 0; i < 12; i++) {
    float buttonX = buttonWidth * i;
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
        mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      switch(i) {
        case 0:
          isMuted = !isMuted;
          if (song != null) song.setGain(isMuted ? -80 : map(volume, 0, 1, -80, 0));
          break;
        case BTN_VOL_DOWN:
          setVolume(volume - 0.05f);
          break;
        case BTN_VOL_UP:
          setVolume(volume + 0.05f);
          break;
        case BTN_PREV:
          prevSong();
          break;
        case BTN_REWIND:
          rewindFive();
          break;
        case BTN_PLAY:
          togglePlayPause();
          break;
        case BTN_STOP:
          stopSong();
          break;
        case BTN_FFWD:
          forwardFive();
          break;
        case BTN_NEXT:
          nextSong();
          break;
        case BTN_PLAYLIST:
          // Placeholder: Add your playlist UI logic here
          break;
        case BTN_SHUFFLE:
          isShuffle = !isShuffle;
          break;
        case BTN_REPEAT:
          isRepeat = !isRepeat;
          break;
      }
    }
  }

  if (mouseX > quitX && mouseX < quitX + quitSize &&
      mouseY > quitY && mouseY < quitY + quitSize) {
    exit();
  }
}

void keyPressed() {
  if (key == ' ' || key == 'k') togglePlayPause();
  else if (keyCode == RIGHT) nextSong();
  else if (keyCode == LEFT) prevSong();
  else if (keyCode == UP) setVolume(volume + 0.05f);
  else if (keyCode == DOWN) setVolume(volume - 0.05f);
}

void setVolume(float v) {
  volume = constrain(v, 0, 1);
  if (song != null && !isMuted) song.setGain(map(volume, 0, 1, -80, 0));
}

void loadCurrentSong() {
  if (song != null) {
    song.close();
  }
  song = minim.loadFile(audioPaths[currentSongIndex]);
  albumImg = loadImage(imagePaths[currentSongIndex]);
  isPlaying = false;
  setVolume(volume);
  if (song != null) song.setGain(isMuted ? -80 : map(volume, 0, 1, -80, 0));
}

void togglePlayPause() {
  if (song == null) return;
  if (isPlaying) {
    song.pause();
    isPlaying = false;
  } else {
    song.play();
    isPlaying = true;
  }
}

void stopSong() {
  if (song == null) return;
  song.pause();
  song.rewind();
  isPlaying = false;
}

void nextSong() {
  if (isShuffle) {
    int prevIdx = currentSongIndex;
    while (titles.length > 1) {
      currentSongIndex = int(random(titles.length));
      if (currentSongIndex != prevIdx) break;
    }
  } else {
    currentSongIndex++;
    if (currentSongIndex >= titles.length) currentSongIndex = 0;
  }
  loadCurrentSong();
}

void prevSong() {
  if (isShuffle) {
    int prevIdx = currentSongIndex;
    while (titles.length > 1) {
      currentSongIndex = int(random(titles.length));
      if (currentSongIndex != prevIdx) break;
    }
  } else {
    currentSongIndex--;
    if (currentSongIndex < 0) currentSongIndex = titles.length - 1;
  }
  loadCurrentSong();
}

void rewindFive() {
  if (song == null) return;
  int newPos = max(0, song.position() - 5000);
  song.cue(newPos);
}

void forwardFive() {
  if (song == null) return;
  int newPos = min(song.length(), song.position() + 5000);
  song.cue(newPos);
}

void autoNextSong() {
  if (isShuffle) {
    int prevIdx = currentSongIndex;
    while (titles.length > 1) {
      currentSongIndex = int(random(titles.length));
      if (currentSongIndex != prevIdx) break;
    }
  } else {
    currentSongIndex++;
    if (currentSongIndex >= titles.length) currentSongIndex = 0;
  }
  loadCurrentSong();
  song.play();
  isPlaying = true;
}

void stop() {
  if (song != null) {
    song.close();
  }
  minim.stop();
  super.stop();
}
