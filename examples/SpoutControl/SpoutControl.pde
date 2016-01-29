//
//            SpoutControl
//
//      Example of a controlled sender.
//
//      Based on a Processing example sketch by by Dave Bollinger
//      http://processing.org/examples/texturecube.html
//
//           spout.zeal.co
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

PImage img; // image to use for the rotating cube demo
PFont f; // font for control text

// DECLARE A SPOUT OBJECT
Spout spout;
String sendername;

// CONTROL ARRAYS
String[] controlName;
int[] controlType;
float[] controlValue;
String[] controlText;

// CONTROL VARIABLES
boolean bRotate = true;
float RotationSpeed = 1.0;
float RotX = 0;
float RotY = 0;
String UserText = "";

void setup() {

  // Initial window size
  size(640, 360, P3D);
  textureMode(NORMAL);

  img = loadImage("SpoutLogoMarble3.bmp");
  f = loadFont( "Verdana-48.vlw" );  
    
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);
  
  // CREATE A SPOUT SENDER
  // Use the same name as the sketch
  sendername = "SpoutControl";
  spout.createSender(sendername, width, height);
 
  // CREATE CONTROL ARRAYS
  controlName = new String[20];
  controlType = new int[20];
  controlValue = new float[20];
  controlText = new String[20];
  
  // CREATE CONTROLS TO BE USED
  spout.createSpoutControl("User text", "text"); UserText = "";
  spout.createSpoutControl("Rotate", "bool", 1); bRotate = true;
  spout.createSpoutControl("Speed", "float", 0, 4, 1); RotationSpeed = 1.0;
  
  // OPEN THE CONTROLS FOR THE CONTROLLER
  // Use the same name as the sketch
  // for multiple controlled senders
  spout.openSpoutControls(sendername);
  
} 

void draw()  { 
  
    // CHECK FOR UPDATED CONTROLS FROM THE CONTROLLER
    int nControls = spout.checkSpoutControls(controlName, controlType, controlValue, controlText);
    if(nControls > 0) {
      // For all controls
      for(int i = 0; i < nControls; i++) {
         // Check each control by name
        
         // "User text"
         if(controlName[i].equals("User text")) {
          if(controlText[i] != null && !controlText[i].isEmpty())
            UserText = controlText[i];
         }
         
         // "Speed"
         if(controlName[i].equals("Speed"))
             RotationSpeed = controlValue[i];
         
         // "Rotate"
         if(controlName[i].equals("Rotate"))
             bRotate = (boolean)(controlValue[i] == 1);

      }
    }
  
    // DRAW THE GRAPHICS
    background(0, 90, 100);
    noStroke();
    pushMatrix();
    translate(width/2.0, height/2.0, -100);
    // Use the rotation values updated by the controller
    rotateX(RotX); 
    rotateY(RotY);      
    scale(110);
    TexturedCube(img);
    popMatrix();
    
    // Text overlay
    textFont(f, 32);
    fill(255);
    // Must test both for null and empty here
    if(UserText != null && !UserText.isEmpty()) {
      text (UserText, 10, 40);
    }    
    
    // SEND THE TEXTURE OF THE DRAWING SURFACE
    spout.sendTexture(); // Sends at the size of the window
 
    // UPDATE LOCAL VARIABLES
    if(bRotate) {
      RotY += RotationSpeed * 0.01;
      RotX += RotationSpeed * 0.01;
    }
     
}


void TexturedCube(PImage tex) {
  
  beginShape(QUADS);
  texture(tex);

  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
}

// OPEN THE SPOUT CONTROLLER
// SpoutControls installation required
// Not necessary for the SpoutController Freeframe dll
// RH click to open the stand-alone controller
// RH click again to hide/show the controller
// The controller is closed when the sketch is 
// stopped or closed
void mousePressed() {
  if (mouseButton == RIGHT) {
    if(!spout.openController()) {
      println("SpoutControls not installed");
    }
     
  }
}