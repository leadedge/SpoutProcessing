//
//            SpoutReceiver
//
//      Receive from a Spout sender
//            Spout 2.007
//       https://spout.zeal.co
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

// The first time that receiveTexure of receiveImage are called, 
// the PGraphics or PImage objects are initialized with the size
// of the sender that the receiver connects to. Thereafter, the
// dimensions are changed to match the sender.
PImage img; // Image to receive a texture
PGraphics pgr; // Canvas to receive a texture

// DECLARE A SPOUT OBJECT
Spout spout;

void setup() {
  
  // Initial window size
  size(640, 360, P3D);
  
  // Screen text size
  textSize(18);

  // Needed for resizing the window to the sender size
  // Processing 3+ only
  surface.setResizable(true);
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

  // OPTION : Specify a sender to connect to.
  // The active sender will be detected by default,
  // but you can specify the name of the sender to receive from.
  // The receiver will then attempt to connect to that sender
  // spout.setReceiverName("Spout Demo Sender");
  
} 


void draw() {
  
    //  
    // RECEIVE FROM A SENDER
    //
      
    // OPTION 1: Receive and draw the texture
    if(spout.receiveTexture())
        spout.drawTexture();
    
    // OPTION 2: Receive into PGraphics
    // pgr = spout.receiveTexture(pgr);
    // if(pgr != null) {
      // image(pgr, 0, 0, width, height);
      // showInfo();
    // }
    
    // OPTION 3: Receive into PImage texture
    // img = spout.receiveTexture(img);
    // if(img != null)
      // image(img, 0, 0, width, height);
      
    // OPTION 4: Receive into PImage pixels
    // Note that receiving pixels is slower than receiving
    // a texture alone and depends on the sender size.
    // img = spout.receiveImage(img);
    // if(img.loaded)
      // image(img, 0, 0, width, height);
    
    // Option: resize the window to match the sender
    // spout.resizeFrame();
    
    // Display sender info
    showInfo();
    
}

void showInfo() {
  
    fill(255);
  
    if(spout.isReceiverConnected()) {
      
        text("Receiving from : " + spout.getSenderName() + "  (" 
             + spout.getSenderWidth() + "x" 
             + spout.getSenderHeight() + " - "
             + spout.getSenderFormatName() + ")", 15, 30);
      
        // Report sender fps and frame number if the option is activated
        // Applications < Spout 2.007 will have no frame information
        if(spout.getSenderFrame() > 0) {
          text("fps  " + spout.getSenderFps() + "  :  frame "
               + spout.getSenderFrame(), 15, 50);
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
    // SpoutSettings must have been run at least once
    // to establish the location of "SpoutPanel"
    spout.selectSender();
  }
}
      
