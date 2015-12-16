//
//
//                  Spout.pde
//
//    Adds support to the basic functions of the Spout library.
//
//    07.05.14 - updated for screen resize with sender change
//             - updated Jspout ReadTexture as well
//    06.08-14 - updated for Spout SDK
//    05.09.14 - update with revised SDK
//    12.10.14 - recompiled for release
//    04.02.15 - receiver screen resize in sketch instead of in this class
//    29.06.15 - added SpoutControls
//    22.07.15 - included "CreateControl" for SpoutControls
//    12.10.15 - change Jspout dll function names :
//               InitReciever > CreateReceiver
//               InitSender > CreateSender
//               WriteTexture > SendTexture
//               ReadTexture > ReceiveImage
//             - added GetMemoryShareMode
//             - revise this class code for Spout 2.005
//    14.10.15 - change ReceiveTexture to "ReceiveGraphics" and
//             - transfer directly to the graphics or image texture
//             - Manage frame window resizing within this class
//    15.10.15 - updated for Spout 2.005
//    26.10.15 - Added SendTexture for PGraphics and PImage
//             - Added user setting for texture inversion 
//    27.10.15 - updated for Processing 3
//    10.11.15 - added shared memory functions
//    17.11.15 - revised to use Spout Library
//    18.11.15 - added CheckReceiver for ReceiveTexture/DrawSharedTexture
//    15.12.15 - change all function names to start with lower case
//    16.12.15 - Reorganise and cleanup
//

import processing.opengl.*;
import co.zeal.spout.*;

class Spout
{
  
  PGraphicsOpenGL pgl;
  String senderName; // the sender name
  int[] dim = new int[2]; // Sender dimensions
  boolean bInitialized; // initialization flag
  int invertMode; // User setting for texture invert
  
  Spout () {

    pgl = (PGraphicsOpenGL) g;
    dim[0] = 0; // Sender width
    dim[1] = 0; // Sender height
    bInitialized = false;
    senderName = "";
    invertMode = -1; // User has not set any mode - use ction defaults
    
  }  
  
  // =========================================== //
  //                   SENDER                    //
  // =========================================== //

  //
  // Initialize a sender 
  //
  
  // For texture sharing, the name provided 
  // is registered in the list of senders
  // Texture share initialization only succeeds if 
  // the graphic hardware is compatible, otherwise
  // it defaults to memoryshare mode
  boolean createSender(String name, int Width, int Height) {
    bInitialized = JSpout.createSender(name, Width, Height);
    senderName = name;
    spoutReport(bInitialized); // console report
    return bInitialized;
  }


  void closeSender() {
    if(JSpout.releaseSender())
      println("Sender closed");
    else
      println("No sender to close");
  } 
  
  
   
  // Write the sketch drawing surface texture to 
  // an opengl/directx shared texture
  void sendTexture() {
    
      if(!bInitialized) return;
      
      // Set the invert flag to the user setting if it has been selected
      // Processing Y axis is inverted with respect to OpenGL
      // so we need to invert the texture for this function
      boolean bInvert = true; 
      if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);
      
      pgl.beginPGL();
      // Load the current contents of the renderer's
      // drawing surface into its texture.
      pgl.loadTexture();
      // getTexture returns the texture associated with the
      // renderer's drawing surface, making sure is updated 
      // to reflect the current contents off the screen 
      // (or offscreen drawing surface).      
      Texture tex = pgl.getTexture();
      JSpout.sendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert);
      pgl.endPGL();
  }
  
  
  // Write the texture of a graphics object
  void sendTexture(PGraphics pgr)
  {
    if(!bInitialized) return;
    boolean bInvert = true;
    if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);
    Texture tex = pgl.getTexture(pgr);
    JSpout.sendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert);
  }
  
  
  // Write the texture of an image object
  void sendTexture(PImage img)
  {
    if(!bInitialized) return;
    boolean bInvert = false; // default for this function
    if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);
    Texture tex = pgl.getTexture(img);
    JSpout.sendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert);
  }
   
  //  
  // SPOUTCONTROLS
  //
  
  boolean createSpoutControl(String name, String type) {
    return(JSpout.createControl(name, type, 0, 1, 1, ""));
  }
  
  boolean createSpoutControl(String name, String type, float value) {
    return(JSpout.createControl(name, type, 0, 1, value, ""));
  }

  boolean createSpoutControl(String name, String type, String text) {
    return(JSpout.createControl(name, type, 0, 1, 1, text));
  }

  boolean createSpoutControl(String name, String type, float minimum, float maximum, float value) {
    return(JSpout.createControl(name, type, minimum, maximum, value, ""));
  }
  
  boolean openSpoutControls(String name) {
    return(JSpout.openControls(name));
  }
  
   int checkSpoutControls(String[] controlName, int[] controlType, float[] controlValue, String[] controlText ) {
    return JSpout.checkControls(controlName, controlType, controlValue, controlText);
  }
   
  boolean closeSpoutControls() {
    return(JSpout.closeControls());
  }
  
  //
  //  SHARED MEMORY
  //
  
  boolean createSenderMemory(String name, int Width, int Height) 
  {
    return (JSpout.createSenderMemory(name, Width, Height));
  }
 
  boolean updateSenderMemorySize(String name, int Width, int Height) 
  {
    return (JSpout.updateSenderMemorySize(name, Width, Height));
  }
  
  boolean writeSenderString(String sValue) 
  {
    return (JSpout.writeSenderString(sValue));
  }
  
  void closeSenderMemory() 
  {
    JSpout.closeSenderMemory();
  }
  
  long lockSenderMemory() 
  {
    return JSpout.lockSenderMemory();
  }
    
  void unlockSenderMemory() 
  {
    JSpout.unlockSenderMemory();
  }
    
  
  // =========================================== //
  //                   RECEIVER                  //
  // =========================================== //

  //
  // Initialize a Receiver 
  //
  // The name provided is searched in the list of senders
  // and used if it is there. If not, the receiver will 
  // connect to the active sender selected by the user
  // or, if no sender has been selected, this will be
  // the first in the list if any are running.
  //
  boolean createReceiver(String name) {
    
    // Image size values passed in are modified and passed back
    // as the size of the sender that the receiver connects to.
    // Then the screen has to be reset. The same happens when 
    // receiving a texture if the sender or image size changes.
    dim[0] = width;
    dim[1] = height;
    String newname;
    
    if(JSpout.createReceiver(name, dim)) {
      // Initialization succeeded and there was a sender running
      newname = JSpout.getSenderName();
      // dim will be returned with ths size of the sender it connected to
      if(newname != null && newname.length() > 0 && !newname.equals(senderName)) {
        senderName = newname;
        println("Found sender : " + senderName + " (" + dim[0] + "x" + dim[1] + ")" );
        if(!bInitialized) {
            bInitialized = true;
            spoutReport(bInitialized);
        }
      }
    }
    else {
      bInitialized = false;
      return false;
    }
    
    return true;
    
  } // end Receiver initialization
    

  void closeReceiver() {
    if(JSpout.releaseReceiver())
      println("Receiver closed");
    else
      println("No receiver to close");
  } 


  // Receive and draw the sender texture directly
  // Uses CheckReceiver to test for sender changes
  boolean receiveTexture()
  {
      // If no sender, keep looking
      if(!spout.bInitialized) {
        spout.createReceiver("");
        return false;
      }
      
      boolean bInvert = true;
      if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);
      
      // Check the receiver for user selection
      // No dimensions need to be updated
      if(checkReceiver()) {
          // Then draw the shared texture
          return JSpout.drawTexture(bInvert);
      }
      
      return false;
      
  } // end receiveTexture
 
 
 
  // Receive into graphics
  // Sender changes are detected in JSpout.ReceiveTexture
  // and returned. The PGraphics is resized the next time.
  PGraphics receiveTexture(PGraphics pg)
  {
    
    // If no sender, keep looking
    if(!spout.bInitialized) {
      spout.createReceiver("");
      return pg;
    }
    
    boolean bInvert = true; // default for this function
    if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);
   
    // Adjust the graphics to the current sender size
    if(dim[0] != pg.width || dim[1] != pg.height && dim[0] > 0 && dim[1] > 0) {
       pg = createGraphics(dim[0], dim[1], PConstants.P2D);
    }
    else {    
      // Sender dimensions (dim) are sent as well as returned
      // The graphics size is adjusted next time round
      Texture tex = pgl.getTexture(pg);
      JSpout.receiveTexture(dim, tex.glName, tex.glTarget, bInvert);
    }
     
    return pg;    
  }
  
  
  // Receive into an image
  PImage receiveTexture(PImage img) {
 
    // If no sender, keep looking
    if(!spout.bInitialized) {
      spout.createReceiver("");
      return img;
    }
    
    boolean bInvert = false; // default for this function
    if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);

    if(dim[0] != img.width || dim[1] != img.height && dim[0] > 0 && dim[1] > 0) {
      img.resize(dim[0], dim[1]);
    }
    else {
      Texture tex = pgl.getTexture(img);
      JSpout.receiveTexture(dim, tex.glName, tex.glTarget, bInvert);
    }    
    
    return img;
  }
  
  // Pop up SpoutPanel to select a sender
  // If the user selected a different one, attach to it.
  void selectSender()
  {
    if(JSpout.senderDialog()) {
      if(!bInitialized)
        createReceiver("");
      else
        checkReceiver();
    }
  }
  
  
  
  // =========================================== //
  //                   UTILITY                   //
  // =========================================== //
  
  // User option to set texture inversion for send and receive
  void setInvert(boolean bInvert)
  {
    // invertMode is -1 unless the user specifically selects it
    if(bInvert)
      invertMode = 1;
    else
      invertMode = 0;
  }
  
  
  void resizeFrame()
  {
    if(!bInitialized) return;
    if(width != dim[0] || height != dim[1]  && dim[0] > 0 && dim[1] > 0) {
      // Only for Processing 3
      surface.setSize(dim[0], dim[1]);
    }
  }
  
  
  // =========================================== //
  //                 LOCAL FUNCTIONS             //
  // =========================================== //
  
  //
  // Check the receiver for any sender changes
  //
  // This is normally done within JSpout.ReceiveTexture
  // But is necessary if DrawSharedTexture is used instead.
  // Returns a different name or dimensions if the sender has changed.
  // The name is returned empty if the sender has closed.
  //
  boolean checkReceiver() {
    
      String newname;
      int[] newdim = new int[2];
      
      newdim[0] = dim[0];
      newdim[1] = dim[1];
      newname = JSpout.checkReceiver(senderName, newdim);
      // Check for changes if the sender has not closed
      if(newname != null  && newname.length() > 0 ) { 
        // the sender is there but could have changed
        if(!newname.equals(senderName) || newdim[0] != dim[0] || newdim[1] != dim[1]) {
            // Update the class dimensions and sender name
            dim[0] = newdim[0];
            dim[1] = newdim[1];
            senderName = newname;
            println("Found sender : " + senderName + " (" + dim[0] + "x" + dim[1] + ")" );
        }
        // The sender has not changed
        return true;
      }
      else { // the sender has closed
          println("Sender closed");
          senderName = "";
          bInitialized = false;
      }
      
      return false;
   
  } // end checkReceiver
  
  
  
  void spoutReport(boolean bInit)
  {
    boolean bMemoryMode;
    if(bInit) {
      bMemoryMode = JSpout.getMemoryShareMode();
      if(bMemoryMode)
        println("Spout initialized memory sharing");
      else
        println("Spout initialized texture sharing");
    }
    else {
      println("Spout intialization failed");
    }
  }
   
} // end class Spout

 