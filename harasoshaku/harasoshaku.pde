import netP5.*;
import oscP5.*;

import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

final static int NON = 0;
final static int SENBEI = 1;
final static int RINGO = 2;
final static int NIKU = 3;

final static int AIN1 = 11;
final static int AIN2 = 10;
final static int PWMA = 9;

final int SENSOR_VALUE_NORMAL = 660;
final int SENSOR_VALUE_FORWARD = 620;
final int SENSOR_VALUE_FORWARD_MAX = 560;

final int TABEMONOSENSOR = 0;
final int X = 3;
final int Y = 4;
final int Z = 5;

final int SENBEI_SENSOR = 0;
final int RINGO_SENSOR = 1;
final int NIKU_SENSOR = 2;

int TABEMONO = 0;

Senbei senbei;
Ringo ringo;
Niku niku;

Arduino arduino;
Arduino arduino2;
OscP5 osc;
NetAddress myRemoteLocation;

float x, y, z;
float power;

void setup()
{
  size(500, 500);

  arduino = new Arduino(this, "/dev/cu.usbserial-14P54747");
  //arduino2 for sensor
  //arduino2 = new Arduino(this,"");
  osc = new OscP5(this, 1234);
  myRemoteLocation = new NetAddress("127.0.0.1", 9800);

  senbei = new Senbei(arduino, osc, myRemoteLocation);
  ringo = new Ringo(arduino, osc, myRemoteLocation);
  niku = new Niku(arduino, osc, myRemoteLocation);
}

void draw()
{
  if (isEating())
  {
    x = arduino.analogRead(X);
    y = arduino.analogRead(Y);
    z = arduino.analogRead(Z);
    println("x=" + x, "y="+ y, "z="+ z);

    whichTabemono();
    if (z < SENSOR_VALUE_FORWARD)
    { 
      power = SENSOR_VALUE_FORWARD_MAX < z ? 1 : (SENSOR_VALUE_FORWARD_MAX - z) / (SENSOR_VALUE_FORWARD_MAX - SENSOR_VALUE_FORWARD);
      sosyaku(power);
    }
  }
}

boolean isEating()
{
  return true;
}

int whichTabemono()//akarusa sensing
{

  return NON;
}

void sosyaku(float power)
{
  //switch(whichTabemono())
  switch(TABEMONO)
  {
  case NON:
    senbei.init();
    ringo.init();
    niku.init();
    break;
  case SENBEI:
    senbei.sosyaku(power);
    break;
  case RINGO:
    ringo.sosyaku(power);
    break;
  case NIKU:
    niku.sosyaku(power);
    break;
  default:
    println("[sosyaku]error");
    break;
  }
}

void keyPressed()
{
  if (key == 'a')
  {
    TABEMONO = SENBEI;
    background(255, 0, 0);
  } else {
    TABEMONO = NON;
    background(0, 0, 0);
  }
}