import ddf.minim.*;

Minim minim;
AudioPlayer song;
PImage albumImage;

boolean isPlaying = false;

void setup() {
  // Switch to fullscreen mode
  fullScreen();
  
  minim = new Minim(this);
  
  // Load the image and sound
  albumImage = loadImage("assets/images/ME-JU.jpg");
  song = minim.loadFile("assets/audio/USO.mp3");

  // Setup fonts
  textFont(createFont("Arial", 30));
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);

  // Rectangle with title at the top center
  fill(0, 102, 204); // BlueInk color
  rectMode(CENTER);
  rect(width / 2, height / 10, 600, 60); // Title rectangle
  fill(255);
  textSize(30);
  text("YEET music", width / 2, height / 10);

  // Album image square below the title (not that giant but big)
  imageMode(CENTER);
  image(albumImage, width / 2, height / 3, 300, 300); // Adjusted size to fit better

  // Play/Pause and Stop buttons below the album
  float buttonY = height / 1.8;  // Adjusted Y position for buttons
  drawButton(width / 2 - 150, buttonY, "Play/Pause", isPlaying ? "Pause" : "Play");
  drawButton(width / 2 + 150, buttonY, "Stop", "Stop");

  // Progress bar below the buttons
  drawProgressBar();
}

void drawButton(float x, float y, String label, String buttonText) {
  fill(0, 102, 204);
  rect(x - 50, y - 25, 100, 50); // Button rectangle
  fill(255);
  textSize(20);
  text(buttonText, x, y);
}

void drawProgressBar() {
  float progressWidth = map(song.position(), 0, song.length(), 0, 600);
  
  // Draw the progress bar
  fill(0, 102, 204);
  rect(width / 2 - 300, height / 1.4, 600, 20);
  
  // Show progress as filled bar
  fill(255);
  rect(width / 2 - 300, height / 1.4, progressWidth, 20);

  // Time display (00:00/total)
  String time = nf(song.position() / 60000, 2) + ":" + nf((song.position() % 60000) / 1000, 2) + "/" + 
                nf(song.length() / 60000, 2) + ":" + nf((song.length() % 60000) / 1000, 2);
  textSize(18);
  text(time, width / 2, height / 1.3);
}

void mousePressed() {
  // Check if Play/Pause button is clicked
  if (dist(mouseX, mouseY, width / 2 - 150, height / 1.8) < 50) {
    if (isPlaying) {
      song.pause();
    } else {
      song.play();
    }
    isPlaying = !isPlaying;
  }
  
  // Check if Stop button is clicked
  if (dist(mouseX, mouseY, width / 2 + 150, height / 1.8) < 50) {
    song.close();
    song.play();
    isPlaying = true;
  }
}
