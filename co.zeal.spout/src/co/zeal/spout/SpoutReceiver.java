//
//    Class SpoutReceiver
//
//    Adds support to the basic functions of the 
//    "JSpout" class and JNI dll, defined in JSpout.java
//

package co.zeal.spout; // what here  - how to reference JSpout ?

import processing.core.*;
import processing.opengl.*;
import co.zeal.spout.JSpout;

@Deprecated
public class SpoutReceiver {

	// protected PApplet parent;
	private PApplet parent; 
	PGraphicsOpenGL pgl;
	String senderName;
	int[] dim = new int[2]; // Sender dimensions
	boolean bInitialized; // initialization flag
	int invertMode; // User setting for texture invert

	public SpoutReceiver(PApplet parent, String senderName) {
		this.parent = parent;
		pgl = (PGraphicsOpenGL) parent.g;
		dim[0] = 0; // Sender width
		dim[1] = 0; // Sender height
		bInitialized = false;
		senderName = "";
		invertMode = -1; // User has not set any mode - use function defaults
		
		createReceiver(senderName);
	}

	// TODO - dispose
	

	//
	// Initialize a Receiver 
	//
	// The name provided is searched in the list of senders and used if it is there.
	// If not, the receiver will connect to the active sender selected by the user or,
	// if no sender has been selected, this will be the first in the list of any running.
	//
	private boolean createReceiver(String name) {
	    
		// Image size values passed in are modified and passed back
		// as the size of the sender that the receiver connects to.
		// Then the screen has to be reset. The same happens when 
		// receiving a texture if the sender or image size changes.
		dim[0] = parent.width; // app screen width
		dim[1] = parent.height; // app screen height
		String newname;
	    
		if(JSpout.createReceiver(name, dim)) {
			bInitialized = true;
			// Initialization succeeded and there was a sender running
			newname = JSpout.getSenderName();
		    if(newname != null && newname.length() > 0 && !newname.equals(senderName)) {
		        senderName = newname;
		        System.out.println("Found sender : " + senderName + " " + dim[0] + "x" + dim[1]);
		        if(!bInitialized) {
		            bInitialized = true;
		            spoutReport(bInitialized);
		        }
		    }
		    else {
		    	bInitialized = false;
		    	return false;
		    }
	    }
	    
		return true;
	    
	} // end Receiver initialization
	    

	public void closeReceiver() {
		if(JSpout.releaseReceiver())
			System.out.println("Receiver closed");
		else
			System.out.println("No receiver to close");
	} 
	 
	 
	// Receive and draw the sender texture directly
	// Uses CheckReceiver to test for sender changes
	public boolean receiveTexture()
	{
		// If no sender, keep looking
		if(!bInitialized) {
			createReceiver("");
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
	public PGraphics receiveTexture(PGraphics pg)
	{
		// If no sender, keep looking
		if(!bInitialized) {
			createReceiver("");
			return pg;
		}
	    
		boolean bInvert = true; // default for this function
		if(invertMode >= 0) bInvert = (invertMode == 1);
	   
		// Adjust the graphics to the current sender size
		if(dim[0] != pg.width || dim[1] != pg.height && dim[0] > 0 && dim[1] > 0) {
			pg = parent.createGraphics(dim[0], dim[1], PConstants.P2D);
		}
		else {    
			// Sender dimensions (dim) are sent as well as returned
			// so the graphics size is adjusted next time round
			Texture tex = pgl.getTexture(pg);
			JSpout.receiveTexture(dim, tex.glName, tex.glTarget, bInvert);
		}
	     
		return pg;    
	}
	  
	
	// Receive into an image
	public PImage receiveTexture(PImage img) {
	  
		// If no sender, keep looking
		if(!bInitialized) {
			createReceiver("");
			return img;
		}
		
		boolean bInvert = false; // default for this function
		if(invertMode >= 0) bInvert = (invertMode == 1);

		if(dim[0] != img.width || dim[1] != img.height && dim[0] > 0 && dim[1] > 0) {
			img.resize(dim[0], dim[1]);
		}
		else {
			Texture tex = pgl.getTexture(img);
			JSpout.receiveTexture(dim, tex.glName, tex.glTarget, bInvert);
		}    
	    
		return img;
	}
	 
	
	 
	// 
	// Utility
	//
	
	// Pop up SpoutPanel to select a sender
	// If the user selected a different one, attach to it.
	public void selectSender()
	{
		if(JSpout.senderDialog())
			createReceiver("");
		else
			checkReceiver();
	}
	
	
	// User option to set texture inversion for both send and receive
	public void setInvert(boolean bInvert)
	{
		// invertMode is -1 unless the user specifically selects it
		if(bInvert)
			invertMode = 1;
		else
			invertMode = 0;
	}	

	
	public void resizeFrame()
	{
		if(!bInitialized) return;
		// Check app screen against the sender dimensions
		if(parent.width != dim[0] || parent.height != dim[1]  && dim[0] > 0 && dim[1] > 0) {
			// Processing 3 only - insets needed for Processing2
			// TODO - how to check or limit Library to minimum Processing 3.0 ?
			parent.getSurface().setSize(dim[0], dim[1]); // what here
		}
	}
	  
	
	// 
	// Local functions
	//
	
	//
	// Check the receiver for any sender changes
	//
	// This is normally done within JSpout.ReceiveTexture
	// But is necessary if DrawSharedTexture is used.
	// Returns a different name or dimensions if the sender has changed
	// The name is returned empty if the sender is closed
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
	    		System.out.println("Found sender : " + senderName + " " + dim[0] + "x" + dim[1]);
	    	}
	    	// The sender has not changed
	    	return true;
	    }
	    else { // the sender has closed
	    	System.out.println("Sender closed");
	    	senderName = "";
	    	bInitialized = false;
	    }
	      
	    return false;
	   
	} // end CheckReceiver

	
	  
	void spoutReport(boolean bInit)
	{
		boolean bMemoryMode;
		if(bInit) {
			bMemoryMode = JSpout.getMemoryShareMode();
			if(bMemoryMode)
				System.out.println("Spout initialized memory sharing");
			else
				System.out.println("Spout initialized texture sharing");
		}
		else {
			System.out.println("Spout intialization failed");
		}
	}
	  
} // end class SpoutReceiver
