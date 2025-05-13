/**
 * MUSIC PLAYER APP by Merhawi Haile
 * 
 * WHAT EACH PART DOES:
 * 
 * setup() – Starts the app, loads the first song and album.
 * draw() – Draws everything on screen (background, buttons, song info).
 * drawButtons() – Shows 8 buttons for controlling the music.
 * drawButtonIcon() – Puts a symbol (like play or pause) on each button.
 * drawProgressBar() – Shows how much of the song has played.
 * drawQuitButton() – Shows the red "X" to quit the app.
 * mousePressed() – Checks if a button or the quit box was clicked.
 * handleButtonPress() – Does what each button should do (like play, skip).
 * loadSong() – Loads a new song and album image.
 */

// Import audio library
import ddf.minim.*;

// Setup for audio
Minim minim;
AudioPlayer player;

// Image for song cover
PImage album;

// Track if song is playing
boolean isPlaying = false;

// Keep track of current song
int currentSong = 0;

// List of songs
String[] songs = {
  "assets/audio/USO.mp3",
  "assets/audio/OTC.mp3",
  "assets/audio/U-CAN'T-SEE-ME.mp3"
};

// List of album pictures
String[] albums = {
  "assets/images/ME-JU.jpg",
  "assets/images/1316.jpg",
  "assets/images/JC.jpg"
};

// Song titles
String[] titles = {
  "YEET music - Merhawi Haile",
  "OTC Music - Merhawi Haile",
  "The Time Is Now music - Merhawi"
};

// Run once at start
void setup() {
  fullScreen();
  minim = new Minim(this);
  loadSong(currentSong);
  
  textAlign(CENTER, CENTER);
  textFont(createFont("MV Boli", 60));
  fill(0, 0, 139);
}

// Keeps running
void draw() {
  background(255);
  float centerX = width / 2;

  // Border
  noFill();
  stroke(0);
  strokeWeight(5);
  rect(50, 50, width - 100, height - 100);
  
  // Song title bar
  fill(200);
  rect(centerX - 300, 50, 600, 100);
  fill(0, 0, 139);
  text(titles[currentSong], centerX, 100);
  
  // Show album picture
  image(album, centerX - 250, 180);
  
  // Show buttons
  drawButtons(centerX);

  // Show song progress
  drawProgressBar(centerX);
  
  // Show quit button
  drawQuitButton();
}

// Draw buttons
void drawButtons(float centerX) {
  float btnY = 550;
  float btnSize = 100;
  float totalButtonWidth = btnSize * 8;
  float buttonX = centerX - totalButtonWidth / 2;
  
  for (int i = 0; i < 8; i++) {
    fill(180);
    rect(buttonX, btnY, btnSize, btnSize);
    fill(0);
    drawButtonIcon(i, buttonX, btnY);
    buttonX += btnSize;
  }
}

// Draw symbol on each button
void drawButtonIcon(int index, float x, float y) {
  switch (index) {
    case 0:
      triangle(x + 40, y + 25, x + 40, y + 75, x + 10, y + 50);
      triangle(x + 60, y + 25, x + 60, y + 75, x + 30, y + 50);
      break;
    case 1:
      if (isPlaying) {
        rect(x + 25, y + 30, 20, 50);
        rect(x + 55, y + 30, 20, 50);
      } else {
        triangle(x + 35, y + 30, x + 35, y + 70, x + 65, y + 50);
      }
      break;
    case 2:
      rect(x + 25, y + 30, 50, 50);
      break;
    case 3:
      triangle(x + 35, y + 25, x + 35, y + 75, x + 65, y + 50);
      triangle(x + 55, y + 25, x + 55, y + 75, x + 85, y + 50);
      break;
    case 4:
      triangle(x + 35, y + 25, x + 35, y + 75, x + 65, y + 50);
      rect(x + 70, y + 25, 10, 50);
      break;
    case 5:
      triangle(x + 65, y + 25, x + 65, y + 75, x + 35, y + 50);
      rect(x + 25, y + 25, 10, 50);
      break;
    case 6:
      break;
    case 7:
      break;
  }
}

// Progress bar and time
void drawProgressBar(float centerX) {
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
}

// Draw quit box
void drawQuitButton() {
  fill(200);
  rect(width - 90, 30, 50, 50);
  fill(255, 0, 0);
  textSize(30);
  text("X", width - 60, 55);
}

// When user clicks
void mousePressed() {
  float centerX = width / 2;
  float btnY = 550;
  float btnSize = 100;
  float totalButtonWidth = btnSize * 8;
  float buttonX = centerX - totalButtonWidth / 2;
  
  for (int i = 0; i < 8; i++) {
    if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
      handleButtonPress(i);
    }
    buttonX += btnSize;
  }

  if (mouseX > width - 90 && mouseX < width - 40 && mouseY > 30 && mouseY < 80) {
    exit();
  }
}

// What buttons do
void handleButtonPress(int index) {
  switch (index) {
    case 0:
      player.cue(max(player.position() - 5000, 0));
      break;
    case 1:
      if (isPlaying) {
        player.pause();
        isPlaying = false;
      } else {
        player.play();
        isPlaying = true;
      }
      break;
    case 2:
      player.pause();
      player.rewind();
      isPlaying = false;
      break;
    case 3:
      player.cue(min(player.position() + 5000, player.length()));
      break;
    case 4:
      currentSong = (currentSong + 1) % songs.length;
      loadSong(currentSong);
      break;
    case 5:
      currentSong = (currentSong - 1 + songs.length) % songs.length;
      loadSong(currentSong);
      break;
    case 6:
      break;
    case 7:
      break;
  }
}

// Load new song and image
void loadSong(int index) {
  if (player != null) {
    player.close();
  }
  player = minim.loadFile(songs[index]);
  album = loadImage(albums[index]);
  album.resize(500, 300);
  isPlaying = false;
}
