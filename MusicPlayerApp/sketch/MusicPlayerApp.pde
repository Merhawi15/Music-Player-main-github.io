// Import the Minim library for audio playback
import ddf.minim.*;

// Declare Minim and AudioPlayer objects to manage music
Minim minim;
AudioPlayer player;

// Image object to hold the album cover for the current song
PImage album;

// A boolean to keep track of whether a song is playing or not
boolean isPlaying = false;

// Index to track which song is currently selected
int currentSong = 0;

// Array holding file paths to the audio files
String[] songs = {
  "assets/audio/USO.mp3",             // YEET music by Merhawi Haile
  "assets/audio/OTC.mp3",             // OTC music by Merhawi Haile
  "assets/audio/U-CAN'T-SEE-ME.mp3"   // The Time Is Now (John Cena's theme)
};

// Array holding file paths to the album images that match each song
String[] albums = {
  "assets/images/ME-JU.jpg",  // Album art for USO.mp3
  "assets/images/1316.jpg",   // Album art for OTC.mp3
  "assets/images/JC.jpg"      // Album art for U-CAN'T-SEE-ME.mp3
};

// Titles to be displayed on screen for each song
String[] titles = {
  "YEET music - Merhawi Haile",
  "OTC Music - Merhawi Haile",
  "The Time Is Now music - Merhawi"
};

// Setup function is called once at the start
void setup() {
  fullScreen();                 // Open the app in full screen
  minim = new Minim(this);      // Initialize Minim for audio
  loadSong(currentSong);        // Load the first song
  
  textAlign(CENTER, CENTER);    // Set text alignment to center
  textFont(createFont("MV Boli", 60));  // Use fun MV Boli font
  fill(0, 0, 139);              // Dark blue text color
}

// draw() function runs continuously to update the screen
void draw() {
  background(255); // White background
  float centerX = width / 2; // Horizontal center of the screen

  // Draw outer border for design
  noFill();
  stroke(0);
  strokeWeight(5);
  rect(50, 50, width - 100, height - 100);
  
  // Draw a gray bar to show the current song title
  fill(200);
  rect(centerX - 300, 50, 600, 100);
  fill(0, 0, 139);
  text(titles[currentSong], centerX, 100); // Show current song title
  
  // Display the current album image
  image(album, centerX - 250, 180);
  
  // Draw all control buttons
  drawButtons(centerX);

  // Show the current song progress
  drawProgressBar(centerX);
  
  // Display a red "X" quit button
  drawQuitButton();
}

// Draws all 8 control buttons (play, stop, forward, etc.)
void drawButtons(float centerX) {
  float btnY = 550;  // Vertical position for buttons
  float btnSize = 100; // Button size
  float totalButtonWidth = btnSize * 8; // Total width of all buttons
  float buttonX = centerX - totalButtonWidth / 2; // Start position for buttons
  
  for (int i = 0; i < 8; i++) {
    fill(180);
    rect(buttonX, btnY, btnSize, btnSize); // Draw button
    fill(0);
    drawButtonIcon(i, buttonX, btnY); // Draw symbol on button
    buttonX += btnSize; // Move to next button position
  }
}

// Draws the icon (triangle, rectangle, etc.) for each control button
void drawButtonIcon(int index, float x, float y) {
  switch (index) {
    case 0: // Fast Backward
      triangle(x + 40, y + 25, x + 40, y + 75, x + 10, y + 50);
      triangle(x + 60, y + 25, x + 60, y + 75, x + 30, y + 50);
      break;
    case 1: // Play or Pause depending on current state
      if (isPlaying) {
        rect(x + 25, y + 30, 20, 50);
        rect(x + 55, y + 30, 20, 50);
      } else {
        triangle(x + 35, y + 30, x + 35, y + 70, x + 65, y + 50);
      }
      break;
    case 2: // Stop
      rect(x + 25, y + 30, 50, 50);
      break;
    case 3: // Fast Forward
      triangle(x + 35, y + 25, x + 35, y + 75, x + 65, y + 50);
      triangle(x + 55, y + 25, x + 55, y + 75, x + 85, y + 50);
      break;
    case 4: // Next
      triangle(x + 35, y + 25, x + 35, y + 75, x + 65, y + 50);
      rect(x + 70, y + 25, 10, 50);
      break;
    case 5: // Previous
      triangle(x + 65, y + 25, x + 65, y + 75, x + 35, y + 50);
      rect(x + 25, y + 25, 10, 50);
      break;
    case 6: // Mute (icon not used yet)
      break;
    case 7: // Loop (icon not used yet)
      break;
  }
}

// Draws the progress bar and displays time elapsed and total time
void drawProgressBar(float centerX) {
  float barY = 700;
  float barWidth = 100 * 15;  // Long progress bar
  
  // Draw the full empty bar
  fill(220);
  rect(centerX - barWidth / 2, barY, barWidth, 30);
  
  // Fill progress bar depending on how much of the song has played
  if (player.isPlaying()) {
    float progress = map(player.position(), 0, player.length(), 0, barWidth);
    fill(0, 0, 139);
    rect(centerX - barWidth / 2, barY, progress, 30);
  }

  // Show current time and total time
  int currentMillis = player.position();
  int totalMillis = player.length();
  String currentTime = nf(currentMillis / 60000, 2) + ":" + nf((currentMillis / 1000) % 60, 2);
  String totalTime = nf(totalMillis / 60000, 2) + ":" + nf((totalMillis / 1000) % 60, 2);
  
  fill(0);
  textSize(24);
  text(currentTime + " / " + totalTime, centerX, barY + 40);
}

// Draw the red "X" button in the top-right corner to quit the app
void drawQuitButton() {
  fill(200);
  rect(width - 90, 30, 50, 50);
  fill(255, 0, 0);
  textSize(30);
  text("X", width - 60, 55);
}

// Handle mouse clicks for buttons
void mousePressed() {
  float centerX = width / 2;
  float btnY = 550;
  float btnSize = 100;
  float totalButtonWidth = btnSize * 8;
  float buttonX = centerX - totalButtonWidth / 2;
  
  // Check if user clicked any of the 8 control buttons
  for (int i = 0; i < 8; i++) {
    if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) {
      handleButtonPress(i);
    }
    buttonX += btnSize;
  }

  // Check if user clicked the quit button
  if (mouseX > width - 90 && mouseX < width - 40 && mouseY > 30 && mouseY < 80) {
    exit();  // Close the application
  }
}

// Handle the behavior of each control button when clicked
void handleButtonPress(int index) {
  switch (index) {
    case 0:  // Rewind by 5 seconds
      player.cue(max(player.position() - 5000, 0));
      break;
    case 1:  // Toggle play/pause
      if (isPlaying) {
        player.pause();
        isPlaying = false;
      } else {
        player.play();
        isPlaying = true;
      }
      break;
    case 2:  // Stop and rewind
      player.pause();
      player.rewind();
      isPlaying = false;
      break;
    case 3:  // Fast forward by 5 seconds
      player.cue(min(player.position() + 5000, player.length()));
      break;
    case 4:  // Next song
      currentSong = (currentSong + 1) % songs.length;
      loadSong(currentSong);
      break;
    case 5:  // Previous song
      currentSong = (currentSong - 1 + songs.length) % songs.length;
      loadSong(currentSong);
      break;
    case 6:  // Mute button not used yet
      break;
    case 7:  // Loop button not used yet
      break;
  }
}

// Loads a new song and image based on selected index
void loadSong(int index) {
  if (player != null) {
    player.close();  // Stop and close current player
  }
  player = minim.loadFile(songs[index]);  // Load new audio
  album = loadImage(albums[index]);       // Load new album image
  album.resize(500, 300);                 // Resize album to fit display
  isPlaying = false;                      // Start in paused state
}
