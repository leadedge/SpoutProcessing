//
//                MultipleSpoutReceivers
//
//           Receive from multiple Spout senders
//       Use with the "MultipleSpoutSenders" sketch     
//
//                  spout.zeal.co
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
  size(640, 360, P3D);
  canvas = new PGraphics[nReceivers];
  for (int i = 0; i < nReceivers; i++) {
    canvas[i] = createGraphics(320, 180, P2D);
  }

  // Create Spout receivers to receive the frames.
  receivers = new Spout[nReceivers];
  for (int i = 0; i < nReceivers; i++) { 
    receivers[i] = new Spout(this);
    //
    // If sender names are set up here and receivers
    // initialized for those names, the receivers will
    // only connect to those senders 
    // (see MultipleSpoutSenders.pde).
    //
    // If the receivers ar not initialized here,
    // they will be in draw when ReceiveTexture
    // finds a sender. Thereafter they can connect
    // to any sender that the user selects
    // (see mousePressed).
    //
    // String sendername = "Processing Spout"+i;
    // receivers[i].createReceiver(sendername);
    //
  }
  
}

void draw() {
  for (int i = 0; i < nReceivers; i++) {
      // receiveTexture will detect a sender if the
      // receiver for that quadrant is not initialized
      // for a particular sender name.
      canvas[i] = receivers[i].receiveTexture(canvas[i]);
      // Draw - the canvas object may have been re-sized
      // If a different sender is selected for that cell
      image(canvas[i], 320*(i%2), 180*(i/2), 320, 180); 
    }
}

// SELECT A SPOUT SENDER
// RH click on the quadrant to change
// and bring up a dialog to select a sender.
// Spout installation required
void mousePressed() {
  if (mouseButton == RIGHT) {
    // Where are we
    int i = (int)(floor(2*mouseX/(float)width)+floor(2*mouseY/(float)height)*2);
    receivers[i].selectSender(); // change that quadrant
  }
}
      