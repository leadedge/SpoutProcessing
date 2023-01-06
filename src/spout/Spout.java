package spout;

//========================================================================================================
//
//                  Spout.Java
//
//		Adds support to the functions of the JSpout JNI library.
//
//		19.12.15 - Finalised Library class
//				 - Changed all parent.println to System.out.println to prevent compiler warning
//				 - Changed "(boolean)(invertMode == 1)" to "(invertMode == 1)" to prevent compiler warning
//				 - Documented all functions
//				 - Cleanup - previous revisions in older Spout.pde file
//		12.02.16 - Changed "ReceiveTexture()" to update and draw a local graphics object
//				 - Removed java.awt import - not needed for Processing 3 frame sizing
//		15.02.16 - Removed "createSender" function console output
//		26.02.16 - Updated JNISpout library dll files - tested Processing 3.0.2 64bit and 32bit 
//				   Spout 2.005 SDK as at 26.02.16 - incremented library version number to 2.0.5.2
//		01.03.16 - Separated initialization flag to bSenderInitialized and bReceiverConnected
//				 - Added "updateSender" to JNISpout.java and the JNI dll
//				 - Introduced createSenderName using the sketch folder name as default
//		06.03.16 - Introduced object pointers for multiple senders / receivers
//		17.03.16 - Fixed release of receiver when the received sender closed
//		18.03.16 - Fixed initial detection of named sender for CreateReceiver
//		25.03.16 - Removed "Settings" from multiple examples to work with Processing 2.2.1
//		30.03.16 - Rebuild for Spout 2.005 release - version 2.0.5.3
//		28.04.16 - Added "receivePixels"
//		10.05.16 - Added SpoutControls example
//		12.05.16 - Library release - version 2.0.5.4
//		02.06.16 - Library release - version 2.0.5.5 for Spout 2.005 June 2016
//		07.07.16 - Updated for latest SDK functions
//				   co.zeal.spout project removed
//		09.10.16 - Introduced cleanup function for dispose
//				   https://github.com/processing/processing/issues/4381#issuecomment-252198109
//		15.01.17 - Change to Processing 3.2.3 core library.
//				   Added getShareMode - 0 Texture, 1 CPU, 2 Memory
//		26.01.17 - Rebuild for Spout 2.006 - version 2.0.6.0
//		27.01.17 - Some comment changes for CreateSender.
//				 - JNISpout - changes to OpenSpoutController to find a SpoutControls installation
//		08.02.17 - Change to Processing 3.2.4 core library.
//				 - SpoutControls example removed - duplicate of SpoutBox in the SpoutControls installation
//				 - Rebuild with current SDK files
//				 - Library release - version 2.0.6.0 for Spout 2.006 - February 2017
//		10.02.12 - Changed Build properties to java.target.version=1.8
//		16.06.17 - Added getSenderName, getSenderWidth, getSenderHeight
//				 - Update JNISpout
//		18.06.17 - Change to Processing 3.2.4 core library
//				 - Update Version to 2.0.7.0 for Spout 2.007
//		27.06.17 - Change to Processing 3.2.5 core library
//		17.11.18 - Updates for Spout 2.007
//				   New frame option for all SDK sending and receiving functions
//				   Add getSenderFps, getSenderFrame
//				   Change application CreateReceiver with name option to setupReceiver
//				   Change receiveTexture() to void, always draw graphics
//				   Change to Processing 3.4 core library
//		18.11.18 - Change return types for receive functions
//				   Simplified functions with object arguments passed by reference
//				   https://processing.org/tutorials/objects/
//				   Add receiveGraphics and receiveImage
//				   Allocate local graphics object in constructor
//		03.01.19 - Revise examples
//		26.01.19 - Change to Processing 3.5.2 core library
//				   Add logging functions
//				   Update JNISpout libraries
//		27.01.19 - Set InfoBox message dialog topmost so it does not get lost
//		25.04.19 - Add pgr.loadPixels() before getTexture in ReceiveTexture
//				   To avoid "pixels array is null" error the first time it is accessed
//				   Minor changes to code layout in createReceiver
//		20.05.19 - Change setupReceiver to setReceiverName
//				   Change receiveTexture from void to boolean. Updated receiver examples.
//				   Add if(pgs.loaded to drawTexture
//		04.06.19   Rebuild with 2.007 SDK and JNISpout library
//		06.06.19   Rebuild for 256 max senders for 2.007
//		10.06.19   Changed Eclipse compiler compliance to Java 1.8
//		13.10.19   Rebuild for revised Spout SDK
//		27.11.19   Rebuild for revised Spout SDK
//		22.01.20   Update to Processing 3.5.4 core
//				   Removed setupSender function - createSender still used 
//		13.02.20   Add setAdapter
//				   Rebuild for revised 2.007 Spout SDK and JNISpout library
//		16.04.20   spoutCleanup : use closeSender or closeReceiver instead of release functions directly
//		19.06.20   Rebuild for GitHub update (Processing 3.5.4)
//		24.12.20   Update for SpoutGL changes
//				   Add setReceiverName to JNISpout
//				   Add setSenderName
//				   TODO : sender graphics resize
//				   Rebuild for revised 2.007 SpoutGL and updated JNISpout library (Processing 3.5.4)
//		24.01.21   Rebuild for 2.007 release Version 2.0.7.1
//		13.04.21   Add setFrameSync, waitFrameSync, writeMemoryBuffer, readMemoryBuffer
//		21.05.21   Rebuild JNI/Processing libraries
//		22.05.21   Add data sender/receiver examples
//		27.05.21   Add createMemoryBuffer
//		14.06.21   Rebuild for 2.007e release Version 2.0.7.2
//				   Publish Release 2.0.7.2 tagged as "latest" and test download from sketch
//		23.02.22   Add separate function ReceiveImage(PImage)
//                 Load pixels and update them from the received texture
//		26.02.22   pgs allocated by receiveGraphics rather than in advance
//		           loadPixels() of PGraphics object in receiveGraphics to avoid null pixels array
//				   getSenderData = return empty string if bufferSize = 0
//				   Initialize bufferSize on Spout object create
//		27.02.22   Publish Release 2.0.7.3
//				   Processing 3.5.4 retained while Processing 4 is beta
//				   Testing with Processing 4 shows no problems
//		01.11.22   Change to core.jar Processing 4.0.1
//				   Rebuild with updated JSpoutLIB libraries Release 2.0.7.5
//		20.12.22   Remove SetAdapter from JNI library
//		06.01.23   Update JSpoutLIB with SpoutGL files 2.007.009
//				   Rebuild Release 2.0.7.5
//
// ========================================================================================================


import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.opengl.*;

import javax.swing.JFrame;
import javax.swing.JOptionPane; // for infoBox

/**
 * Main Class to use with Processing
 * 
 * @author Lynn Jarvis, Martin Froehlich
 *
 */
public class Spout {
	
	// A pointer to the spout object created
	long spoutPtr;
	PApplet parent;
	PGraphicsOpenGL pgl;
	PGraphics pgs; // local graphics object for receiving textures (allocated by receiveGraphics)
	String senderName; // the sender name
	String userSenderName; // user specified sender name for CreateReceiver
	int[] dim = new int[2]; // Sender dimensions
	boolean bSenderInitialized; // sender initialization flag
	boolean bReceiverConnected; // receiver initialization flag
	boolean bPixelsLoaded;
	int receiverType; // 0 - parent, 1 - graphics, 2 - image
	int invertMode; // User setting for texture invert
	int bufferSize; // shared memory buffer size
	
	/**
	 * Create a Spout Object.
	 * 
	 * A spout object is created within the JNI dll
	 * and a pointer to it saved in this class for
	 * use with all functions.
	 * 
	 * @param parent : parent sketch
	 */
	public Spout (PApplet parent) {
	
		// A pointer to the new spout object for this instance
		spoutPtr = JNISpout.init();

		if(spoutPtr == 0) 
			PGraphics.showWarning("Spout initialization failed");

		this.parent = parent;
		
		pgl = (PGraphicsOpenGL) parent.g;
		dim[0] = 0; // Sender width
		dim[1] = 0; // Sender height
		bSenderInitialized = false;
		bReceiverConnected = false;
		bPixelsLoaded = false;
		senderName = "";
		userSenderName = "";
		receiverType = 0; // receive to parent graphics
		invertMode = -1; // User has not set any mode - use function defaults
		bufferSize = 0; // No data buffer

		parent.registerMethod("dispose", this);
		
	}  
	
	/**
	 * Can be called from the sketch to release the library resources.
	 * Such as from an over-ride of "exit" in the sketch for Processing 3.0.2
	 */
	public void release() {
		 // infoBox("Spout release");
		 dispose();
	}
		
	/**
	  * This method should be called automatically when the sketch is disposed.
	  * Differences observed between Processing versions :
	  * 3.0.1 calls it for [X] window close or esc but not for the "Stop" button,
	  * 3.0.2 does not call it at all.
	  * 3.2.3 calls it for esc or [X] but not for the stop button.
	  * 3.5.2 calls it for esc or [X] but not for the stop button.
	  * 3.5.4 calls it for esc or [X] but not for the stop button.
	  * Senders are apparently released because they can't be detected subsequently.  
	  */
	 public void dispose() {
		// infoBox("Spout dispose");
		spoutCleanup();
	}

	/**
	 * The class finalizer - adapted from Syphon.
	 * Never seems to be called.
	 */
	protected void finalize() throws Throwable {
		// infoBox("Spout finalize");
		try {
			spoutCleanup();
	    } finally {
	    	super.finalize();
	    }
	} 

	  
	// =========================================== //
	//                   SENDER                    //
	// =========================================== //
	
	/**
	 * Initialize a sender name.
	 * If the name is not specified, the sketch folder name is used.
	 * 
	 * @param name : sender name
	 */
	public void setSenderName(String name) {
		if(name.isEmpty() || name.equals("") ) {
			String path = parent.sketchPath();
			int index = path.lastIndexOf("\\");
			senderName = path.substring(index + 1);
		}
		else {
			senderName = name;
		}
	}
	
	/**
	 * Initialize a sender with the sketch window dimensions.
	 * If the sender name is not specified, the sketch folder name is used.
	 * 
	 * @param name : sender name (up to 256 characters)
	 * @return true if the sender was created
	 */	
	public boolean createSender(String name) {
		setSenderName(name);
		return createSender(name, parent.width, parent.height);
	}	
		
	/**
	 * Initialize a sender.
	 * 
	 * The name provided is registered in the list of senders
	 * Initialization is made using or whatever the user has selected
	 * with SpoutDXmode : Texture, CPU or Memory. Texture share only 
	 * succeeds if the graphic hardware is compatible, otherwise it
	 * defaults to CPU texture share mode.
	 *  
	 * @param name : sender name (up to 256 characters)
	 * @param Width : sender width
	 * @param Height : sender height
	 * @return true if the sender was created
	 */
	public boolean createSender(String name, int Width, int Height) {
		setSenderName(name);
		if(JNISpout.createSender(senderName, Width, Height, spoutPtr)) {
			bSenderInitialized = true;
			dim[0] = Width;
			dim[1] = Height;
			System.out.println("Created sender '" + senderName + "' (" + dim[0] + "x" + dim[1] + ")");
			spoutReport(bSenderInitialized); // console report
		}
		return bSenderInitialized;
	}
	
	/**
	 * Update the size of the current sender
	 * 
	 * @param Width : new width
	 * @param Height : new height
	 */
	public void updateSender(int Width, int Height) {
		
		if(bSenderInitialized) { // There is a sender name
			JNISpout.updateSender(senderName, Width, Height, spoutPtr);
			dim[0] = Width;
			dim[1] = Height;
		}
	}
	
	/**
	 * Close the sender. 
	 * 
	 * This releases the sender name from the list of senders
	 * and releases all resources for the sender.
	 */
	public void closeSender() {
		if(bSenderInitialized) {
			if(JNISpout.releaseSender(spoutPtr))
				System.out.println("Sender closed");
			else
				System.out.println("No sender to close");
			
			bSenderInitialized = false;
		}
	} 

	/**
	 *	Write the sketch drawing surface texture to 
	 *	an opengl/directx shared texture
	 */
	public void sendTexture() {

		if(!bSenderInitialized)	{
			// Create a sender the dimensions of the sketch window
			createSender(senderName, parent.width, parent.height);
			return;
		}
		else if(dim[0] != parent.width || dim[1] != parent.height) {
			// Update the dimensions of the sender
			updateSender(parent.width, parent.height);
			return;
		}

		// Set the invert flag to the user setting if it has been selected
		// Processing Y axis is inverted with respect to OpenGL
		// so we need to invert the texture for this function
		boolean bInvert = true; 
		if(invertMode >= 0) bInvert = (invertMode == 1);
		
		pgl.beginPGL();
		// Load the current contents of the renderer's
		// drawing surface into its texture.
		pgl.loadTexture();
		// getTexture returns the texture associated with the
		// renderer's drawing surface, making sure is updated 
		// to reflect the current contents off the screen 
		// (or offscreen drawing surface).      
		Texture tex = pgl.getTexture();
		JNISpout.sendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert, spoutPtr);
		pgl.endPGL();

	}
	
	/**
	 * Write the texture of a graphics object.
	 * 
	 * @param pgr : the graphics object to be used.
	 */
	public void sendTexture(PGraphics pgr)
	{
		if(!bSenderInitialized) {
			// Create a sender the dimensions of the graphics object
			dim[0] = pgr.width;
			dim[1] = pgr.height;
			createSender(senderName, dim[0], dim[1]);
			return;
		}
		else if(dim[0] != pgr.width || dim[1] != pgr.height) {
			// Update the dimensions of the sender
			updateSender(pgr.width, pgr.height);
			return;
		}
		
		boolean bInvert = true;
		if(invertMode >= 0) bInvert = (invertMode == 1);
		Texture tex = pgl.getTexture(pgr);
		JNISpout.sendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert, spoutPtr);

	}

	/**
	 *  Write the texture of an image object.
	 *  
	 * @param img : the image to be used.
	 */
	public void sendTexture(PImage img)
	{
		if(!bSenderInitialized)	{
			// Create a sender the dimensions of the image object
			createSender(senderName, img.width, img.height);
			return;
		}
		else if(dim[0] != img.width || dim[1] != img.height) {
			// Update the dimensions of the sender
			updateSender(img.width, img.height);
			return;
		}
		
		boolean bInvert = false; // default for this function
		if(invertMode >= 0) bInvert = (invertMode == 1);
		Texture tex = pgl.getTexture(img);
		JNISpout.sendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert, spoutPtr);

	}

	
	// =========================================== //
	//                   RECEIVER                  //
	// =========================================== //
	
	/**
	 * 	Set a sender name to receive from
	 * 
	 * @param name : sender name to be used
	 */
	 public void setReceiverName(String name) {
		 userSenderName = name;
		 JNISpout.setReceiverName(userSenderName, spoutPtr);
	 }

	/**
	 * 	Create a Receiver. 
	 * 
	 * Create receiver using the system sender name
	 * @return true if connection with a sender succeeded
	 */
	public boolean createReceiver() {
		// Pass the user specified sender name
		return createReceiver(userSenderName);
	}
	
	/**
	 *  Create a Receiver. 
	 * 
	 * If the named sender is not running or if the name is not specified,
	 * the receiver will attempt to connect with the active sender.
	 * If the sender is found, the name is returned and set.
	 *  
	 * @param name : sender name to be used
	 * @return true if connection with a sender succeeded
	 */
	public boolean createReceiver(String name) {
		
		// Image size values passed in are modified and passed back
		// as the size of the sender that the receiver connects to.
		dim[0] = parent.width;
		dim[1] = parent.height;
		String newname;
		
		// Use the user specified sender name if any.
		// If it is empty, the receiver will connect to the active sender 
		if(name.isEmpty() || name.equals("") ) {
			name = userSenderName;
		}
		
		if(JNISpout.createReceiver(name, dim, spoutPtr)) {
			// Initialization succeeded and there was a sender running
			// sender name and dimensions are established from the sender it connected to
			senderName = JNISpout.getSenderName(spoutPtr);
			dim[0] = JNISpout.getSenderWidth(spoutPtr);
			dim[1] = JNISpout.getSenderHeight(spoutPtr);
			bReceiverConnected = true;
			spoutReport(true);
			// Once connected, the user can select new senders
			// and graphics or images are re-allocated
			return true;
		}
		
		bReceiverConnected = false;
		return false;

	} // end createReceiver
	
	
	/**
	 * @return receiver status
	 */
	public boolean isReceiverConnected() {
		return bReceiverConnected;
	} 

	/**
	 * Close a receiver.
	 * All resources of the receiver are released.
	 */
	public void closeReceiver() {
		if(JNISpout.releaseReceiver(spoutPtr))
			System.out.println("Receiver closed");
		else
			System.out.println("No receiver to close");
		
		// Delete shared memory buffer if it has been created
		if(bufferSize > 0) {
			deleteMemoryBuffer();
			bufferSize = 0;
		}
		
		bReceiverConnected = false;
	} 
	
	/**
	 * Receive into local graphics
	 * @return result
	 */
	public boolean receiveTexture()
	{
		if(isConnected()) {
			pgs = receiveGraphics(pgs);
			return true;
		}
		return false;
	}
	
	/**
	 * Draw the local graphics
	 */
	public void drawTexture()
	{
		if(pgs.loaded && pgs.displayable()) {
			parent.image(pgs, 0, 0, parent.width, parent.height);
		}
	}
	
	/**
	 * Receive graphics texture
	 * 
	 * @param pgr : the graphics to be used
	 * @return changed graphics
	 */
	public PGraphics receiveTexture(PGraphics pgr)
	{
		return receiveGraphics(pgr);
	}
	
	/**
	 * Receive image texture
	 * 
	 * @param img : the image to be used
	 * @return changed image
	 */
	public PImage receiveTexture(PImage img) {
		return receiveImage(img, false);
	}
	
	/**
	 * Receive image pixels
	 * 
	 * @param img : the image to be used
	 * @return changed image
	 */
	public PImage receiveImage(PImage img) {
		return receiveImage(img, true);		
	}
	
	/**
	 * Receive a local graphics texture
	 */
	public void receiveGraphics()
	{
		pgs = receiveGraphics(pgs);
	}
	
	/**
	 * Receive a graphics texture
	 * 
	 * @param pgr : the graphics to be used
	 * @return changed graphics
	 */
	public PGraphics receiveGraphics(PGraphics pgr)
	{	
		boolean bInvert = true; // default for this function
		if(invertMode >= 0) bInvert = (invertMode == 1);
		
		// If not connected keep looking
		if(!isConnected())
			return pgr;
		
		// Create a graphics object or adjust the graphics to the current sender size
		if(pgr == null || dim[0] != pgr.width || dim[1] != pgr.height && dim[0] > 0 && dim[1] > 0) {
			pgr = parent.createGraphics(dim[0], dim[1], PConstants.P2D);
		}
		
		// Receive a texture if connected
		// Sender dimensions (dim) are sent as well as returned
		// If the sender changes size, the graphics object is adjusted next time round
		if(bReceiverConnected) {
			pgr.loadPixels(); // Necessary here or pixels array is null
			Texture tex = pgl.getTexture(pgr);
			if(!JNISpout.receiveTexture(dim, tex.glName, tex.glTarget, bInvert, spoutPtr)) {
				// Clear the graphics of the last frame
				pgr.updatePixels();
				// A new receiver is created
				JNISpout.releaseReceiver(spoutPtr);
				bReceiverConnected = false;
			}
		}
		
		// pgr is returned with the new size
		return pgr;
	}
	
	/**
	 * Receive an image texture with option for pixels
	 * 
	 * @param img : the image to be used
	 * @param loadpixels : load image pixels from the texture
	 * @return changed image
	 */
	public PImage receiveImage(PImage img, boolean loadpixels) {
		
		// If not connected keep looking
		if(!isConnected()) {
			return img;
		}
		
		// Receive into local graphics first
		pgs = receiveGraphics(pgs);

		// Create an image object or adjust the image to the current sender size
		if(img == null || dim[0] != img.width || dim[1] != img.height && dim[0] > 0 && dim[1] > 0) {
			img = parent.createImage(dim[0], dim[1], PConstants.ARGB);
		}		
		
		// Use the PGraphics texture as the cache object for the image
		// Adapted from Syphon client code
		// https://github.com/Syphon/Processing/blob/master/src/codeanticode/syphon/SyphonClient.java
		Texture tex = pgl.getTexture(pgs);
		pgl.setCache(img, tex);
		    
		// So far, only the image texture is updated, but not the pixels.
		// For receive to pixels, increased time can be expected.
		if(loadpixels) {
		  	// Load pixels and update from the received texture
		   	// (Adapted from Syphon client code)
		   	// https://github.com/Syphon/Processing/blob/master/src/codeanticode/syphon/SyphonClient.java
		   	// Slower than updating the texture alone
		   	// (Typically 1920x1080 : 15msec, 3840x2160 : 60msec, compared with < 1 msec for texture)
		   	// Load the pixel data of the current display window into the pixels[] array.
		   	// This function must always be called before reading from or writing to pixels[]
		   	// https://processing.org/reference/PImage_loadPixels_.html
		   	img.loadPixels();
	    	// Copy texture to pixels
	    	// https://processing.github.io/processing-javadocs/core/processing/opengl/Texture.html
	    	tex.get(img.pixels);
	    	// After changes have been made, call updatePixels()
	    	img.updatePixels();
	    }
		    
		return img;
		
	}	
	
	
	/**
	 * Is the receiver connected to a sender?
	 *
	 * @return new frame status
	 */
	public boolean isConnected() {
		
		if(!bReceiverConnected) {
			if(!createReceiver()) {
				return false;
			}
		}
		return true;
	}	
	
	/**
	 * Get the current sender name
	 * Checks for sender existence 
	 * 
	 * @return sender name
	 */
	public String getSenderName()
	{
		return JNISpout.getSenderName(spoutPtr);
	}
	
	/**
	 * Get the current sender width
	 * 
	 * @return sender width
	 */
	public int getSenderWidth()
	{
		return dim[0];
	}
	
	/**
	 * Get the current sender height
	 * 
	 * @return sender height
	 */
	public int getSenderHeight()
	{
		return dim[1];
	}

	/**
	 * Get the current sender frame rate
	 * 
	 * @return fps
	 */
	public int getSenderFps()
	{
		// Avoid integer truncation as far as possible
		return Math.round(JNISpout.getSenderFps(spoutPtr)+0.5f);
	}

	/**
	 * Get the current sender frame number
	 * 
	 * @return frame number
	 */
	public int getSenderFrame()
	{
		 return JNISpout.getSenderFrame(spoutPtr);
	}
	
	/**
	 * Is the received frame new
	 * 
	 * isFrameNew can be used after receiving a texture 
	 * to return whether the received frame is new.
	 * It is only necessary if there is a special application for it.
	 *  
	 * @return status
	 */
	public boolean isFrameNew()
	{
		 return JNISpout.isFrameNew(spoutPtr);
	}

	/**
	 * Disable frame counting for this application
	 * 
	 */
	public void disableFrameCount()
	{
		 JNISpout.disableFrameCount(spoutPtr);
	}
	
	/**
	 * Pop up SpoutPanel to select a sender.
	 * 
	 * If the user selected a different one, attach to it.
	 * Requires Spout installation 2.004 or higher.
	 */
	public void selectSender()
	{
		JNISpout.senderDialog(spoutPtr);
	}
	
	/*
	 * Enable logging to default console output
	 */
	public void enableSpoutLog()
	{
		JNISpout.enableSpoutLog(spoutPtr);
	}
	
	/*
	 * Log to a file
	 */
	public void enableSpoutLogFile(String filename)
	{
		JNISpout.spoutLogToFile(filename, false, spoutPtr);
	}
	
	/*
	 * Append logs to a file
	 */
	public void enableSpoutLogFile(String filename, boolean append)
	{
		JNISpout.spoutLogToFile(filename, append, spoutPtr);
	}	
	
	/*
	 * Set the Spout log level
	 * @param level
	 * 0 - Disable : 1 - Verbose : 2 - Notice (default)
	 * 3 - Warning : 4 - Error   : 5 - Fatal
	 */
	public void setLogLevel(int level)
	{
		JNISpout.spoutLogLevel(level, spoutPtr);
	}
	
	/**
	 * Log
	 * @param text - log text
	 *  
	 */
	public void spoutLog(String text)
	{
		JNISpout.spoutLog(text, spoutPtr);
	}
		
	/**
	 * Verbose log
	 * @param text - log text
	 *  
	 */
	public void spoutLogVerbose(String text)
	{
		JNISpout.spoutLogVerbose(text, spoutPtr);
	}
	
	/**
	 * Notice log
	 * @param text - log text
	 *  
	 */
	public void spoutLogNotice(String text)
	{
		JNISpout.spoutLogNotice(text, spoutPtr);
	}
	
	/**
	 * Warning log
	 * @param text - log text
	 *  
	 */
	public void spoutLogWarning(String text)
	{
		JNISpout.spoutLogWarning(text, spoutPtr);
	}
	
	/**
	 * Error log
	 * @param text - log text
	 *  
	 */
	public void spoutLogError(String text)
	{
		JNISpout.spoutLogError(text, spoutPtr);
	}
	
	/**
	 * Fatal log
	 * @param text - log text
	 *  
	 */
	public void spoutLogFatal(String text)
	{
		JNISpout.spoutLogFatal(text, spoutPtr);
	}

	/**
	 * Resize the receiver drawing surface and sketch window to that of the sender
	 * 
	 * Requires Processing 3+
	 */
	public void resizeFrame()
	{
		if(!bReceiverConnected) return;
		if(parent.width != dim[0] || parent.height != dim[1]  && dim[0] > 0 && dim[1] > 0) {
			// Only for Processing 3
			parent.getSurface().setSize(dim[0], dim[1]);
		}
	}

	/**
	 * Release everything
	 */
	public void spoutCleanup()
	{
		// infoBox("SpoutCleanup");
		if(bSenderInitialized) closeSender();
		if(bReceiverConnected) closeReceiver();
		if(spoutPtr > 0) JNISpout.deInit(spoutPtr);
		spoutPtr = 0;
    }
	
	

	// =========================================== //
	//               SPOUTCONTROLS                 //
	// =========================================== //
	
	/**
	 * Create a control with defaults.
	 * 
	 * @param name - control name
	 * @param type - text (string), bool, event or float
	 * @return true for success
	 */
	public boolean createSpoutControl(String name, String type) {
		return(JNISpout.createControl(name, type, 0, 1, 1, "", spoutPtr));
	}

	/**
	 * Create a control with default value.
	 * 
	 * @param name : control name
	 * @param type : text, float, bool or event
	 * @param value : default value
	 * @return true for success
	 */
	public boolean createSpoutControl(String name, String type, float value) {
		return(JNISpout.createControl(name, type, 0, 1, value, "", spoutPtr));
	}

	/**
	 * Create a text control with default string.
	 * 
	 * @param name : control name
	 * @param type : text
	 * @param text : default text
	 * @return true for success
	 */	
	public boolean createSpoutControl(String name, String type, String text) {
		return(JNISpout.createControl(name, type, 0, 1, 1, text, spoutPtr));
	}

	/**
	 * Create a float control with defaults.
	 * Minimum, Maximum, Default
	 * 
	 * @param name : control name
	 * @param type : float
	 * @param minimum : minimum value
	 * @param maximum : maximum value
	 * @param value : default value
	 * @return true for success
	 */	
	public boolean createSpoutControl(String name, String type, float minimum, float maximum, float value) {
		return(JNISpout.createControl(name, type, minimum, maximum, value, "", spoutPtr));
	}

	/**
	 * Open SpoutControls
	 * 
	 * A sender creates the controls and then calls OpenControls with a control name
	 * so that the controller can set up a memory map and share data with the sender
	 * as it changes the controls.
	 * @param name : control map name (the sender name)
	 * @return true for success
	 */
	public boolean openSpoutControls(String name) {
		return(JNISpout.openControls(name, spoutPtr));
	}
	
	/**
	 * Check the controller for changed controls.
	 * 
	 * The value or text string are changed depending on the control type.
	 * 
	 * @param controlName : name of control
	 * @param controlType : type : text, float, bool, event 
	 * @param controlValue : value
	 * @param controlText : text
	 * @return The number of controls. Zero if no change.
	 */
	public int checkSpoutControls(String[] controlName, int[] controlType, float[] controlValue, String[] controlText ) {
		return JNISpout.checkControls(controlName, controlType, controlValue, controlText, spoutPtr);
	}
	
	/**
	 * Open the SpoutController executable to allow controls to be changed.
	 * 
	 * Requires SpoutControls installation
	 * or SpoutController.exe in the sketch path
	 * 
	 * @return true if the controller was found and opened
	 */
	public boolean openController() {
		return(JNISpout.openController(parent.sketchPath(), spoutPtr));
	}
	
	/**
	 * Close the link with the controller.
	 * 
	 * @return true for success
	 */
	public boolean closeSpoutControls() {
		return(JNISpout.closeControls(spoutPtr));
	}

	// =========================================== //
	//               SHARED MEMORY                 //
	// =========================================== //
	
	/**
	 * Create a sender memory map.
	 * 
	 * @param name : sender name
	 * @param Width : map width
	 * @param Height : map height
	 * @return True for success
	 */
	public boolean createSenderMemory(String name, int Width, int Height) 
	{
		return (JNISpout.createSenderMemory(name, Width, Height, spoutPtr));
	}
	
	/**
	 * Change the size of a sender memory map.
	 * 
	 * @param name Sender name
	 * @param Width : new map width
	 * @param Height : new map height
	 * @return True for success
	 */
	public boolean updateSenderMemorySize(String name, int Width, int Height) 
	{
		return (JNISpout.updateSenderMemorySize(name, Width, Height, spoutPtr));
	}
	
	/**
	 * Write a string to the memory map.
	 * 
	 * The map size must be sufficient for the string.
	 * @param sValue : string to be written
	 * @return True for success
	 */
	public boolean writeSenderString(String sValue) 
	{
		return (JNISpout.writeSenderString(sValue, spoutPtr));
	}
	
	/**
	 * Close a sender memory map.
	 */
	public void closeSenderMemory() 
	{
		JNISpout.closeSenderMemory(spoutPtr);
	}
	
	/**
	 * Lock a memory map for write or read access.
	 * 
	 * @return Size of the memory map
	 */
	public long lockSenderMemory() 
	{
		return JNISpout.lockSenderMemory(spoutPtr);
	}

	/** 
	 * Unlock a memory map after locking.
	 * 
	 */
	public void unlockSenderMemory() 
	{
		JNISpout.unlockSenderMemory(spoutPtr);
	}
	
	// =========================================== //
	//              Sync event signals
	// =========================================== //
	
	/** 
	 * Signal sync event.
	 *   Create a named sync event and set for test
	 *  
	 */
	public void setFrameSync(String sendername)
	{
		JNISpout.setFrameSync(sendername, spoutPtr);
	}
	
	/** 
	 * Wait or test for named sync event.
	 *   Wait until the sync event is signalled or the timeout elapses.
	 *   Events are typically created based on the sender name and are
	 *   effective between a single sender/receiver pair.
	 *    - For testing for a signal, use a wait timeout of zero.
	 *    - For synchronization, use a timeout greater than the expected delay
	 * 
	 * @return success of wait
	 */
	public boolean waitFrameSync(String sendername, int timeout)
	{
		return JNISpout.waitFrameSync(sendername, timeout, spoutPtr);
	}
		
	
	// =========================================== //
	//              Per frame metadata
	// =========================================== //
	
	/** 
	 * Write a string to a sender shared memory buffer.
	 *   Create a shared memory map of the required size if it does not exist.
	 *   Subsequently the map size is fixed. To allow for varying string length
	 *   create shared memory of sufficient size in advance. 
	 *   The map is closed when the sender is released.
	 *   
	 * @return success of write
	 */
	public boolean setSenderData(String data)
	{
		// A sender name is required
		if(!bSenderInitialized)
			return false;

		// writeMemoryBuffer creates a map if not already
		return JNISpout.writeMemoryBuffer(senderName, data, data.length(), spoutPtr);
		
	}
	
	/** 
	 * Read sender shared memory buffer to a string.
	 *
	 * @return the string read
	 */
	public String getSenderData()
	{
		// A connected sender name is required
		if(!bReceiverConnected)
			return "";
		
		// The memory map is created by the sender
		if(bufferSize == 0) {
			bufferSize = JNISpout.getMemoryBufferSize(senderName, spoutPtr);
		}
		
		if(bufferSize > 0) {	
			return JNISpout.readMemoryBuffer(senderName, bufferSize, spoutPtr);
		}
		else {
			return "";
		}

	}
		
	/** 
	 * Create sender shared memory buffer.
	 *   Create a shared memory map of the required size.
	 *   The map is closed when the sender is released.
	 *   
	 * @return success of create
	 */
	public boolean createSenderBuffer(int length)
	{
		// A sender name is required
		// but sender initialization is not
		if(senderName == "")
			return false;
		
		if(JNISpout.createMemoryBuffer(senderName, length, spoutPtr)) {
			bufferSize = length;
			return true;
		}
		return false;
	}
	
	
	/** 
	 * Write buffer to sender shared memory.
	 *   Create a shared memory map of the required size if it does not exist.
	 *   The map is closed when the sender is released.
	 *   
	 * @return success of write
	 */
	public boolean writeMemoryBuffer(String sendername, String data, int length)
	{
		if(JNISpout.writeMemoryBuffer(sendername, data, length, spoutPtr)) {
			if(bufferSize == 0)
				bufferSize = JNISpout.getMemoryBufferSize(sendername, spoutPtr);
			return true;
		}
		return false;
	}
	
	/** 
	 * Read sender shared memory to buffer.
	 *   Open a sender memory map and retain the handle.
	 *   The map is closed when the receiver is released.
	 *
	 * @return number of bytes read
	 */
	public String readMemoryBuffer(String sendername, int maxlength)
	{
		return JNISpout.readMemoryBuffer(sendername, maxlength, spoutPtr);
	}
	
	/** 
	 * Create sender shared memory buffer.
	 *   Create a shared memory map of the required size.
	 *   The map is closed when the sender is released.
	 *   
	 * @return success of create
	 */
	public boolean createMemoryBuffer(String sendername, int length)
	{
		if(JNISpout.createMemoryBuffer(sendername, length, spoutPtr)) {
			bufferSize = length;
			return true;
		}
		return false;
	}
	
	/** 
	 * Delete sender shared memory buffer.
	 *   
	 * @return success of delete
	 */
	public boolean deleteMemoryBuffer()
	{
		if(JNISpout.deleteMemoryBuffer(spoutPtr)) {
			bufferSize = 0;
			return true;
		}
		return false;
	}
	
	/** 
	 * Get sender shared memory buffer size.
	 * 
	 * @return size of memory map
	 */
	public int getMemoryBufferSize()
	{
		return bufferSize; // JNISpout.getMemoryBufferSize(spoutPtr);
	}
	
	// =========================================== //
	//                   UTILITY                   //
	// =========================================== //

	/**
	 * User option to set texture inversion for send and receive
	 * 
	 * @param bInvert : true or false as required
	 */
	public void setInvert(boolean bInvert)
	{
		// invertMode is -1 unless the user specifically selects it
		if(bInvert)
			invertMode = 1;
		else
			invertMode = 0;
	}

	/**
	 * Print current settings to the console.
	 * 
	 * @param bInit : the initialization mode
	 */
	public void spoutReport(boolean bInit)
	{
		int ShareMode = 0; // Texture share default
		if(bInit) {
			ShareMode = JNISpout.getShareMode(spoutPtr);
			if(ShareMode == 2)
				System.out.println("Spout initialized memory sharing");
			else if(ShareMode == 1)
				System.out.println("Spout initialized CPU texture sharing");
			else
				System.out.println("Spout initialized texture sharing");
		}
		else {
			PGraphics.showWarning("Spout intialization failed");
		}
	}
	
	/**
	 * Pop up a MessageBox dialog
	 * 
	 * @param infoMessage : the message to show
	 */
	public void infoBox(String infoMessage)
    {
        // JOptionPane.showMessageDialog(null, infoMessage, "Spout", JOptionPane.INFORMATION_MESSAGE);
		// Set message dialog topmost so it does not get lost
		JFrame jf=new JFrame();
        jf.setAlwaysOnTop(true);
        JOptionPane.showMessageDialog(jf, infoMessage, "Spout", JOptionPane.INFORMATION_MESSAGE);
    }	

} // end class Spout

