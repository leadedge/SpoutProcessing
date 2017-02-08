//
//             SpoutReceiver
//
//       Receive from a Spout sender
//
//             spout.zeal.co
//
//       http://spout.zeal.co/download-spout/
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
  // Processing 3+ only
  surface.setResizable(true);
   
  // Create a canvas or an image to receive the data.
  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // Graphics and image objects can be created
  // at any size, but their dimensions are changed
  // to match the sender that the receiver connects to.
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);
  
  // OPTION : CREATE A NAMED SPOUT RECEIVER
  //
  // By default, the active sender will be detected
  // when receiveTexture is called. But you can specify
  // the name of the sender to initially connect to.
  // spout.createReceiver("Spout DX11 Sender");
 
} 

void draw() {
  
    background(0);
  
    //
    // RECEIVE A SHARED TEXTURE
    //
    
    // OPTION 1: Receive and draw the texture
    spout.receiveTexture();

    // OPTION 2: Receive into PGraphics texture
    // pgr = spout.receiveTexture(pgr);
    // image(pgr, 0, 0, width, height);

    // OPTION 3: Receive into PImage texture
    // img = spout.receiveTexture(img);
    // image(img, 0, 0, width, height);
    
    // OPTION 4: Receive into PImage pixels
    // img = spout.receivePixels(img);
    // image(img, 0, 0, width, height);

    // Optionally resize the window to match the sender
    // spout.resizeFrame();
    
}


// SELECT A SPOUT SENDER
void mousePressed() {
  // RH click to select a sender
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender.
    // Spout installation required
    spout.selectSender();
  }
}
      