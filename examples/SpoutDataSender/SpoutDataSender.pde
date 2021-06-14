//
//            Spout Data Sender
//
//      Send data together with a texture to a Spout receiver
//
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

// VARIABLES FOR DATA EXCHANGE
int pressed = 0;
int dragged = 0;
XML xml, mx, my, butn, press, drag;


void setup() {

  // Initial window size
  size(640, 360, P3D);
  textureMode(NORMAL);
  
  // Screen text size
  textSize(16);
  
  // Create a graphics object
  pgr = createGraphics(1280, 720, P3D);
  
  // Load an image
  img = loadImage("SpoutLogoMarble3.bmp");
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);
  
  // CREATE XML FOR THIS EXAMPLE
  xml = new XML("mouse");
  mx = xml.addChild("mousex");
  my = xml.addChild("mousey");
  butn = xml.addChild("button");
  press = xml.addChild("pressed");
  drag = xml.addChild("dragged");
  
  // GIVE THE SENDER A NAME
  // A sender can be given any name.
  // Otherwise the sketch folder name is used
  // the first time "sendTexture" is called.  
  spout.setSenderName("Spout Data Sender");
  
  // CREATE SHARED MEMORY FOR DATA EXCHANGE
  // A sender name must be established first.
  //
  // The memory is created large enough to contain at least the maximum
  // number of bytes required.
  //
  // For example, the xml method shown below requires between 110 and 115
  // bytes, so the memory should be created at least 115 bytes in size. 
  //
  // If the sending data size is not precisely known, the shared memory can be 
  // created larger. For example, a 256 byte buffer is plenty for this example.
  //
  spout.createSenderBuffer(256);  
  
  // OPTION - set the sketch frame rate.
  // In this example, the sender waits for a ready signal from
  // the receiver and will synchronise with receiver framerate
  // (Refer to the SpoutDataReceiver example)
  // frameRate(60);
  
} 

void draw()  { 

    background(0, 90, 100);
    noStroke();
    
    //
    // OPTION - frame synchronisation
    //
    // To avoid the receiver from missing frames, the sender can wait
    // until the receiver signals that it is ready to read more data.
    // Use a timeout greater than the expected delay. 
    //
    // Sync is necessary if the sending and receiving applications require
    // frame accuracy and missed frames are not acceptable. 
    //
    // The sender will then run at the same framerate as the receiver.
    // For example, if connected to the data receiver example, this will
    // be 30fps instead of the 60fps established in Setup().
    //
    // Sync is not required for this simple example but is included to
    // demonstrate the functions (Refer to the SpoutDataReceiver example).
    //
    spout.waitFrameSync(spout.getSenderName(), 67);    
    
    // Draw the rotating cube
    pushMatrix();
    translate(width/2.0, height/2.0, -100);
    rotateX(frameCount/60.0);
    rotateY(frameCount/60.0);      
    scale(110);
    TexturedCube(img);
    popMatrix();
    
    // Send the texture of the drawing sufrface
    spout.sendTexture();
        
    //
    // SEND DATA
    // Often known as "per-frame metadata".
    //
    // In this example, send mouse coordinates and button status.
    // The receiver should expect the same data format.
    // (Refer to the SpoutDataReceiver example).
    
    //
    // Method 1 (string)
    //
    
    // Here the coordinates are converted to a String.
    String senderdata = 
      str(mouseX)  + " " +
      str(mouseY)  + " " +
      str(mouseButton) + " " +
      str(pressed) + " " +
      str(dragged);
      
    // Write the string to shared memory.
    // The receiver can then split the string and convert back to integers.
    // (Refer to the SpoutDataReceiver example)
    spout.setSenderData(senderdata);
    
    // end string method
    
    /*
    //
    // Method 2 - XML
    // XML might be appropriate for some applications.
    //
    // In this example we create :
    //
    // <mouse>
    //    <mousex>000</mousex>
    //    <mousey>000</mousey>
    //    <button>00</button>
    //    <pressed>0</pressed>
    //    <dragged>0</dragged>
    // </mouse>
    //
    
    // Set the mouse data to xml
    mx.setContent(str(mouseX));
    my.setContent(str(mouseY));
    butn.setContent(str(mouseButton));
    press.setContent(str(pressed));
    drag.setContent(str(dragged));
    
    // Save the xml data as a string
    String senderdata = xml.toString();
    
    // Write the string data to shared memory.
    // The receiver can parse the xml data, expecting the format sent.
    spout.setSenderData(senderdata);
    
    // end xml method
    */
    
    //
    // These are just examples. There are sure to be other applications.
    //
     
    // Display info
    text("Sending as : "
      + spout.getSenderName() + " ("
      + spout.getSenderWidth() + "x"
      + spout.getSenderHeight() + ") - fps : "
      + spout.getSenderFps() + " : frame "
      + spout.getSenderFrame(), 15, 30);  
   
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

void mousePressed()
{
  pressed = 1;
  dragged = 0;
}

void mouseReleased()
{
  pressed = 0;
  dragged = 0;
}

void mouseMoved()
{
  pressed = 0;
  dragged = 0;
}

void mouseDragged()
{
  pressed = 1;
  dragged = 1;
}
