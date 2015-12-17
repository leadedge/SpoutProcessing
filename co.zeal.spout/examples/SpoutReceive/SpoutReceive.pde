
//
//             SpoutReceiver
//
//       Receive from a Spout sender
//
//             spout.zeal.co
//

// import the spout library
import co.zeal.spout.*;

PGraphics pgr; // Canvas to receive a texture
PImage img; // Image to receive a texture

// DECLARE A SPOUTReceiver OBJECT HERE
SpoutReceiver spoutR;

void setup() {
  
  // Initial window size
  size(640, 360, P3D);
  
  // Needed for resizing the window to the sender size
  surface.setResizable(true);
   
  // Create a canvas or an image to receive the data.
  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // CREATE A NEW SPOUT OBJECT HERE AND
  // INITIALIZE A SPOUT RECEIVER HERE
  // Give it the name of the sender you want to connect to
  // Otherwise it will connect to the active sender
  spoutR = new SpoutReceiver(this, "");
 
} 

void draw() {
  
    background(0);
  
    //
    // RECEIVE A SHARED TEXTURE HERE
    //
    
    // OPTION 1: Receive and draw the received texture
    spoutR.receiveTexture(); // Fills the window

    // OPTION 2: Receive into PGraphics
    // pgr = spout.receiveTexture(pgr);
    // image(pgr, 0, 0, width, height);

    // OPTION 3: Receive into PImage
    // img = spout.receiveTexture(img);
    // image(img, 0, 0, width, height);
   
    // Optionally resize the window to match the sender
    // spoutR.resizeFrame();
}


// RH click to select a sender
void mousePressed() {
  // SELECT A SPOUT SENDER HERE
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender.
    spoutR.selectSender();
  }
}
      