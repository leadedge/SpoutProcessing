//
//            SpoutDataReceiver
//
//      Receive texture and data from a Spout sender
//
//            Spout 2.007
//       https://spout.zeal.co
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

// The first time that receiveTexure is called, the PGraphics object is
// initialized with the size of the sender that the receiver connects to.
// Thereafter, the dimensions are changed to match the sender.
PGraphics pgr; // Canvas to receive a texture

// VARIABLES FOR DATA EXCHANGE
// (mouse coordinates and button status in this example)
int[] mousedata;
XML xml, mx, my, butn, press, drag;
// For line draw
ArrayList<PVector> senderpoints;
int sendermousex  = 0;
int sendermousey  = 0;
int senderbutton  = 0;
int senderpressed = 0;
int senderdragged = 0;
// String received
String senderdata; // = "";
      
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
  
  // A 5 integer array for received data
  mousedata = new int[5];
  
  // Sender points to draw
  senderpoints = new ArrayList<PVector>();
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);

  // Set the frame rate (30) lower that the SpoutDataSender sketch (60)
  // to demonstrate frame sync functions. The sender will synchronise
  // with the receiver at 30fps (see setFrameSync in draw).
  frameRate(30.0);
  
} 


void draw() {
  
    //
    // RECEIVE FROM A SENDER
    //
    
    // Receive and draw the shared texture
    if(spout.receiveTexture()) {
        
      spout.drawTexture();
     
      //
      // RECEIVE DATA
      //
      
      //
      // Method 1 (string)
      //
      // The content format is expected (Refer to the SpoutDataSender example).
      //
      senderdata = spout.getSenderData();
      
      // In this example, the received string contains
      // mouse coordinates and button status.
      if(senderdata.length() > 0) { 
          println(senderdata);
          // Convert the string to integers
          mousedata = int(split(senderdata, ' '));
          // And the integer array to variables for legibility
          if(mousedata.length >= 5) {
            sendermousex  = mousedata[0];
            sendermousey  = mousedata[1];
            senderbutton  = mousedata[2];
            senderpressed = mousedata[3];
            senderdragged = mousedata[4];
          }
      } // end string method
      
      /*
      //
      // Method 2 (xml)
      //
      // The received string is in XML format.
      //
      // In this example we will receive :
      // <mouse>
      //    <mousex>000</mousex>
      //    <mousey>000</mousey>
      //    <button>0</button>
      //    <pressed>00</pressed>
      //    <dragged>0</dragged>
      // </mouse>
      //
      String senderdata = spout.getSenderData();
      
      if(senderdata.length() > 0) {
        // Parse the mouse coords and button status
        xml = parseXML(senderdata);
        mx = xml.getChild("mousex");
        my = xml.getChild("mousey");
        butn  = xml.getChild("button");
        press = xml.getChild("pressed");
        drag  = xml.getChild("dragged");
    
        sendermousex  = mx.getIntContent(0);
        sendermousey  = my.getIntContent(0);
        senderbutton  = butn.getIntContent(0);
        senderpressed = press.getIntContent(0);
        senderdragged = drag.getIntContent(0);
      
      } // End xml method
      */
      
      //
      // Method 3 is your own and depends on what the sender produced.
      //
      
      
    } // endif received texture
    
    // Draw a circle at the sender mouse position.
    // Click and drag on the sender sketch window to draw a line.
    if(spout.isConnected() && senderdata.length() > 0) {
            
      // Accumulate a line if the sender mouse is dragged
      if (senderdragged == 1)
        senderpoints.add(new PVector(sendermousex, sendermousey));
        
      // Draw accumulated points in yellow
      if(senderpoints.size() > 1) {
        noFill();
        strokeWeight(2);
        stroke(255, 255, 0);
        beginShape();
        for (PVector p : senderpoints)
          curveVertex(p.x, p.y);
        endShape();
      }
      
      // Clear points on sender RH button click
      if (senderbutton == RIGHT && senderpoints.size() > 0) {
        for (int i = senderpoints.size() - 1; i >= 0; i--)
          senderpoints.remove(i);
      }

      // Draw a ball at the sender mouse position  
      noStroke(); // no outline
      if(senderpressed == 1 && senderbutton == LEFT)
        fill(255, 255, 0); // yellow if the sender mouse is pressed
      else
        fill(255, 0, 0); // default red
      circle(sendermousex, sendermousey, 24);
      
    }
   
    // Display sender info
    showInfo();
    
    // OPTION
    // To avoid missing frames, send a ready signal for the sender
    // to wait on. Sender framerate will synchronise with the receiver.
    // (Refer to the SpoutDataSender example).
    spout.setFrameSync(spout.getSenderName());   
    
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
          text("fps : " + spout.getSenderFps() + " : frame "
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
      
