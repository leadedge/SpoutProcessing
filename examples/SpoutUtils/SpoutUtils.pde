//
//            SpoutUtils
//
//      Examples of utilities in the Spout library
//
//      The "controlP5" library is required for GUI buttons
//
//      Spout must have been downloaded to use "Modeless" mode and
//      either "SpoutSettings" or "SpoutPanel" run at least once.
//        https://github.com/leadedge/Spout2/releases/
//
//      spoutMessageBox
//        Enhanced Windows MessageBox using TaskDialogIndirect
//
//        https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxa
//        https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect
//
//        with additional options for position, modeless, timeout,
//        hyperlinks, instrction, user icon, user buttons, 
//        text entry and combobox selection controls.
//
//        Arguments :
//          message, caption, type, main instruction, timeout (milliseconds)
//
//        o If the caption text is empty (""), the executable name
//          is used, in this case "java.exe"
//
//        o Type includes buttons and icons
//          A value of 0 is equivalent to MB_OK with no icon
//          Other button types are :
//             MB_OK
//             MB_OKCANCEL
//             MB_YESNOCANCEL
//             MB_YESNO
//         Topmost to keep the messagebox topmost
//             MB_TOPMOST
//         Icons can be combined with buttons
//             MB_ICONERROR
//             MB_ICONWARNING
//             MB_ICONINFORMATION
//          Return vales are :
//             IDOK      1
//             IDYES     2
//             IDNO      6
//             IDCANCEL  7
//
//      Buttons, icons are defined in the library "Spout" class
//      and are used with the object prefix. For example :
//          spout = new Spout(this);
//          spout.MB_OK, spout.MB_OKCANCEL, etc.
//   
//        o The main instruction is large blue text above the message.
//          If the instruction text is empty ("") it is not shown.
//
//        o The dialog closes itself after the timeout elapses
//          If the timeout is zero, the messagebox remains until 
//          a button is clicked. Timeout is disabled for any 
//          spoutMessageBox dialog requiring user input.
//
//        Overload functions
//           spoutMessageBox(message)
//           spoutMessageBox(message,timeout)
//           spoutMessageBox(message, caption)
//           spoutMessageBox(message, caption, timeout)
//           spoutMessageBox(message, caption, type)
//           spoutMessageBox(message, caption, type, timeout)
//           spoutMessageBox(message, caption, type, instruction)
//           spoutMessageBox(message, caption, type, instruction, timeout)
//
//      Edit control
//        An edit contol within the MessageBox can be used to 
//        enter text and return the entry. 
//        An existing string can be shown in the edit control.
//        If it is null, no previous entry is shown
//
//        Caption only
//          The edit control is in the message area
//            String str = spoutEditBox("Caption", null);
//
//        Cption with message
//          The edit control is in the footer area
//          An existing value is shown in the edit control.
//            String editstr = "Previous entry";
//            String str = spoutEditBox("Enter new text in the edit box below", "Caption", editstr);
//
//      Combo box control
//        A combo box control within the MessageBox can be used to
//        select from an item list and return the selection index.
//
//        Caption only
//          The combo box control is in the message area
//            String str = spoutComboBox("Caption");
//
//        Message text with caption
//          The combo box control is in the footer area
//            String str = spoutComboBox("Select an item from the list below", "Caption");
//
//      Clipboard
//         Copy text to the clipboard
//           copyToClipBoard(cliptext);
//
//      Click the buttons to show the various options.
//      The example sketch code itself shows more detail
//      on how to use the functions.
//
//      infoBox, messageBox, optionBox, inputBox
//
//      These Java code functions are now replaced by spoutMessageBox
//      They remain for back compatibility but may be removed in future.
//      Refer to Spout for Processing, Spout class library reference
//
//      Based on the Spout sender example
//      Refer to the sender and receiver examples
//      for details of send and receive functions
//
//            Spout 2.007
//       https://spout.zeal.co
//

import controlP5.*; // GUI for buttons
import spout.*; // Spout sender and utilities

ControlP5 cp5;
Spout spout;

PImage img; // image to use for the rotating cube

void setup() {
  
  size(800, 480, P3D);
  textureMode(NORMAL);
   
  textSize(18);
  img = loadImage("data/koala-on-tree.jpg");
  spout = new Spout(this);
  spout.setSenderName("Spout Utilities");
  
  cp5 = new ControlP5(this);
  CreateButtons();
  
} // end setup 


void draw()  { 

    background(0, 90, 100);
    noStroke();

    // Draw the rotating cube
    pushMatrix();
    translate(width/1.5, height/2.0, -100);
    rotateX(frameCount/120.0);
    rotateY(frameCount/120.0);      
    scale(140);
    TexturedCube(img);
    popMatrix();
    // Send at the size of the window    
    spout.sendTexture();
    
    // Display info
    text("Sending as : "
      + spout.getSenderName() + " ("
      + spout.getSenderWidth() + "x"
      + spout.getSenderHeight() + ")"
      + "  :  fps " + spout.getSenderFps()
      + "  :  frame " + spout.getSenderFrame(), 15, 25);

}

//
// About
//
// Practical example of an About box.
// Typically created using resources for Windows programs
//
public void About(int value) { 
  if (frameCount > 0 && value == 0) {
     cp5.getController("About").hide();
     String str = "Utility functions of the Spout library\n";
     str += "Examples can be tested here and the sketch provides example code.\n\n"; 
     str += "      spoutMessageBox\n";
     str += "          An enhanced ";
     str += "<a href=\"https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox\">MessageBox</a>";
     str += " using ";
     str += "<a href=\"https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect\">TaskDialogIndirect</a>\n";
     str += "          with additional options for position, modeless, timeout,\n";
     str += "          hyperlinks, instruction, user icon, user buttons, text entry\n";
     str += "          and combobox list selection controls.\n\n";
     str += "       Overload functions\n";
     str += "           spoutMessageBox(message)\n";
     str += "           spoutMessageBox(message, timeout)\n";
     str += "           spoutMessageBox(message, caption)\n";
     str += "           spoutMessageBox(message, caption, timeout)\n";
     str += "           spoutMessageBox(message, caption, type)\n";
     str += "           spoutMessageBox(message, caption, type, timeout)\n";
     str += "           spoutMessageBox(message, caption, type, instruction)\n";
     str += "           spoutMessageBox(message, caption, type, instruction, timeout)\n\n";
     str += "       Edit control\n";
     str += "           An edit control within the MessageBox\n";
     str += "           to enter text and return the entry.\n";
     str += "           with Caption, Message and existing text\n";
     str += "              String text = spoutEditBox(String caption)\n";
     str += "              String text = spoutEditBox(String caption, String Message)\n";
     str += "              String text = spoutEditBox(String caption, String Message, String text)\n\n";
     str += "       Combo box control\n";
     str += "            A combo box control within the MessageBox\n";
     str += "            to select from a list and return the selection index.\n";
     str += "            with Caption. Message and item list\n";
     str += "              int index = spoutComboBox(String caption, String[] items))\n";
     str += "              int index = spoutComboBox(String caption, String Message, String[] items))\n\n";
     str += "       Clipboard\n";
     str += "            Utility function to copy text to the clipboard\n";
     str += "              copyToClipBoard(String text);\n\n";
     str += "                                    <a href=\"https://spout.zeal.co\">https://spout.zeal.co</a>\n\n";
     String iconfile = sketchPath("data/Spout.ico");
     spout.spoutMessageBoxIcon(iconfile);
     spout.spoutMessageBox(str, "About", spout.MB_TOPMOST | spout.MB_OK, "SpoutUtils");
     cp5.getController("About").show();
  }
}

//
// Window position
//
// spoutMessageBox opens centred on the desktop by default.
// spoutMessageBoxWindow(true) centres on the sketch window.
// spoutMessageBoxWindow(false) centres on the desktop.
//
public void Position(int value) {
 
  if (frameCount > 0 && value == 0) {
    
    // Prevent repeats by "hiding" the button
    // The button does not disappear because the
    // messagebox is modal which stops the sketch
    // and prevents draw()
    cp5.getController("Position").hide();
    
    String str2 = "spoutMessageBox opens centred on the desktop by default.\n\n";
    str2 += "      spoutMessageBoxWindow(true) centres on the sketch window.\n";
    str2 += "      spoutMessageBoxWindow(false) centres on the desktop.\n\n";
    str2 += "Click \"Window\" to center messages on the sketch window\n";
    str2 += "Click \"Desktop\" to center on the desktop\n";
    str2 += "Click \"OK\" for no change\n\n";
    str2 += "If the sketch window is centred on the desktop now,\n";
    str2 += "move it to one side and the effect can be more easily seen.\n";
    spout.spoutMessageBoxButton(1000, "Window");
    spout.spoutMessageBoxButton(2000, "Desktop");
    int iret = spout.spoutMessageBox(str2, "Window", spout.MB_TOPMOST | spout.MB_OK);
    if(iret == 1000) { // Window centre
      spout.spoutMessageBoxWindow(true);
      spout.spoutMessageBox("Messages will be centred on the sketch window");
    }
    else if(iret == 2000) { // Desktop centre
      spout.spoutMessageBoxWindow(false);
      spout.spoutMessageBox("Messages will be centred on the  desktop");
    }
    cp5.getController("Position").show();
    
  }
}

//
// Simple messagebox with message
//
public void Simple(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Simple").hide();
    String str = "The simplest form of a MessageBox is :\n\n";
    str += "      spoutMessageBox(\"Simple messagebox\")\n\n";
    str += "Click OK to show this example\n";
    spout.spoutMessageBox(str, "Simple messagebox");
    spout.spoutMessageBox("Simple messagebox");
    cp5.getController("Simple").show();
  }
}

//
// MessageBox with message and caption
//
public void Caption(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Caption").hide();
    String str = "Add a caption to describe a longer message\n\n";
    str += "      spoutMessageBox(\"Longer message text\", \"Caption\")\n\n";
    str += "Click OK to show this example\n";
    spout.spoutMessageBox(str, "Message and caption");
    spout.spoutMessageBox("Longer message text", "Caption");
    cp5.getController("Caption").show();
  }
}

//
// Messagebox with message, caption, and milliseconds timeout
//
public void Timeout(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Timeout").hide();
    String str = "A timeout can be added to any of the spoutMessageBox functions\n\n";
    str += "spoutMessageBox(\"Message\", timeout)\n";
    str += "spoutMessageBox(\"Message\", \"Caption\", timeout)\n";
    str += "spoutMessageBox(\"Message\", \"Caption\", spout.MB_OK, timeout)\n";
    str += "spoutMessageBox(\"Message\", \"Caption\", spout.MB_OK, \"Instruction\", timeout)\n\n";
    str += "Timeout is in millseconds and disabled for any spoutMessageBox requiring user input.\n";
    str += "For this example, wait 10 seconds and the message will close.\n";
    spout.spoutMessageBox(str, "Timeout after 10 seconds", spout.MB_OK, "WAIT FOR 10 SECONDS", 10000);
    cp5.getController("Timeout").show();
  }
}

//
// MessageBox with message, caption and type (buttons and icon)
//
public void Options(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Options").hide();
    String str = "Enhanced Windows MessageBox using ";
    str += "<a href=\"https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-taskdialogindirect/\">TaskDialogIndirect</a>\n";
    str += "with message, caption, icon, type and edit and combobox controls\n\n";
    str += "\"Type\" is buttons and icon combined such as, in this case\n";
    str += "   \"MB_TOPMOST | MB_ICONWARNING | MB_YESNO\"\n\n";
    str += "Buttons, icons are defined in the spout library \"Spout\" class\n";
    str += "and are used with the object prefix. For example :\n";
    str += "      spout = new Spout(this);\n";
    str += "      spout.MB_OK, spout.MB_OKCANCEL, etc.\n\n";
    str += "   o Buttons\n";
    str += "       MB_OK\n";
    str += "       MB_OKCANCEL\n";
    str += "       MB_YESNOCANCEL\n";
    str += "       MB_YESNO\n\n";
    str += "   o Topmost\n";
    str += "       MB_TOPMOST\n\n";
    str += "   o Icon\n";
    str += "       MB_ICONERROR\n";
    str += "       MB_ICONWARNING\n";
    str += "       MB_ICONINFORMATION\n\n";
    str += "   o Return (button pressed)\n";
    str += "       IDOK\n";
    str += "       IDCANCEL\n";
    str += "       IDYES\n";
    str += "       IDNO\n\n";
    str += "In this example return is either IDYES, IDNO or IDCANCEL\n";
    str += "Click Yes or No to see the result.\n\n";
    int iRet = spout.spoutMessageBox(str, "Caption, message icon and type", spout.MB_TOPMOST | spout.MB_ICONWARNING | spout.MB_YESNOCANCEL);
    if(iRet == spout.IDYES) spout.spoutMessageBox("IDYES"); 
    if(iRet == spout.IDNO) spout.spoutMessageBox("IDNO");
  }
  cp5.getController("Options").show();
}

//
// MessageBox with message, caption, type, instruction
//
public void Instruction(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Instruction").hide();
    String str = "MessageBox with message, caption, type and instruction\n\n";
    str += "The main instruction is a special heading in large blue font\n";
    str += "above the message and is useful to draw attention to the content\n";
    str += "Use the long form of the MessageBox and include an instruction\n\n";
    str += "spout.spoutMessageBox(\"Message\", \"Caption\", spout.MB_OK, \"Instruction\")\n\n";
    spout.spoutMessageBox(str, "Main instruction", spout.MB_ICONINFORMATION | spout.MB_OK, "Instruction");
    cp5.getController("Instruction").show();
  }
}

//
// Custom icon
//
// A full path to an icon file (.ico) is required
//
public void Icon(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Icon").hide();
    String iconfile = sketchPath("data/Spout.ico");
    spout.spoutMessageBoxIcon(iconfile);
    String str = "A custom icon can be loaded from an icon \".ico\" image file:\n\n";
    str += "      String iconfile = sketchPath(\"data/Spout.ico\")\n";
    str += "      spout.spoutMessageBoxIcon(iconfile)\n";
    spout.spoutMessageBox(str, "Custom Icon");
    cp5.getController("Icon").show();
  }
}

//
// Custom buttons
//
// The button ID is returned by the messagebox
//
public void Buttons(int value) {
  if (frameCount > 0 && value == 0) {
    cp5.getController("Buttons").hide();
    String str = "As well as OK / CANCEL etc, multiple user buttons can be added.\n";
    str += "Each button has a unique ID and button text.\n";
    str += "The ID is returned and used to choose the required action.\n\n";
    str += "      spout.spoutMessageBoxButton(1000, \"Button 1\");\n";
    str += "      spout.spoutMessageBoxButton(2000, \"Button 2\");\n";
    str += "      spout.spoutMessageBoxButton(3000, \"Button 3\");\n";
    str += "      int iret = spout.spoutMessageBox(\"User button message\", \"Choose a button\");\n";
    str += "      if(iret == 1000) spout.spoutMessageBox(\"Button 1 pressed\");\n";
    str += "      if(iret == 2000) spout.spoutMessageBox(\"Button 2 pressed\");\n";
    str += "      if(iret == 3000) spout.spoutMessageBox(\"Button 3 pressed\");\n\n";
    str += "Choose a button\n";
    
    spout.spoutMessageBoxButton(1000, "Button 1");
    spout.spoutMessageBoxButton(2000, "Button 2");
    spout.spoutMessageBoxButton(3000, "Button 3");
    int iret = spout.spoutMessageBox(str, "User button message");
    if(iret == 1000) spout.spoutMessageBox("Button 1 pressed");
    if(iret == 2000) spout.spoutMessageBox("Button 2 pressed");
    if(iret == 3000) spout.spoutMessageBox("Button 3 pressed");
    
    cp5.getController("Buttons").show();
  }
}
 
 //
 // Edit control
 //
 public void Edit(int value) {
   if (frameCount > 0 && value == 0) {
     cp5.getController("Edit").hide();
     String str = "An edit control within the MessageBox can be used to enter text and return the entry.\n";
     str += "with Caption, Message and existing text in the edit control.\n\n";
     
     str += "   o Caption only\n";
     str += "      The edit control is in the message area\n";
     str += "           String str = spout.spoutEditBox(\"Text entry with caption\", null)\n\n";
     
     str += "   o Message with caption\n";
     str += "      The edit control is in the footer area\n";
     str += "           String str = spout.spoutEditBox(\"Enter text in the edit box below\", \"Caption\")\n\n";
     
     str += "   o Message with caption and existing text\n";
     str += "      The edit control is in the footer area\n";
     str += "      Existing text is shown in the edit control.\n";
     str += "           String editstr = \"Existing entry\"\n";
     str += "           String str = spout.spoutEditBox(\"Enter new text in the edit box below\", \"Caption\", editstr)\n\n";
     
     str += "   o Icon\n";
     str += "      Custom icons can be used with both caption and message with caption\n";
     str += "           String icofile = sketchPath(\"data/Spout.ico\");\n";
     str += "           spout.spoutMessageBoxIcon(icofile);\n";
     str += "           String str = spout.spoutEditBox(\"Text entry example with icon\", \"Icon example\", null)\n\n";

     str += "Select an option and repeat for more options\n";
     spout.spoutMessageBoxButton(1000, "Caption");
     spout.spoutMessageBoxButton(2000, "Message");
     spout.spoutMessageBoxButton(3000, "Existing");
     spout.spoutMessageBoxButton(4000, "Icon");
     int iret = spout.spoutMessageBox(str, "Edit control");
     String retstr;
     if(iret == 1000) {
       retstr = spout.spoutEditBox("Caption");
       if(!(retstr == null || retstr.isEmpty()))
         spout.spoutMessageBox(retstr, "Text entered");
     }
     if(iret == 2000) {
       retstr = spout.spoutEditBox("Enter text in the edit\ncontrol in the footer area\n", "Caption and Message");
       if(!(retstr == null || retstr.isEmpty()))
         spout.spoutMessageBox(retstr, "Text entered");
     }
     if(iret == 3000) {
       String editstr = "Existing text";
       retstr = spout.spoutEditBox("Enter some new text in the edit\ncontrol in the footer area\n", "Caption, Message and existing text", editstr);
       if(!(retstr == null || retstr.isEmpty()))
         spout.spoutMessageBox(retstr, "Text entered");
     }
     if(iret == 4000) {
       String icofile = sketchPath("data/Spout.ico");
       spout.spoutMessageBoxIcon(icofile);
       retstr = spout.spoutEditBox("Example of using a custom icon with text entry", "Icon example");
       if(!(retstr == null || retstr.isEmpty()))
         spout.spoutMessageBox(retstr, "Text entered");
     }
     cp5.getController("Edit").show();
   }
 }
 
//
// Combo box control with caption
// MessageBox with a combo box control for item selction,
// the selected item index is returned
//
public void ComboBox(int value) { 
  if (frameCount > 0 && value == 0) {
    cp5.getController("ComboBox").hide();
    String str = "A combo box control within the MessageBox can be used\nto select an item from a list and return the selection index.\n\n";
    str += "An array of strings is passed to fill the item list\n";
    str += "and the selected index is returned\n\n";
    str += "      String[] items = new String[3];\n";
    str += "      items[0] = \"Item 0\";\n";
    str += "      items[1] = \"Item 1\";\n";
    str += "      items[2] = \"Item 2\";\n";
    str += "      int selection = spout.spoutComboBox(\"Select an item\", items);\n\n";
    str += "Options are the same as for the Edit control\n";
    str += "Select an option and repeat for more\n";
    spout.spoutMessageBoxButton(1000, "Caption");
    spout.spoutMessageBoxButton(2000, "Message");
    spout.spoutMessageBoxButton(3000, "Icon");
    int iret = spout.spoutMessageBox(str, "Combo box control");
    int selection = 0;
    String[] items = new String[3];
    items[0] = "Item 0";
    items[1] = "Item 1";
    items[2] = "Item 2";
    if(iret == 1000) {
      selection = spout.spoutComboBox("Select an item", items);
      spout.spoutMessageBox(items[selection], "Selection");
    }
    if(iret == 2000) {
      selection = spout.spoutComboBox("This is a list of items\nSelect an item\nThe item index will be returned", "Select an item", items);
      spout.spoutMessageBox(items[selection], "Selection");
    }
    if(iret == 3000) {
      String icofile = sketchPath("data/Spout.ico");
      spout.spoutMessageBoxIcon(icofile);
      selection = spout.spoutComboBox("Combo box with user icon\nThis is a list of items\nSelect an item\nThe item index will be returned", "Select an item", items);
      spout.spoutMessageBox(items[selection], "Selection");
    }
    cp5.getController("ComboBox").show();
   }
}

//
// Modeless mode
//
// This transfers the message to another program
// "SpoutPanel.exe" so the dialog does not stop the sketch
// operation which continues after the messagebox is displayed
// and the messagebox remains until closed even if the sketch
// is closed first. Spout must have been installed and SpoutPanel
// or SpoutSettings run at least once.
// Modeless is disabled for any dialog requiring user input.
public void Modeless(int value) { 
  if (frameCount > 0 && value == 0) {
    // Do not "hide" the button here because
    // the messagebox does not stop the sketch
    // and it would be removed from display
    String str = "A MessageBox is normally modal and stops the sketch until closed.\n";
    str += "\"Modeless\" mode transfers the message to another program\n";
    str += "\"SpoutPanel.exe\" so the dialog does not stop the sketch operation.\n";
    str += "The MessageBox remains open even if the sketch is closed first.\n";
    str += "\"Modeless\" is disabled for any dialog requiring user input.\n\n";
    str += "       spoutMessageBoxModeless(true);\n";
    str += "       spoutMessageBoxModeless(false);\n\n";
    str += "This Message is modeless and all other controls can be used while it\n";
    str += "is open. Move it to one side and try them. Or even close the sketch.\n\n";
    str += "For this to work, you must have downloaded a <a href=\"https://github.com/leadedge/Spout2/releases/\">Spout release</a>\n";
    str += "and run SpoutPanel or SpoutSettings at least once.\n\n";
    
    spout.spoutMessageBoxModeless(true);
    // Make topmost so it does not get lost
    spout.spoutMessageBox(str, "Modeless message", spout.MB_TOPMOST | spout.MB_OK);
    spout.spoutMessageBoxModeless(false);
  }
}


//
// Hyperlink
//
// Hyperlinks can be included in the content using HTML format.
// For example : <a href=\"https://spout.zeal.co/\">Spout home page</a>
// Only double quotes are supported and must be escaped.
//
public void Hyperlink(int value) { 
  if (frameCount > 0 && value == 0) {
    cp5.getController("Hyperlink").hide();
    String str = "Hyperlinks can be included in the content using HTML format.\n\n";
    
    // Don't use this, it's modified to show up in the MessageBox as code
    str += "For example : \n";
    str += "      <a href=\\\"https://spout.zeal.co/\\\">Spout home page</a>\n";
    str += "Only double quotes are supported and must be escaped.\n\n";
    
    // This is the required format
    str += "This appears as  <a href=\"https://spout.zeal.co/\">Spout home page</a>.\n";
    
    str += "The MessageBox closes if the link is selected.\n\n";
    
    str += "Refer to the sketch source code for details.\n";
    spout.spoutMessageBox(str, "Hyperlink");
    cp5.getController("Hyperlink").show();
  }
}

//
// Clipboard
//
// Copy text to the clipboard
//
public void Clipboard(int value) { 
  if (frameCount > 0 && value == 0) {
    cp5.getController("Clipboard").hide();
    String str = "Text can be copied to the clipboard by using \n\n";
    str += "    copyToClipBoard(\"Text to be copied\")\n\n";;
    str += "Click OK to copy this message text to the clipboard\n";
    int iRet = spout.spoutMessageBox(str, "Clipboard", spout.MB_ICONINFORMATION | spout.MB_OKCANCEL);
    if(iRet == spout.IDOK) {
      spout.copyToClipBoard(str);
      spout.spoutMessageBox("Text copied to the clipbaord\nCheck by using a text editor and \"Ctrl-V\" or \"Edit > Paste\"");
    }
    cp5.getController("Clipboard").show();
  }
}


void CreateButtons()
{
  //
  // Create controlP5 buttons
  //
  cp5.addButton("About")       .setValue(0).setPosition(0,  40).setSize(240, 28).setColorBackground(color(128, 0, 0));
  cp5.addButton("Position")    .setValue(0).setPosition(0,  70).setSize(240, 28);  
  cp5.addButton("Simple")      .setValue(0).setPosition(0, 100).setSize(240, 28);   
  cp5.addButton("Caption")     .setValue(0).setPosition(0, 130).setSize(240, 28);
  cp5.addButton("Timeout")     .setValue(0).setPosition(0, 160).setSize(240, 28);
  cp5.addButton("Options")     .setValue(0).setPosition(0, 190).setSize(240, 28);
  cp5.addButton("Instruction") .setValue(0).setPosition(0, 220).setSize(240, 28);
  cp5.addButton("Icon")        .setValue(0).setPosition(0, 250).setSize(240, 28);
  cp5.addButton("Buttons")     .setValue(0).setPosition(0, 280).setSize(240, 28);
  cp5.addButton("Edit")        .setValue(0).setPosition(0, 310).setSize(240, 28);
  cp5.addButton("ComboBox")    .setValue(0).setPosition(0, 340).setSize(240, 28);
  cp5.addButton("Modeless")    .setValue(0).setPosition(0, 370).setSize(240, 28);
  cp5.addButton("Hyperlink")   .setValue(0).setPosition(0, 400).setSize(240, 28);
  cp5.addButton("Clipboard")   .setValue(0).setPosition(0, 430).setSize(240, 28);
  
  // Make the font larger
  PFont pfont = createFont("Arial", 20, true);
  ControlFont font = new ControlFont(pfont,30);  
  
  cp5.getController("About")       .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Position")    .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Simple")      .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Caption")     .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Timeout")     .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Options")     .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Instruction") .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Icon")        .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Buttons")     .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Edit")        .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("ComboBox")    .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Modeless")    .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Hyperlink")   .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
  cp5.getController("Clipboard")   .getCaptionLabel().setFont(font).toUpperCase(false).setSize(18);
    
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

    
