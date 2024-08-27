//
//            SpoutSender
//
//      Send to a Spout receiver
//            Spout 2.007
//       https://spout.zeal.co
//
//      Texture Cube by Dave Bollinger
//      http://processing.org/examples/texturecube.html
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

PImage img; // image to use for the rotating cube
PGraphics pgr; // Graphics for demo

// DECLARE A SPOUT OBJECT
Spout spout;

void setup() {
  
  // Initial window size
  size(640, 360, P3D);
  textureMode(NORMAL);
   
  textSize(18);
  pgr = createGraphics(1280, 720, P3D);
  img = loadImage("data/SpoutLogoMarble3.jpg");
  spout = new Spout(this);
  spout.setSenderName("Spout Sender");
    
  //
  // Option - logging
  //
  // Enable Spout logging to detect warnings and errors.
  //
  // Note that the logs will show up in the sketch console
  // window only after the sketch is closed and not while
  // the sketch is running.
  //
  // spout.enableSpoutLog();
  //
  // Set the level above which the logs are shown
  // 0 : SPOUT_LOG_SILENT
  // 1 : SPOUT_LOG_VERBOSE
  // 2 : SPOUT_LOG_NOTICE (default)
  // 3 : SPOUT_LOG_WARNING 
  // 4 : SPOUT_LOG_ERROR
  // 5 : SPOUT_LOG_FATAL
  //
  // For example, to show only warnings and errors (you shouldn't see any)
  //     spout.setLogLevel(3);
  // or leave set to Notice (level 2) to see more information.
  //
  // Default output is the sketch console and you 
  // will see the log when the sketch closes.
  // But you can also specify output to a text file
  // with the extension of your choice
  // spout.enableSpoutLogFile("Spout Processing Sender.log");
  //
  // The log file is re-created every time the application starts
  // unless you specify to append to the existing one :
  //     spout.enableSpoutLogFile("Spout Processing Sender.log", true);
  //
  // The file is saved in the %AppData% folder 
  //     C:>Users>username>AppData>Roaming>Spout
  // unless you specify the full path.
  // After the application has run you can find and examine the log file
  //
  // You can also create your own logs
  //     spout.spoutLog("SpoutLog test");
  // Or specify the logging level :
  //     spout.spoutLogNotice("Notice");
  // or :
  //     spout.spoutLogFatal("This should not happen");
  // or :
  //     spout.setLogLevel(1);
  //     spout.spoutLogVerbose("Message");
  //
  
  // Option - set the sketch frame rate.
  // Receivers 2.007 or higher will detect this rate
  // frameRate(30);
  
  // Refer to the "SpoutUtils" example for details
  // of logging and messagebox utility functions
  
} // end setup 

void draw()  { 

    background(0, 90, 100);
    noStroke();

    // Draw the rotating cube
    pushMatrix();
    translate(width/2.0, height/2.0, -100);
    rotateX(frameCount/100.0);
    rotateY(frameCount/100.0);      
    scale(110);
    TexturedCube(img);
    popMatrix();
    
    background(0, 90, 100);
    noStroke();

    // OPTION 1: SEND THE TEXTURE OF THE DRAWING SURFACE
    // Draw the rotating cube
    pushMatrix();
    translate(width/2.0, height/2.0, -100);
    rotateX(frameCount/100.0);
    rotateY(frameCount/100.0);      
    scale(110);
    TexturedCube(img);
    popMatrix();
    // Send at the size of the window    
    spout.sendTexture();
    
    /*
    // OPTION 2: SEND THE TEXTURE OF GRAPHICS
    pgr.beginDraw();
    pgr.lights();
    pgr.background(0, 90, 100);
    pgr.fill(255);
    pushMatrix();
    pgr.translate(pgr.width/2, pgr.height/2);
    pgr.rotateX(frameCount/60.0);
    pgr.rotateY(frameCount/60.0);
    pgr.fill(192);
    pgr.box(pgr.width/4); // box is not textured
    popMatrix();
    pgr.endDraw();
    image(pgr, 0, 0, width, height);
    // Send at the size of the graphics
    spout.sendTexture(pgr);
    */
    
    /*
    // OPTION 3: SEND THE TEXTURE OF AN IMAGE
    image(img, 0, 0, width, height);
    // Send at the size of the image
    spout.sendTexture(img);
    */
  
    // Display info
    text("Sending as : "
      + spout.getSenderName() + " ("
      + spout.getSenderWidth() + "x"
      + spout.getSenderHeight() + ")", 15, 30);
    if(spout.getSenderFrame() > 0) {
      text("fps " + spout.getSenderFps() + "  :  frame "
        + spout.getSenderFrame(), 15, 50);
    }
    text("'n' - change sender name", 15, height-10); 
   
}

void keyReleased()
{
  if(key == 'n') {
    String name = spout.spoutEditBox("Enter a new sender name");
    if(name != null) {
      spout.closeSender();
      spout.setSenderName(name);
    }
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
