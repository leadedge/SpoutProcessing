//
//            SpoutSender
//
//      Send to a Spout receiver
//
//           spout.zeal.co
//
//      Based on a Processing example sketch by by Dave Bollinger
//      http://processing.org/examples/texturecube.html
//

// IMPORT THE SPOUT LIBRARY
import spout.*;

PImage img; // image to use for the rotating cube demo
PGraphics pgr; // Graphics for demo

// DECLARE A SPOUT OBJECT
Spout spout;

void setup() {

  // Initial window size
  size(640, 360, P3D);
  pgr = createGraphics(640, 360, P3D);
  
  img = loadImage("SpoutLogoMarble3.bmp");
  textureMode(NORMAL);
    
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);
  
  // CREATE A SPOUT SENDER
  spout.createSender("Spout Processing", width, height);
  
} 

void draw()  { 

    background(0, 90, 100);
    noStroke();
    
    // OPTION 1: SEND THE TEXTURE OF THE DRAWING SURFACE
    pushMatrix();
    translate(width/2.0, height/2.0, -100);
    rotateX(frameCount * 0.01);
    rotateY(frameCount * 0.01);      
    scale(110);
    TexturedCube(img);
    popMatrix();
    spout.sendTexture(); // Sends at the size of the window

    
    /*
    // OPTION 2: SEND THE TEXTURE OF GRAPHICS
    pgr.beginDraw();
    pgr.lights();
    pgr.background(0, 90, 100);
    pgr.fill(255);
    pgr.textSize(16);
    pgr.text(frameCount, 92, 50);
    pushMatrix();
    pgr.translate(pgr.width/2, pgr.height/2);
    pgr.rotateX(frameCount/100.0);
    pgr.rotateY(frameCount/100.0);
    pgr.fill(192);
    pgr.box(pgr.width/4); // box is not textured
    popMatrix();
    pgr.endDraw();
    spout.sendTexture(pgr); // Sends at the size of the graphics
    image(pgr, 0, 0, width, height); // Fit to the window
    */
    
    /*
    // OPTION 3: SEND THE TEXTURE OF AN IMAGE
    spout.sendTexture(img); // Sends at the size of the image
    image(img, 0, 0, width, height); // Fit to the window
    */
    
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