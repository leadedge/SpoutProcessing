//
//                MultipleSpoutReceivers
//
//        Receive from as multiple Spout senders
//      Use with the "MultipleSpoutSenders" sketch
//                   Spout 2.007
//              https://spout.zeal.co
//
//        Based on a Processing Syphon example
//        https://github.com/Syphon/Processing
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

int nReceivers = 4;
PGraphics[] canvas;
Spout[] receivers;


void setup() {
  
  size(1280, 720, P3D);
  
  // Screen text size
  textSize(16);
  
  // Create the multiple receiving PGraphics objects
  // Each PGraphics object is initialized with the size
  // of the sender that the receiver connects to.
  // Thereafter, the dimensions are changed to match the sender.
  canvas = new PGraphics[nReceivers];

  // Create Spout receivers to receive the frames.
  receivers = new Spout[nReceivers];
  for (int i = 0; i < nReceivers; i++) { 
    receivers[i] = new Spout(this);
    //
    // If sender names are set up here and receivers
    // initialized for those names, the receivers will
    // only connect to those senders initially.
    // (see MultipleSpoutSenders.pde).
    //
    // If this is not done here, the receivers are initialized
    // in when ReceiveTexture finds a sender. 
    //
    // Thereafter, in both cases, the user can select any ender.
    // (see mousePressed).
    String sendername = "Processing Spout"+i;
    receivers[i].setReceiverName(sendername);
    //
  }
  
}

void draw() {
  
  for (int i = 0; i < nReceivers; i++) {
    // receiveTexture will detect a sender if the
    // receiver for that quadrant is not initialized
    // for a particular sender name.
    canvas[i] = receivers[i].receiveTexture(canvas[i]);
    if(canvas[i] != null && canvas[i].loaded) {
      // Draw for successful receive
      // The canvas object may have been re-sized if
      // a different sender is selected for that cell
      image(canvas[i], 640*(i%2), 360*(i/2), 640, 360);
    }
  }
    
  
  /*
  for (int i = 0; i < nReceivers; i++) {
      // receiveTexture will detect a sender if the
      // receiver for that quadrant is not initialized
      // for a particular sender name.
      canvas[i] = receivers[i].receiveTexture(canvas[i]);
      if(canvas[i].loaded) {
        // Draw for successful receive
        // The canvas object may have been re-sized if
        // a different sender is selected for that cell
        image(canvas[i], 640*(i%2), 360*(i/2), 640, 360);
        String senderName = receivers[i].getSenderName();
        if(senderName.length() > 0) {
           // Report sender fps and frame number if the option is activated
           // Applications < Spout 2.007 will have no frame information
           if(receivers[i].getSenderFrame() > 0) {
             text("Receiving from : " + senderName + "  (" 
                 + receivers[i].getSenderWidth() + "x" 
                 + receivers[i].getSenderHeight() + ") - fps "
                 + receivers[i].getSenderFps() + " : frame "
                 + receivers[i].getSenderFrame(), 640*(i%2)+15, 360*(i/2)+30);
           }
           else {
              text("Receiving from : " + senderName + "  (" 
                 + receivers[i].getSenderWidth() + "x" 
                 + receivers[i].getSenderHeight() + ")", 640*(i%2)+15, 360*(i/2)+30);
          }
        }
      }
   }
   */
   
}

// SELECT A SPOUT SENDER
// RH click on the quadrant to select a sender.
// SpoutSettings must have been run at least once
// to establish the location of "SpoutPanel".
void mousePressed() {
  if (mouseButton == RIGHT) {
    // Where are we
    int i = (int)(floor(2*mouseX/(float)width)+floor(2*mouseY/(float)height)*2);
    receivers[i].selectSender(); // change that quadrant
  }
}
      
