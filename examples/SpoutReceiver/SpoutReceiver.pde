//
//            SpoutReceiver
//
//      Receive from a Spout sender
//            Spout 2.007
//       https://spout.zeal.co
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
  
  // Screen text size
  textSize(16);

  // Needed for resizing the window to the sender size
  // Processing 3+ only
  surface.setResizable(true);
  
  // Create a canvas or an image to receive the data.
  // Objects can be created at any size.
  // Their dimensions are changed to match the sender
  // that the receiver connects to.  
  pgr = createGraphics(width, height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

  // OPTION : Specify a sender to connect to.
  // The active sender will be detected by default,
  // but you can specify the name of the sender to receive from.
  // The receiver will then attempt to connect to that sender
  // spout.setReceiverName("Spout Demo Sender");
  
} 


void draw() {
  
    background(0);
    
    // RECEIVE FROM A SENDER
    
    // OPTION 1: Receive and draw the shared texture
    if(spout.receiveTexture())
        spout.drawTexture();
     
    // OPTION 2: Receive into PGraphics
    // pgr = spout.receiveTexture(pgr);
    // if(pgr.loaded)
    //  image(pgr, 0, 0, width, height);

    // OPTION 3: Receive into PImage
    // spout.receiveTexture(img);
    // img = spout.receiveTexture(img);
    // if(img.loaded)
    //    image(img, 0, 0, width, height);
  
    // Option: resize the window to match the sender
    // spout.resizeFrame();
    
    // Display sender info
    showInfo();
    
}

void showInfo() {
  
    fill(255);

    if(spout.isReceiverConnected()) {
      // Report sender fps and frame number if the option is activated
      // Applications < Spout 2.007 will have no frame information
      if(spout.getSenderFrame() > 0) {
        text("Receiving from : " + spout.getSenderName() + "  (" 
             + spout.getSenderWidth() + "x" 
             + spout.getSenderHeight() + ") - fps "
             + spout.getSenderFps() + " : frame "
             + spout.getSenderFrame(), 15, 30);
      }
      else {
        text("Receiving from : " + spout.getSenderName() + "  (" 
             + spout.getSenderWidth() + "x" 
             + spout.getSenderHeight() + ")", 15, 30);
      }
    }
    else {
      text("No sender", 30, 30);
    }
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
      
