// Load audio
import ddf.minim.*; // Import the Minim library for audio processing

// Audio setup
Minim minim; // Declare Minim object for audio control
AudioPlayer player; // Declare an AudioPlayer object to handle song playback

// Image for song
PImage album; // Declare a PImage object to hold the album image

// Is the song playing?
boolean isPlaying = false; // Track whether the song is currently playing

// Song number
int currentSong = 0; // Keeps track of the current song index (starting with 0)

// Song files
String[] songs = { // Array containing the paths to the song files
  "assets/audio/USO.mp3",
  "assets/audio/OTC.mp3",
  "assets/audio/U-CAN'T-SEE-ME.mp3"
};

// Album pictures
String[] albums = { // Array containing the paths to the album artwork images
  "assets/images/ME-JU.jpg",
  "assets/images/1316.jpg",
  "assets/images/JC.jpg"
};

// Song names
String[] titles = { // Array containing the titles of the songs
  "YEET music - Merhawi Haile",
  "OTC Music - Merhawi Haile",
  "The Time Is Now music - Merhawi"
};

// Start the app
void setup() {
  fullScreen(); // Set the app to run in full-screen mode
  minim = new Minim(this); // Initialize the Minim object
  loadSong(currentSong); // Load the initial song
  textAlign(CENTER, CENTER); // Set the text alignment to center
  textFont(createFont("MV Boli", 60)); // Set the font to "MV Boli" with size 60
  fill(0, 0, 139); // Set the text color to dark blue
}

// Draw everything
void draw() {
  background(255); // Set the background color to white
  float centerX = width / 2; // Calculate the center X position for drawing elements

  // Border
  noFill(); // Don't fill the rectangle
  stroke(0); // Set the border color to black
  strokeWeight(5); // Set the border thickness to 5
  rect(50, 50, width - 100, height - 100); // Draw the outer rectangle (border)

  // Song title
  fill(200); // Set the fill color to a light gray
  rect(centerX - 300, 50, 600, 100); // Draw the background rectangle for the song title
  fill(0, 0, 139); // Set the fill color to dark blue for the title text
  text(titles[currentSong], centerX, 100); // Display the current song title

  // Album picture
  image(album, centerX - 250, 180); // Display the album image centered below the title

  // Buttons
  drawButtons(centerX); // Call the function to draw all buttons

  // Progress bar
  drawProgressBar(centerX); // Call the function to draw the progress bar for song time

  // Quit button
  drawQuitButton(); // Draw the red X quit button
}

// Draw all 8 buttons
void drawButtons(float centerX) {
  float btnY = 550; // Set the Y position of the buttons
  float btnSize = 100; // Set the size of each button
  float totalButtonWidth = btnSize * 8; // Calculate the total width of all buttons combined
  float buttonX = centerX - totalButtonWidth / 2; // Set the starting X position for the first button

  for (int i = 0; i < 8; i++) { // Loop through all 8 buttons
    fill(180); // Set the button color to a light gray
    rect(buttonX, btnY, btnSize, btnSize); // Draw the button as a rectangle
    fill(0); // Set the fill color to black for button icons
    drawButtonIcon(i, buttonX, btnY); // Draw the button icon for the current button
    buttonX += btnSize; // Move the X position to the right for the next button
  }
}

// Button icons
void drawButtonIcon(int index, float x, float y) {
  switch (index) { // Handle each button based on its index
    case 0: // Rewind button
      triangle(x + 40, y + 25, x + 40, y + 75, x + 10, y + 50); // Draw the first triangle for rewind
      triangle(x + 60, y + 25, x + 60, y + 75, x + 30, y + 50); // Draw the second triangle for rewind
      break;
    case 1: // Play or pause button
      if (isPlaying) { // If the song is playing, show pause icon
        rect(x + 25, y + 30, 20, 50); // Draw the first pause rectangle
        rect(x + 55, y + 30, 20, 50); // Draw the second pause rectangle
      } else { // If the song is not playing, show play icon
        triangle(x + 35, y + 30, x + 35, y + 70, x + 65, y + 50); // Draw the play triangle
      }
      break;
    case 2: // Stop button
      rect(x + 25, y + 30, 50, 50); // Draw the stop button as a square
      break;
    case 3: // Fast forward button
      triangle(x + 35, y + 25, x + 35, y + 75, x + 65, y + 50); // Draw the first triangle for fast forward
      triangle(x + 55, y + 25, x + 55, y + 75, x + 85, y + 50); // Draw the second triangle for fast forward
      break;
    case 4: // Next song button
      triangle(x + 35, y + 25, x + 35, y + 75, x + 65, y + 50); // Draw the first triangle for next song
      rect(x + 70, y + 25, 10, 50); // Draw the vertical line to complete the next song icon
      break;
    case 5: // Previous song button
      triangle(x + 65, y + 25, x + 65, y + 75, x + 35, y + 50); // Draw the first triangle for previous song
      rect(x + 25, y + 25, 10, 50); // Draw the vertical line to complete the previous song icon
      break;
    case 6: // Not used (empty space)
      break;
    case 7: // Not used (empty space)
      break;
  }
}

// Progress bar and song time
void drawProgressBar(float centerX) {
  float barY = 700; // Set the Y position of the progress bar
  float barWidth = 100 * 15; // Set the width of the progress bar
  
  fill(220); // Set the progress bar color to light gray
  rect(centerX - barWidth / 2, barY, barWidth, 30); // Draw the background progress bar
  
  if (player.isPlaying()) { // If the song is playing, show the current progress
    float progress = map(player.position(), 0, player.length(), 0, barWidth); // Calculate the progress as a percentage of the total song length
    fill(0, 0, 139); // Set the progress color to dark blue
    rect(centerX - barWidth / 2, barY, progress, 30); // Draw the filled portion of the progress bar
  }

  // Calculate current and total time
  int currentMillis = player.position(); // Get the current song position in milliseconds
  int totalMillis = player.length(); // Get the total song length in milliseconds
  String currentTime = nf(currentMillis / 60000, 2) + ":" + nf((currentMillis / 1000) % 60, 2); // Format the current time as minutes:seconds
  String totalTime = nf(totalMillis / 60000, 2) + ":" + nf((totalMillis / 1000) % 60, 2); // Format the total time as minutes:seconds
  
  fill(0); // Set the text color to black
  textSize(24); // Set the text size to 24
  text(currentTime + " / " + totalTime, centerX, barY + 40); // Display the current time and total time on the screen
}

// Red X quit button
void drawQuitButton() {
  fill(200); // Set the button background color to light gray
  rect(width - 90, 30, 50, 50); // Draw the red X button as a square
  fill(255, 0, 0); // Set the fill color to red for the X
  textSize(30); // Set the text size to 30
  text("X", width - 60, 55); // Draw the X character in the button
}

// When mouse is clicked
void mousePressed() {
  float centerX = width / 2; // Calculate the center X position for buttons
  float btnY = 550; // Set the Y position of the buttons
  float btnSize = 100; // Set the size of the buttons
  float totalButtonWidth = btnSize * 8; // Calculate the total width of the buttons
  float buttonX = centerX - totalButtonWidth / 2; // Set the starting X position for the first button
  
  for (int i = 0; i < 8; i++) { // Loop through all 8 buttons
    if (mouseX > buttonX && mouseX < buttonX + btnSize && mouseY > btnY && mouseY < btnY + btnSize) { // Check if the mouse click is inside the button area
      handleButtonPress(i); // Call the function to handle the button press
    }
    buttonX += btnSize; // Move the X position for the next button
  }

  // Quit if X is clicked
  if (mouseX > width - 90 && mouseX < width - 40 && mouseY > 30 && mouseY < 80) { // Check if the quit button (X) is clicked
    exit(); // Exit the program if the quit button is pressed
  }
}

// What each button does
void handleButtonPress(int index) {
  switch (index) { // Handle button actions based on their index
    case 0: // Back 5 sec
      player.cue(max(player.position() - 5000, 0)); // Rewind the song by 5 seconds
      break;
    case 1: // Play or pause
      if (isPlaying) { // If the song is playing, pause it
        player.pause();
        isPlaying = false;
      } else { // If the song is paused, play it
        player.play();
        isPlaying = true;
      }
      break;
    case 2: // Stop
      player.pause(); // Pause the song
      player.rewind(); // Rewind the song to the beginning
      isPlaying = false; // Set isPlaying to false (song is not playing)
      break;
    case 3: // Forward 5 sec
      player.cue(min(player.position() + 5000, player.length())); // Fast forward the song by 5 seconds
      break;
    case 4: // Next song
      currentSong = (currentSong + 1) % songs.length; // Go to the next song (wrap around if at the last song)
      loadSong(currentSong); // Load the next song
      break;
    case 5: // Previous song
      currentSong = (currentSong - 1 + songs.length) % songs.length; // Go to the previous song (wrap around if at the first song)
      loadSong(currentSong); // Load the previous song
      break;
    case 6: // Not used
      break;
    case 7: // Not used
      break;
  }
}

// Load a song and image
void loadSong(int index) {
  if (player != null) { // If there is an existing player, close it
    player.close();
  }
  player = minim.loadFile(songs[index]); // Load the new song file
  album = loadImage(albums[index]); // Load the new album image
  album.resize(500, 300); // Resize the album image to fit the screen
  isPlaying = false; // Set the song to be paused initially
}

// End Main Program
