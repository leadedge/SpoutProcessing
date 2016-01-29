//
//             SpoutReceiver
//
//       Receive from a Spout sender
//
//             spout.zeal.co
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

PGraphics pgr; // Canvas to receive a texture
PImage img; // Image to receive a texture

// DECLARE A SPOUT OBJECT
Spout spout;

void setup() {
  
  // Initial window size
  size(640, 360, P3D);
  
  // Needed for resizing the window to the sender size
  // Processing 3+
  surface.setResizable(true);
   
  // Create a canvas or an image to receive the data.
  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);
  
  // INITIALIZE A SPOUT RECEIVER
  // Give it the name of the sender you want to connect to
  // Otherwise it will connect to the active sender
  spout.createReceiver("");
 
} 

void draw() {
  
    background(0);
  
    //
    // RECEIVE A SHARED TEXTURE
    //
    
    // OPTION 1: Receive and draw the received texture
    spout.receiveTexture(); // Fills the window

    // OPTION 2: Receive into PGraphics
    // pgr = spout.receiveTexture(pgr);
    // image(pgr, 0, 0, width, height);

    // OPTION 3: Receive into PImage
    // img = spout.receiveTexture(img);
    // image(img, 0, 0, width, height);
   
    // Optionally resize the window to match the sender
    // spout.resizeFrame();
}


// RH click to select a sender
void mousePressed() {
  // SELECT A SPOUT SENDER
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender.
    // Spout installation required
    spout.selectSender();
  }
}
      