//
//    Class SpoutSender
//
//    Adds support to the basic functions of the 
//    "JSpout" class and JNI dll, defined in JSpout.java
//

package spoutpackage; // what here  - how to reference JSpout ?

import processing.core.*;
import processing.opengl.*;

public class SpoutSender {

	// protected PApplet parent;
	private PApplet r_Parent; // ?? correct ?
	PGraphicsOpenGL pgl;
	String senderName;
	int[] dim = new int[2]; // Sender dimensions
	boolean bInitialized; // initialization flag
	int invertMode; // User setting for texture invert

	public SpoutSender() {
		pgl = (PGraphicsOpenGL) r_Parent.g;
		dim[0] = 0; // Sender width
		dim[1] = 0; // Sender height
		bInitialized = false;
		senderName = "";
		invertMode = -1; // User has not set any mode - use function defaults
	}

	// TODO - dispose
	
	//
	// Initialize a sender 
	//
  
	// For texture sharing, the name provided is registered in the list of senders
	// Texture share initialization succeeds if the graphics hardware is compatible,
	// otherwise it defaults to memoryshare mode
	public boolean createSender(String name, int Width, int Height) {
		bInitialized = JSpout.CreateSender(name, Width, Height);
		spoutReport(bInitialized); // console report
		return bInitialized;
	}


	public void closeSender() {
		if(JSpout.ReleaseSender())
			System.out.println("Sender closed");
		else
			System.out.println("No sender to close");
	}
  
  
	// Write the sketch drawing surface texture to an opengl/directx shared texture
	public void sendTexture() {
		if(!bInitialized) return;
      	// Set the invert flag to the user setting if it has been selected
		// Processing Y axis is inverted with respect to OpenGL
		// so we need to invert the texture for this function
		boolean bInvert = true; 
		if(invertMode >= 0) bInvert = (boolean)(invertMode == 1);
      
		pgl.beginPGL();
		// Load the current contents of the renderer's drawing surface into its texture.
		pgl.loadTexture();
		// getTexture returns the texture associated with the renderer's drawing surface,
		// making sure is updated to reflect the current contents off the screen 
		// (or offscreen drawing surface).      
		Texture tex = pgl.getTexture();
		JSpout.SendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert);
		pgl.endPGL();
	}
  
	
	// Write the texture of a graphics object
	public void sendTexture(PGraphics pgr)
	{
		if(!bInitialized) return;
		boolean bInvert = true;
		if(invertMode >= 0) bInvert = (invertMode == 1);
		Texture tex = pgl.getTexture(pgr);
		JSpout.SendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert);
	}
	  
	  
	// Write the texture of an image object
	public void sendTexture(PImage img)
	{
		if(!bInitialized) return;
		boolean bInvert = false; // default for this function
		if(invertMode >= 0) bInvert = (invertMode == 1);
		Texture tex = pgl.getTexture(img);
		JSpout.SendTexture(tex.glWidth, tex.glHeight, tex.glName, tex.glTarget, bInvert);
	}
	  
	
	  
	//  
	// SPOUTCONTROLS
	//
	  
	public boolean createSpoutControl(String name, String type) {
		return(JSpout.CreateControl(name, type, 0, 1, 1, ""));
	}
	  
	public boolean createSpoutControl(String name, String type, float value) {
		return(JSpout.CreateControl(name, type, 0, 1, value, ""));
	}

	public boolean createSpoutControl(String name, String type, String text) {
		return(JSpout.CreateControl(name, type, 0, 1, 1, text));
	}

	public boolean createSpoutControl(String name, String type, float minimum, float maximum, float value) {
		return(JSpout.CreateControl(name, type, minimum, maximum, value, ""));
	}
	  
	public boolean openSpoutControls(String name) {
		return(JSpout.OpenControls(name));
	}
	  
	public int checkSpoutControls(String[] controlName, int[] controlType, float[] controlValue, String[] controlText ) {
		return JSpout.CheckControls(controlName, controlType, controlValue, controlText);
	}
	   
	public boolean closeSpoutControls() {
		return(JSpout.CloseControls());
	}
	
	
	//
	//  SHARED MEMORY
	//
	  
	public boolean createSenderMemory(String name, int Width, int Height) 
	{
		return (JSpout.CreateSenderMemory(name, Width, Height));
	}
	 
	public boolean updateSenderMemorySize(String name, int Width, int Height) 
	{
		return (JSpout.UpdateSenderMemorySize(name, Width, Height));
	}
	  
	public boolean writeSenderString(String sValue) 
	{
		return (JSpout.WriteSenderString(sValue));
	}
	  
	public void closeSenderMemory() 
	{
		JSpout.CloseSenderMemory();
	}
	  
	public long lockSenderMemory() 
	{
		return JSpout.LockSenderMemory();
	}
	    
	public void unlockSenderMemory() 
	{
		JSpout.UnlockSenderMemory();
	}
	  

	
	// 
	// Utility
	//
	
	// User option to set texture inversion for both send and receive
	public void setInvert(boolean bInvert)
	{
		// invertMode is -1 unless the user specifically selects it
		if(bInvert)
			invertMode = 1;
		else
			invertMode = 0;
	}
	   
	// 
	// Local functions
	//

	void spoutReport(boolean bInit)
	{
		boolean bMemoryMode;
		if(bInit) {
			bMemoryMode = JSpout.GetMemoryShareMode();
			if(bMemoryMode)
				System.out.println("Spout initialized memory sharing");
			else
				System.out.println("Spout initialized texture sharing");
		}
		else {
			System.out.println("Spout intialization failed");
		}
	}
	  
} // end class SpoutSender
