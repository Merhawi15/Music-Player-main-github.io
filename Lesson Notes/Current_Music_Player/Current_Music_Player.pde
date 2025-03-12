// Dynamic not static
//
//Library-Minim
//
//Global Variables
//
float X, Y, Width,Height;
float y ;
float topDisplayx, TopdisplayY, topDisplayWidth, topDisplayHeight;
void setup() {  
  X = 0;
  Y = 1;
 print(X + Y);
 
 fullScreen();  
 //' println(displayWidth, displayHeight);
 //println(displayWidth, displayHeight);
 int appWidth = displayWidth;
 int appHeight = displayHeight;
 X = appWidth *  0.40;
 Y = appHeight * 0.40;
 Width = appWidth * 0.40;
 Height = appHeight  * 0.40;  
 rect(X,Y, Width,Height);
 rect (topDisplayx, TopdisplayY, topDisplayWidth, topDisplayHeight);
 //
//

rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);
rect(X,Y, Width,Height);

}
void draw() {};
//
void mousePressed() {};
//
void keyPressed () {}
//
//END MAIN Program
