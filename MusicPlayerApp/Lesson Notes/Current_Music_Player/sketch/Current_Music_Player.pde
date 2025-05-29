import ddf.minim.*; // Import the basic Minim audio library.
import ddf.minim.analysis.*; // Import Minim's analysis features (not directly used here).
import ddf.minim.effects.*; // Import Minim's effects (not directly used here).
import ddf.minim.signals.*; // Import Minim's signal generators (not used directly).
import ddf.minim.spi.*; // Import Minim's service provider interface (not directly used here).
import ddf.minim.ugens.*; // Import Minim's unit generators (not directly used here).

Minim minim; // Declare a Minim object for handling audio.
AudioPlayer song; // Declare an AudioPlayer for the current song.
PImage albumImg; // Declare a PImage for the current album artwork.
PFont mvBoliFont; // Declare a PFont for custom font usage.

boolean isPlaying = false; // Boolean to track if the song is playing.
boolean isShuffle = false; // Boolean to track if shuffle mode is enabled.
boolean isRepeat = false; // Boolean to track if repeat mode is enabled.
boolean isMuted = false; // Boolean to track if mute is active.

String[] titles = { // Array of song titles.
  "Main Event Jey Uso - ISH", // First song title.
  "Roman Reigns - I Am Greatness", // Second song title.
  "John Cena - The Time Is Now" // Third song title.
}; // End of song titles array.

String[] audioPaths = { // Array of file paths for audio files.
  "assets/audio/USO.mp3", // Path to first audio file.
  "assets/audio/OTC.mp3", // Path to second audio file.
  "assets/audio/U-CAN'T-SEE-ME.mp3" // Path to third audio file.
}; // End of audioPaths array.

String[] imagePaths = { // Array of file paths for album images.
  "assets/images/ME-JU.jpg", // Path to first album image.
  "assets/images/1316.jpg", // Path to second album image.
  "assets/images/JC.jpg" // Path to third album image.
}; // End of imagePaths array.

color[] titleColors = { // Array of colors for song title display.
  color(0, 0, 255),     // Blue color for first song.
  color(255, 165, 0),   // Orange color for second song.
  color(0, 200, 0)      // Green color for third song.
}; // End of titleColors array.

int currentSongIndex = 0; // Index of the currently selected song.

// Dimensions as floats for smooth positioning
float appWidth, appHeight; // Application width and height.
float titleHeight = 60.0; // Height of the title bar.
float topMargin = 20.0; // Top margin for UI layout.
float albumX, albumWidth, albumY, albumHeight; // Variables for album image position and size.
float buttonWidth, buttonHeight, buttonY; // Variables for button sizes and Y position.
float barY, barHeight; // Y position and height of progress bar.
float quitSize, quitX, quitY; // Size and position of quit button.

// Volume
float volume = 0.7;  // between 0 and 1 // Default playback volume (70%).

// Button indices (no more magic numbers)
final int BTN_PREV    = 2; // Index for previous song button.
final int BTN_REWIND  = 4; // Index for rewind button.
final int BTN_PLAY    = 5; // Index for play/pause button.
final int BTN_STOP    = 6; // Index for stop button.
final int BTN_FFWD    = 7; // Index for fast-forward button.
final int BTN_NEXT    = 9; // Index for next song button.
final int BTN_SHUFFLE = 10; // Index for shuffle button.
final int BTN_REPEAT  = 11; // Index for repeat button.

// For progress bar click
boolean isSeeking = false; // Boolean to track if user is seeking in progress bar.

void setup() { // Processing setup function, runs once at start.
  fullScreen(); // Make the application fullscreen.
  appWidth = (float) displayWidth; // Set appWidth to display width.
  appHeight = (float) displayHeight; // Set appHeight to display height.

  mvBoliFont = loadFont("MVBoli-48.vlw"); // Load custom font.
  minim = new Minim(this); // Initialize Minim library.

  // Calculate dimensions based on screen size (floats)
  albumX = appWidth * 0.25f; // Set X position for album image.
  albumWidth = appWidth * 0.5f; // Set width for album image.
  albumY = topMargin + titleHeight + 20.0f; // Set Y position for album image.
  albumHeight = appHeight / 3.0f; // Set height for album image.

  buttonWidth = appWidth / 12.0f; // Set button width based on app size.
  buttonHeight = buttonWidth; // Set button height equal to width.
  buttonY = albumY + albumHeight + 20.0f; // Set Y position for buttons.

  barY = buttonY + buttonHeight + 20.0f; // Set Y position for progress bar.
  barHeight = 40.0f; // Set progress bar height.

  quitSize = 40.0f; // Set size for quit button.
  quitX = appWidth - quitSize - 10.0f; // Set X position for quit button.
  quitY = 10.0f; // Set Y position for quit button.

  loadCurrentSong(); // Load the currently selected song.
} // End of setup().

void draw() { // Processing draw function, loops continuously.
  background(255); // Set background color to white.

  drawTitleBar(); // Draw the song title bar.
  drawAlbumImage(); // Draw the current album image.
  drawButtons(); // Draw the control buttons.
  drawProgressBar(); // Draw the progress bar.
  drawTimeLabels(); // Draw the time labels for current/total time.
  drawQuitButton(); // Draw the quit button.

  // Auto-next and repeat logic
  if (song != null && !song.isPlaying() && isPlaying) { // If the song exists, isn't playing, but isPlaying is true
    if (isRepeat) { // If repeat mode is active
      song.rewind(); // Rewind song to start.
      song.play(); // Play song again.
    } else {
      autoNextSong(); // Otherwise, go to next song automatically.
    }
  }
} // End of draw().

void drawTitleBar() { // Draw the title bar at the top.
  fill(220); // Fill color for title bar background.
  stroke(0); // Set border color to black.
  strokeWeight(2); // Set border thickness.
  rect(albumX, topMargin, albumWidth, titleHeight); // Draw rectangle for title bar.

  fill(titleColors[currentSongIndex]); // Set fill color for song title.
  textFont(mvBoliFont); // Set the font for title.
  textAlign(CENTER, CENTER); // Center align the text.
  text(titles[currentSongIndex], appWidth / 2.0f, topMargin + titleHeight / 2.0f); // Draw the current song title.
} // End of drawTitleBar().

void drawAlbumImage() { // Draws the album image or a placeholder.
  if (albumImg != null) { // If album image loaded successfully
    image(albumImg, albumX, albumY, albumWidth, albumHeight); // Draw the album image.
  } else {
    fill(200); // Use gray fill for placeholder.
    rect(albumX, albumY, albumWidth, albumHeight); // Draw placeholder rectangle.
    fill(0); // Set text color to black.
    textAlign(CENTER, CENTER); // Center align the text.
    textSize(32); // Set text size for placeholder.
    text("Image not found", albumX + albumWidth / 2.0f, albumY + albumHeight / 2.0f); // Show "Image not found".
  }
} // End of drawAlbumImage().

void drawButtons() { // Draws all the control buttons.
  stroke(0); // Set border color for buttons.
  strokeWeight(1); // Set border thickness for buttons.

  for (int i = 0; i < 12; i++) { // Loop over all 12 button positions.
    float buttonX = buttonWidth * i; // Calculate X position for each button.
    // Hover effect
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
        mouseY > buttonY && mouseY < buttonY + buttonHeight) { // If mouse is over the button
      fill(150); // Use darker fill for hover.
    } else {
      fill(180); // Use lighter fill for normal state.
    }
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 8); // Draw the button rectangle with rounded corners.
  }

  fill(0); // Set icon color to black.
  for (int i = 0; i < 12; i++) { // Loop again for drawing button icons.
    float buttonX = buttonWidth * i; // X position of button.
    float centerX = buttonX + buttonWidth / 2.0f; // Center X of button.
    float centerY = buttonY + buttonHeight / 2.0f; // Center Y of button.
    float size = buttonWidth / 3.0f; // Icon size.
    float gap = 5.0f; // Gap used in icons.

    if (i == 0) { // Mute/Unmute toggle button at the most left
      stroke(0);
      strokeWeight(3);
      noFill();
      // Speaker body (rectangle)
      float spkW = size * 0.5f;
      float spkH = size * 0.7f;
      beginShape();
      vertex(centerX - spkW * 0.5, centerY - spkH * 0.5);
      vertex(centerX - spkW * 0.5, centerY + spkH * 0.5);
      vertex(centerX + spkW * 0.3, centerY + spkH * 0.5);
      vertex(centerX + spkW * 0.3, centerY - spkH * 0.5);
      endShape(CLOSE);

      if (isMuted) {
        // Mute icon: draw a red "X" over the speaker
        stroke(255, 0, 0);
        strokeWeight(4);
        line(centerX + spkW * 0.4, centerY - spkH * 0.5, centerX + spkW * 0.9, centerY + spkH * 0.5);
        line(centerX + spkW * 0.9, centerY - spkH * 0.5, centerX + spkW * 0.4, centerY + spkH * 0.5);
        stroke(0);
      } else {
        // Unmute icon: draw sound waves
        noFill();
        strokeWeight(3);
        arc(centerX + spkW * 0.7, centerY, size * 0.4f, size * 0.4f, -PI/4, PI/4);
        arc(centerX + spkW * 1.0, centerY, size * 0.7f, size * 0.7f, -PI/4, PI/4);
      }
      strokeWeight(1);
      fill(0);
    }

    if (i == BTN_PREV) { // Previous song button.
      rect(centerX - size / 2.0f, centerY - size / 2.0f, size / 5.0f, size); // Draw bar.
      triangle(centerX - size / 2.0f + size / 5.0f, centerY,
               centerX + size / 2.0f, centerY - size / 2.0f,
               centerX + size / 2.0f, centerY + size / 2.0f); // Draw triangle arrow.
    }
    if (i == BTN_REWIND) { // Rewind 5 seconds button.
      triangle(centerX + size + gap, centerY - size / 2.0f, centerX + size + gap, centerY + size / 2.0f, centerX + gap, centerY); // Second triangle.
      triangle(centerX, centerY - size / 2.0f, centerX, centerY + size / 2.0f, centerX - size, centerY); // First triangle.
    }
    if (i == BTN_PLAY) { // Play/Pause button.
      if (isPlaying) { // If currently playing, show pause icon.
        float barWidth = size / 4.0f; // Width of pause bars.
        rect(centerX - barWidth - 2.0f, centerY - size / 2.0f, barWidth, size); // Left pause bar.
        rect(centerX + 2.0f, centerY - size / 2.0f, barWidth, size); // Right pause bar.
      } else { // Otherwise show play icon.
        triangle(centerX - size / 2.0f, centerY - size / 2.0f, centerX - size / 2.0f, centerY + size / 2.0f, centerX + size / 2.0f, centerY); // Play triangle.
      }
    }
    if (i == BTN_STOP) { // Stop button.
      rect(centerX - size / 2.0f, centerY - size / 2.0f, size, size); // Square for stop.
    }
    if (i == BTN_FFWD) { // Fast-forward button.
      triangle(centerX - size - gap, centerY - size / 2.0f, centerX - size - gap, centerY + size / 2.0f, centerX - gap, centerY); // First triangle.
      triangle(centerX, centerY - size / 2.0f, centerX, centerY + size / 2.0f, centerX + size, centerY); // Second triangle.
    }
    if (i == BTN_NEXT) { // Next song button.
      triangle(centerX - size, centerY - size / 2.0f, centerX - size, centerY + size / 2.0f, centerX, centerY); // Arrow.
      rect(centerX, centerY - size / 2.0f, size / 3.0f, size); // Bar.
    }
    if (i == BTN_SHUFFLE) { // Shuffle button.
      stroke(0, isShuffle ? 180 : 80, 0); // Change color if active.
      strokeWeight(3); // Thicker lines for arrows.
      noFill(); // No fill for lines.
      beginShape(); // Start first arrow.
      vertex(centerX - size/2, centerY + size/2);
      vertex(centerX + size/2, centerY - size/2);
      endShape();
      beginShape(); // Start second arrow.
      vertex(centerX - size/2, centerY - size/2);
      vertex(centerX + size/2, centerY + size/2);
      endShape();
      // Arrow heads
      triangle(centerX + size/2-5, centerY - size/2-3, centerX + size/2+5, centerY - size/2, centerX + size/2-5, centerY - size/2+3); // First head.
      triangle(centerX + size/2-5, centerY + size/2-3, centerX + size/2+5, centerY + size/2, centerX + size/2-5, centerY + size/2+3); // Second head.
      stroke(0);
      fill(0);
    }
    if (i == BTN_REPEAT) { // Repeat button.
      stroke(0, 0, isRepeat ? 180 : 80); // Color changes if repeat active.
      strokeWeight(3); // Thicker line for arc.
      noFill(); // No fill for arc.
      arc(centerX, centerY, size, size, PI/3, TWO_PI-PI/3); // Draw arc.
      float a = PI/3; // Angle for arrow head.
      float r = size/2; // Radius for arc.
      float ax = centerX + cos(a)*r; // Arrow X position.
      float ay = centerY + sin(a)*r; // Arrow Y position.
      triangle(ax, ay, ax-8, ay-5, ax-8, ay+5); // Draw the arrow head.
      stroke(0);
      fill(0);
    }
  }
} // End of drawButtons().

void drawProgressBar() { // Draw the playback progress bar.
  stroke(0); // Set border color.
  strokeWeight(2); // Set border thickness.
  fill(155); // Fill color for progress bar background.
  rect(0, barY, appWidth, barHeight); // Draw the progress bar background.

  if (song != null && song.length() > 0) { // If a song is loaded and has length.
    float progress = map(song.position(), 0, song.length(), 0, appWidth); // Calculate progress as width.
    fill(0);  // Black color for progress
    noStroke(); // No border for progress rect.
    rect(0, barY, progress, barHeight); // Draw the filled progress.
  }
} // End of drawProgressBar().

void drawTimeLabels() { // Draws current and total time labels.
  float smallW = appWidth * 0.1f; // Small box width for time label.
  float smallH = 20.0f; // Height for time label box.
  float smallY = barY + barHeight + 10.0f; // Y position for time labels.
  float rightX = appWidth - smallW - 10.0f; // Right box X position.
  float leftX = rightX - smallW; // Left box X position.

  fill(200); // Fill color for boxes.
  stroke(0); // Border color.
  rect(leftX, smallY, smallW, smallH); // Draw left box for current time.
  rect(rightX, smallY, smallW, smallH); // Draw right box for total time.

  fill(0); // Text color.
  textAlign(CENTER, CENTER); // Center text.
  textSize(24); // Text size.

  int currentMillis = song != null ? song.position() : 0; // Get song's current position.
  int currentSeconds = currentMillis / 1000; // Convert to seconds.
  int currentMinutes = currentSeconds / 60; // Convert to minutes.
  currentSeconds %= 60; // Remainder seconds.

  int totalMillis = song != null ? song.length() : 0; // Get total song length.
  int totalSeconds = totalMillis / 1000; // Total seconds.
  int totalMinutes = totalSeconds / 60; // Total minutes.
  totalSeconds %= 60; // Remainder seconds.

  String currentTime = nf(currentMinutes, 1) + ":" + nf(currentSeconds, 2); // Format current time.
  String totalTime = nf(totalMinutes, 1) + ":" + nf(totalSeconds, 2); // Format total time.

  text(currentTime, leftX + smallW / 2.0f, smallY + smallH / 2.0f); // Draw current time label.
  text(totalTime, rightX + smallW / 2.0f, smallY + smallH / 2.0f); // Draw total time label.
} // End of drawTimeLabels().

void drawQuitButton() { // Draws a button to quit the application.
  boolean hover = (mouseX > quitX && mouseX < quitX + quitSize && mouseY > quitY && mouseY < quitY + quitSize); // Check if mouse is over quit button.
  stroke(0); // Border color.
  strokeWeight(2); // Border thickness.
  if (hover) fill(255, 220, 220); // Fill red if hovered.
  else noFill(); // No fill otherwise.
  rect(quitX, quitY, quitSize, quitSize, 5); // Draw quit button rectangle.

  pushMatrix(); // Save transformation state.
  translate(quitX + quitSize / 2.0f, quitY + quitSize / 2.0f); // Move origin to center of quit button.
  rotate(radians(45)); // Rotate for X symbol.
  stroke(255, 0, 0); // Red stroke for X.
  strokeWeight(3); // Thicker lines for X.
  line(-10, 0, 10, 0); // Draw first line of X.
  line(0, -10, 0, 10); // Draw second line of X.
  popMatrix(); // Restore transformation.
} // End of drawQuitButton().

void mousePressed() { // Handles mouse press events.
  // Progress bar seek
  if (mouseY > barY && mouseY < barY + barHeight) { // Check if click is on progress bar.
    float clickRatio = constrain(mouseX / appWidth, 0, 1); // Get position ratio.
    if (song != null) {
      int newPos = int(song.length() * clickRatio); // Calculate new song position.
      song.cue(newPos); // Seek to new position.
    }
    return; // Don't process further.
  }

  // Control buttons
  for (int i = 0; i < 12; i++) { // Loop through all control buttons.
    float buttonX = buttonWidth * i; // Calculate button X position.
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
        mouseY > buttonY && mouseY < buttonY + buttonHeight) { // Check if mouse is over button.
      switch(i) { // Handle button actions.
        case 0: // Mute/Unmute toggle button
          isMuted = !isMuted; // Toggle mute state
          if (song != null) song.setGain(isMuted ? -80 : map(volume, 0, 1, -80, 0)); // Mute or restore volume
          break;
        case BTN_PREV:    prevSong(); break; // Previous song.
        case BTN_REWIND:  rewindFive(); break; // Rewind 5 seconds.
        case BTN_PLAY:    togglePlayPause(); break; // Play or pause.
        case BTN_STOP:    stopSong(); break; // Stop song.
        case BTN_FFWD:    forwardFive(); break; // Forward 5 seconds.
        case BTN_NEXT:    nextSong(); break; // Next song.
        case BTN_SHUFFLE: isShuffle = !isShuffle; break; // Toggle shuffle.
        case BTN_REPEAT:  isRepeat = !isRepeat; break; // Toggle repeat.
      }
    }
  }

  // Quit button
  if (mouseX > quitX && mouseX < quitX + quitSize &&
      mouseY > quitY && mouseY < quitY + quitSize) { // If mouse on quit button.
    exit(); // Exit the application.
  }
} // End of mousePressed().

void keyPressed() { // Handles key press events.
  if (key == ' ' || key == 'k') togglePlayPause(); // Space or 'k' toggles play/pause.
  else if (keyCode == RIGHT) nextSong(); // Right arrow for next song.
  else if (keyCode == LEFT) prevSong(); // Left arrow for previous song.
  else if (keyCode == UP) setVolume(volume + 0.05f); // Up arrow increases volume.
  else if (keyCode == DOWN) setVolume(volume - 0.05f); // Down arrow decreases volume.
} // End of keyPressed().

void setVolume(float v) { // Sets the playback volume.
  volume = constrain(v, 0, 1); // Constrain volume between 0 and 1.
  if (song != null && !isMuted) song.setGain(map(volume, 0, 1, -80, 0)); // Set gain for audio output, only if not muted.
} // End of setVolume().

void loadCurrentSong() { // Loads the current song and album image.
  if (song != null) {
    song.close(); // Close previous song if it exists.
  }
  song = minim.loadFile(audioPaths[currentSongIndex]); // Load new audio file.
  albumImg = loadImage(imagePaths[currentSongIndex]); // Load new album image.
  isPlaying = false; // Set playing state to false.
  setVolume(volume); // Set volume for new song.
  if (song != null) song.setGain(isMuted ? -80 : map(volume, 0, 1, -80, 0)); // Apply mute state.
} // End of loadCurrentSong().

void togglePlayPause() { // Toggles play and pause states.
  if (song == null) return; // Do nothing if song is null.
  if (isPlaying) { // If playing,
    song.pause(); // Pause song.
    isPlaying = false; // Set playing state to false.
  } else { // If not playing,
    song.play(); // Play song.
    isPlaying = true; // Set playing state to true.
  }
} // End of togglePlayPause().

void stopSong() { // Stops the current song and resets position.
  if (song == null) return; // Do nothing if song is null.
  song.pause(); // Pause playback.
  song.rewind(); // Rewind to start.
  isPlaying = false; // Set playing state to false.
} // End of stopSong().

void nextSong() { // Moves to the next song (or random if shuffle).
  if (isShuffle) { // If shuffle mode,
    int prevIdx = currentSongIndex; // Store previous index.
    while (titles.length > 1) { // Only if more than 1 song.
      currentSongIndex = int(random(titles.length)); // Pick random index.
      if (currentSongIndex != prevIdx) break; // Make sure it's different.
    }
  } else { // If not shuffle
    currentSongIndex++; // Go to next index.
    if (currentSongIndex >= titles.length) currentSongIndex = 0; // Loop to start if at end.
  }
  loadCurrentSong(); // Load the new song.
} // End of nextSong().

void prevSong() { // Moves to the previous song (or random if shuffle).
  if (isShuffle) { // If shuffle mode,
    int prevIdx = currentSongIndex; // Store current index.
    while (titles.length > 1) { // Only if more than 1 song.
      currentSongIndex = int(random(titles.length)); // Pick random index.
      if (currentSongIndex != prevIdx) break; // Ensure it's different.
    }
  } else { // If not shuffle,
    currentSongIndex--; // Move to previous index.
    if (currentSongIndex < 0) currentSongIndex = titles.length - 1; // Loop to last if at start.
  }
  loadCurrentSong(); // Load the new song.
} // End of prevSong().

void rewindFive() { // Rewinds playback by 5 seconds.
  if (song == null) return; // Do nothing if song is null.
  int newPos = max(0, song.position() - 5000); // Calculate new position.
  song.cue(newPos); // Seek to new position.
} // End of rewindFive().

void forwardFive() { // Fast-forwards playback by 5 seconds.
  if (song == null) return; // Do nothing if song is null.
  int newPos = min(song.length(), song.position() + 5000); // Calculate new position.
  song.cue(newPos); // Seek to new position.
} // End of forwardFive().

// Auto-next for end-of-song
void autoNextSong() { // Automatically goes to next song at end.
  if (isShuffle) { // If shuffle mode,
    int prevIdx = currentSongIndex; // Store previous index.
    while (titles.length > 1) { // Only if more than 1 song.
      currentSongIndex = int(random(titles.length)); // Pick random index.
      if (currentSongIndex != prevIdx) break; // Ensure it's different.
    }
  } else { // If not shuffle,
    currentSongIndex++; // Go to next song.
    if (currentSongIndex >= titles.length) currentSongIndex = 0; // Loop to first if at end.
  }
  loadCurrentSong(); // Load the new song.
  song.play(); // Start playing new song.
  isPlaying = true; // Set playing state to true.
} // End of autoNextSong().

void stop() { // Called when sketch exits.
  if (song != null) { // If song exists,
    song.close(); // Close current song.
  }
  minim.stop(); // Stop Minim library.
  super.stop(); // Call superclass stop.
} // End of stop().
