//
//              MultipleSpoutSenders
//
//          Send as multiple Spout senders
//     Use with the "MultipleSpoutReceivers" sketch
//                   Spout 2.007
//              https://spout.zeal.co
//
//        Based on a Processing Syphon example
//        https://github.com/Syphon/Processing
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

int nSenders = 4;
PGraphics[] canvas;
Spout[] senders;
color[] colors;


void setup() {
  
  size(1280, 720, P3D);
  
  // Create graphics objects for the senders
  canvas = new PGraphics[nSenders];
  for (int i = 0; i < nSenders; i++) {
    canvas[i] = createGraphics(640, 360, P3D);
  }
  
  colors = new color[4];
  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 255, 0);
  colors[2] = color(0, 0, 255);
  colors[3] = color(255, 0, 255);

  // Create Spout senders to send frames out.
  senders = new Spout[nSenders];
  for (int i = 0; i < nSenders; i++) { 
    senders[i] = new Spout(this);
    String sendername = "Processing Spout"+i;
    senders[i].setSenderName(sendername);
  }
  
}

void draw() {
  for (int i = 0; i < nSenders; i++) {
    canvas[i].beginDraw();
    canvas[i].background(colors[i]);
    canvas[i].lights();
    canvas[i].translate(canvas[i].width/2, canvas[i].height/2);
    canvas[i].rotateX(frameCount * 0.01);
    canvas[i].rotateY(frameCount * 0.01);  
    canvas[i].box(150);
    canvas[i].endDraw();
    senders[i].sendTexture(canvas[i]);    
    image(canvas[i], 640 * (i % 2), 360 * (i / 2));
  }
}
