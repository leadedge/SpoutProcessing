package spout;

public class JNISpout {


  static {
	
	// String jvm_location = System.getProperties().getProperty("java.home") + "\\" + "bin" + "\\" + "java.exe";
	// System.out.println(jvm_location);
	String jvm_version = System.getProperty("java.version");

	// Java instead of operating system
	String sunDataModel = System.getProperty("sun.arch.data.model");
	System.out.println("Java " + sunDataModel + "bit " + jvm_version);
	if(sunDataModel.equals("32"))	
		System.loadLibrary("JSpout_32");
	else if(sunDataModel.equals("64"))	
		System.loadLibrary("JSpout_64");
  }
  
  
  
  //=================================================================== //
  //                            SENDER                                  //
  //=================================================================== //
  
  protected static native boolean createSender(String name, int width, int height);

  protected static native boolean releaseSender();

  protected static native boolean sendTexture(int w, int h, int texID, int texTarget, boolean bInvert);
 
  // SpoutControls

  protected static native boolean createControl(String name, String type, float minimum, float maximum, float value, String text);
  
  protected static native boolean openControls(String name);

  protected static native int checkControls(String[] name, int[] type, float[] value, String[] text);
  
  protected static native boolean openController(String path);

  protected static native boolean closeControls();
  
  // Shared memory

  protected static native boolean createSenderMemory(String name, int width, int height);

  protected static native boolean updateSenderMemorySize(String name, int width, int height);

  protected static native boolean writeSenderString(String buf);

  protected static native void closeSenderMemory();

  protected static native long lockSenderMemory();

  protected static native void unlockSenderMemory();
  
  
  
  //=================================================================== //
  //                           RECEIVER                                 //
  //=================================================================== //

  protected static native boolean createReceiver(String name, int[] dim);
  
  protected static native String checkReceiver(String name, int[] dim);

  protected static native boolean releaseReceiver();

  protected static native boolean receiveImage(int[] dim, int[] pix);

  protected static native boolean receiveTexture(int[] dim, int texID, int texTarget, boolean bInvert);

  protected static native boolean drawTexture(boolean bInvert);

  protected static native boolean senderDialog();

  protected static native String getSenderName();
  
  
  
  //=================================================================== //
  //                            COMMON                                  //
  //=================================================================== //

  protected static native int getTextureID();

  protected static native boolean getMemoryShareMode();

 
}
