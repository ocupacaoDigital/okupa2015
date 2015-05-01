import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val = "";


void setup() 
{
  size(300, 150);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  textAlign(CENTER, CENTER);
  textSize(48);
  fill(#D6AA09);
  noLoop();
}

void draw() {
  background(#D60924);
  text(val, width/2, height/2);
}

void keyPressed() {

  if (keyCode == ENTER) {
    val += '\n';
    myPort.write(val);
    val = "";
  } else if (keyCode == BACKSPACE) {
    val = val.substring(0, val.length() - 1);
  } else if (key >= '0' && key <= '9') {
    val += key;
  }
  redraw();
}

