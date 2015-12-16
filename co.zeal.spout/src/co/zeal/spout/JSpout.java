package co.zeal.spout;

public class JSpout {


  static {
	
	// String jvm_location = System.getProperties().getProperty("java.home") + "\\" + "bin" + "\\" + "java.exe";
	// System.out.println(jvm_location);
	String jvm_version = System.getProperty("java.version");

	// Java instead of operating system
	String sunDataModel = System.getProperty("sun.arch.data.model");
	// System.out.println("Java " + sunDataModel + "bit " + jvm_version);
	if(sunDataModel.equals("32"))	
		System.loadLibrary("JSpout_32");
	else if(sunDataModel.equals("64"))	
		System.loadLibrary("JSpout_64");
	  
	  
	/*
	String dataModel = System.getProperty("os.arch");
	System.out.println(dataModel);
	if(dataModel.equals("x86_32"))	
		System.loadLibrary("JSpout_32");
	else if(dataModel.equals("x86_64") || dataModel.equals("amd64"))	
		System.loadLibrary("JSpout_64");
	*/
  }
  
  
  
  //=================================================================== //
  //                            SENDER                                  //
  //=================================================================== //
  
  public static native boolean createSender(String name, int width, int height);

  public static native boolean releaseSender();

  public static native boolean sendTexture(int w, int h, int texID, int texTarget, boolean bInvert);
 
  // SpoutControls

  public static native boolean createControl(String name, String type, float minimum, float maximum, float value, String text);
  
  public static native boolean openControls(String name);

  public static native int checkControls(String[] name, int[] type, float[] value, String[] text);

  public static native boolean closeControls();
  
  // Shared memory

  public static native boolean createSenderMemory(String name, int width, int height);

  public static native boolean updateSenderMemorySize(String name, int width, int height);

  public static native boolean writeSenderString(String buf);

  public static native void closeSenderMemory();

  public static native long lockSenderMemory();

  public static native void unlockSenderMemory();
  
  
  
  //=================================================================== //
  //                           RECEIVER                                 //
  //=================================================================== //

  public static native boolean createReceiver(String name, int[] dim);
  
  public static native String checkReceiver(String name, int[] dim);

  public static native boolean releaseReceiver();

  public static native boolean receiveImage(int[] dim, int[] pix);

  public static native boolean receiveTexture(int[] dim, int texID, int texTarget, boolean bInvert);

  public static native boolean drawTexture(boolean bInvert);

  public static native boolean senderDialog();

  public static native String getSenderName();
  
  
  
  //=================================================================== //
  //                            COMMON                                  //
  //=================================================================== //

  public static native int getTextureID();

  public static native boolean getMemoryShareMode();

 
}
