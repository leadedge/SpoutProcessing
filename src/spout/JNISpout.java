package spout;

public class JNISpout {

  static {
	
	// String jvm_location = System.getProperties().getProperty("java.home") + "\\" + "bin" + "\\" + "java.exe";
	// System.out.println(jvm_location);
	String jvm_version = System.getProperty("java.version");

	// Java instead of operating system
	String sunDataModel = System.getProperty("sun.arch.data.model");
	System.out.println("Spout " + sunDataModel +"bit v2.0.7.8 - Java " + jvm_version);
	// System.out.println("Java " + sunDataModel + "bit " + jvm_version);
	if(sunDataModel.equals("32"))	
		System.loadLibrary("JNISpout_32");
	else if(sunDataModel.equals("64"))	
		System.loadLibrary("JNISpout_64");
  }
  
  // Initialization - return a pointer to a spout object
  protected static native long init();
  protected static native void deInit(long ptr);
  
  // Sender
  protected static native boolean createSender(String name, int width, int height, long ptr);
  protected static native boolean updateSender(String name, int width, int height, long ptr);
  protected static native boolean releaseSender(long ptr);
  protected static native boolean sendTexture(int w, int h, int texID, int texTarget, boolean bInvert, long ptr);

  // Receiver
  protected static native void setReceiverName(String name, long ptr);
  protected static native boolean createReceiver(String name, int[] dim, long ptr);
  protected static native boolean releaseReceiver(long ptr);
  protected static native boolean receivePixels(int[] dim, int[] pix, long ptr);
  protected static native boolean receiveTexture(int[] dim, int texID, int texTarget, boolean bInvert, long ptr);
  protected static native boolean senderDialog(long ptr);
  protected static native String getSenderName(long ptr);
  protected static native int getSenderWidth(long ptr);
  protected static native int getSenderHeight(long ptr);
  protected static native int getSenderFormat(long ptr);
  protected static native String getSenderFormatName(long ptr);
  
  // Frame count
  protected static native float getSenderFps(long ptr);
  protected static native int getSenderFrame(long ptr);
  protected static native boolean isFrameNew(long ptr);
  protected static native void disableFrameCount(long ptr);
  
  // Logging
  protected static native void enableSpoutLog(long ptr);
  protected static native void spoutLogToFile(String filename, boolean bAppend, long ptr);
  protected static native void spoutLogLevel(int level, long ptr);
  protected static native void spoutLog(String logtext, long ptr);
  protected static native void spoutLogVerbose(String logtext, long ptr);
  protected static native void spoutLogNotice(String logtext, long ptr);
  protected static native void spoutLogWarning(String logtext, long ptr);
  protected static native void spoutLogError(String logtext, long ptr);
  protected static native void spoutLogFatal(String logtext, long ptr);
  
  // MessageBox
  protected static native int spoutMessageBox(String message, String caption, int type, String instruction, int timeout, long ptr);
  protected static native void spoutMessageBoxIcon(String iconfile, long ptr);
  protected static native void spoutMessageBoxButton(int ID, String title, long ptr);  
  protected static native void spoutMessageBoxModeless(boolean bMode, long ptr); 
  protected static native String spoutEditBox(String message, String caption, String text, long ptr);  
  protected static native int spoutComboBox(String message, String caption, String[] items, long ptr); 
  protected static native void spoutMessageBoxWindow(boolean bEnable, long ptr); 
  
  // Utility
  protected static native boolean copyToClipBoard(String text, long ptr);
    
  // Common
  protected static native int getTextureID(long ptr);
  protected static native boolean getMemoryShareMode(long ptr);
  protected static native int getShareMode(long ptr);
  
  // SpoutControls
  protected static native boolean createControl(String name, String type, float minimum, float maximum, float value, String text, long ptr);
  protected static native boolean openControls(String name, long ptr);
  protected static native int checkControls(String[] name, int[] type, float[] value, String[] text, long ptr);
  protected static native boolean openController(String path, long ptr);
  protected static native boolean closeControls(long ptr);
  
  // Shared memory
  protected static native boolean createSenderMemory(String name, int width, int height, long ptr);
  protected static native boolean updateSenderMemorySize(String name, int width, int height, long ptr);
  protected static native boolean writeSenderString(String buf, long ptr);
  protected static native void closeSenderMemory(long ptr);
  protected static native long lockSenderMemory(long ptr);
  protected static native void unlockSenderMemory(long ptr);
  
  // Sync event signals
  protected static native void setFrameSync(String SenderName, long ptr);
  protected static native boolean waitFrameSync(String SenderName, int dwTimeout, long ptr);
  
  // Per-frame metadata
  protected static native boolean writeMemoryBuffer(String name, String data, int length, long ptr);
  protected static native String readMemoryBuffer(String name, int maxlength, long ptr);
  protected static native boolean createMemoryBuffer(String name, int length, long ptr);
  protected static native boolean deleteMemoryBuffer(long ptr);
  protected static native int getMemoryBufferSize(String name, long ptr);
  
}
