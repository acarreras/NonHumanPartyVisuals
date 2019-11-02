/**
 * extract and sort the color palette of an image
 *    
 * MOUSE
 * position x          : resolution
 * 
 * KEYS
 * 1-3                 : load different images
 * 4                   : no color sorting
 * 5                   : sort colors on hue
 * 6                   : sort colors on saturation
 * 7                   : sort colors on brightness
 * 8                   : sort colors on grayscale (luminance)
 * s                   : save png
 * p                   : save pdf
 * c                   : save color palette
 */

import generativedesign.*;

boolean savePDF = false;

PImage img;
color[] colors;

String sortMode = null;

void setup(){
  size(2560, 1080);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  //noCursor();
  img = loadImage("./../CRASH_DUMMY/crash1.jpg");
  img.resize(width,height);
}


void draw(){
  background(0);
  int tileCount = width / max(mouseX, 5);
  float rectSize = width / float(tileCount);

  // get colors from image
  int i = 0; 
  colors = new color[tileCount*tileCount];
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      int px = (int) (gridX * rectSize);
      int py = (int) (gridY * rectSize);
      colors[i] = img.get(px, py);
      i++;
    }
  }

  // sort colors
  if (sortMode != null) colors = GenerativeDesign.sortColors(this, colors, sortMode);
  

  // draw grid
  i = 0;
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      fill(colors[i]);
      String s = str(colors[i]);
      text(s,gridX*rectSize, gridY*rectSize, rectSize, rectSize);
      i++;
    }
  }
  
}


void keyReleased(){
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  
  if (key == '1') img = loadImage("./../CRASH_DUMMY/crash1.jpg");
  if (key == '2') img = loadImage("./../CRASH_DUMMY/crash2.jpg"); 
  if (key == '3') img = loadImage("./../CRASH_DUMMY/crash3.jpg"); 

  if (key == '4') sortMode = null;
  if (key == '5') sortMode = GenerativeDesign.HUE;
  if (key == '6') sortMode = GenerativeDesign.SATURATION;
  if (key == '7') sortMode = GenerativeDesign.BRIGHTNESS;
  if (key == '8') sortMode = GenerativeDesign.GRAYSCALE;
}


// timestamp
String timestamp() {
  return String.format("NHP_" + hour()+"_"+minute()+"_"+second()+"_"+millis()+".jpg");
}