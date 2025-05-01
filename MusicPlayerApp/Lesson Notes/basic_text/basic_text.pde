// Text: Static
String title = "YEET";

// Display
size(700, 500);
int appWidth = width;
int appHeight = height;

// Font Setup
float fontSize = 48; // Bigger for that bold Impact look
PFont titleFont = createFont("Impact", fontSize);

// Text Box Position
float titleX = appWidth * 0.25;
float titleY = appHeight * 0.25;
float titleWidth = appWidth * 0.5;
float titleHeight = appHeight * 0.1;

// Draw Box (with gray fill)
fill(220); // Light gray
stroke(0); // Black border
rect(titleX, titleY, titleWidth, titleHeight);

// Draw Text
fill(#2C08FF); // Purple ink
textAlign(CENTER, CENTER);
textFont(titleFont, fontSize);
text(title, titleX + titleWidth / 2, titleY + titleHeight / 2);
