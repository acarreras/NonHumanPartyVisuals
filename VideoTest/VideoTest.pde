import themidibus.*; 
import processing.video.*;
import generativedesign.*;

Movie myMovie;
color[] colors;
color[] colors2;
float videoW;
float videoH;
boolean bfirstFrame = true;

//noise
float nStep=0.1;
float noise1=0;

String sortMode = null;

// midi
MidiBus myBus;
int minMedidaTiles = 5;
int medidaTiles = minMedidaTiles;
int textSize1 = 12;
int amountTextSize1 = 0;
int textSize2 = 12;
int amountTextSize2 = 0;
float alphaFondo = 255;

void setup() {
  size(2560, 1080);
  // MOVIE
  //myMovie = new Movie(this, "../../VIDEOS/CTD1.mov"); // windows
  myMovie = new Movie(this, "station.mov"); // ubuntu
  //myMovie.play();
  myMovie.loop();
  
  // SETTINGS
  noStroke();
  //noCursor();
  
  // MIDI
  MidiBus.list();
  myBus = new MidiBus(this, 0, -1);
}

void draw() {
  // FONDO
  //background(0);
  //image(myMovie, 0, 0);
  fill(0,0,0,alphaFondo);
  noStroke();
  rect(0,0,width,height);
  
  // COLORES 1
  int tileCount =(int) videoW/ max(medidaTiles, minMedidaTiles);
  float rectSizeX1 = videoW / float(tileCount);
  float rectSizeY1 = videoH / float(tileCount);
  //int tileCount =(int) width / max(mouseX, 5);
  //float rectSize = height / float(tileCount);
  
  // get colors from image
  int i = 0; 
  colors = new color[tileCount*tileCount];
  //image(myMovie, 0, 0);
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      int px = (int) (gridX * rectSizeX1);
      int py = (int) (gridY * rectSizeY1);
      //colors[i] = img.get(px, py);
      colors[i] = myMovie.get(px, py);
      i++;
    }
  }
  noise1+=nStep;
  //int tileCount2 =(int)(tileCount/2);//(int)(noise(noise1)*2+1)
  int tileCount2 =(int)(tileCount/(noise(noise1)*2+1));
  float rectSizeX2 = videoW / float(tileCount2);
  float rectSizeY2 = videoH / float(tileCount2);
  int j = 0; 
  colors2 = new color[tileCount2*tileCount2];
  for (int gridY=0; gridY<tileCount2; gridY++) {
    for (int gridX=0; gridX<tileCount2; gridX++) {
      int px = (int) (gridX * rectSizeX2);
      int py = (int) (gridY * rectSizeY2);
      //colors[i] = img.get(px, py);
      colors2[j] = myMovie.get(px, py);
      j++;
    }
  }
  
  // sort colors
  if (sortMode != null) colors = GenerativeDesign.sortColors(this, colors, sortMode);
  

  // draw grid
  i = 0;
  //BUCLE1
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      fill(colors[i]);
      
      String s=str(colors[i]);
      stroke(colors[i]);
      textSize1 = (int)(rectSizeY1 + amountTextSize1);
      textSize(textSize1);
      int posX=(int)map(gridX*rectSizeX1,0,videoW,0,width);
      int posY=(int)map(gridY*rectSizeY1,0,videoH,0,height);
      //rect(gridX*rectSizeX1, gridY*rectSizeY1, rectSizeX1, rectSizeY1);
     // text(s,gridX*rectSize, gridY*rectSize);
      text(s,posX, posY);
      i++;
    }
  }
  //BUCLE 2
  int r,g,b;
  j=0;
  for (int gridY=0; gridY<tileCount2; gridY++) {
    for (int gridX=0; gridX<tileCount2; gridX++) {
      String s=str(colors2[j]);
      r=(int)red(colors2[j]);
     // r=(int)map(r,0,255,255,0);
      g=(int)green(colors2[j]);
     // g=(int)map(g,0,255,255,0);
      b=(int)blue(colors2[j]);
      //b=(int)map(b,0,255,255,0);
      colors2[j]= color(r,g,b);
      stroke(colors2[j]);
      fill(colors2[j]);
      float n = (int)(rectSizeY2*(noise(noise1)*2+0.1));
      textSize2 = (int)(rectSizeY2 + amountTextSize2);
      textSize(textSize2);
      //textSize((int)(rectSizeY2*(noise(noise1)*2+0.1)));
      int posX=(int)map(gridX*rectSizeX2,0,videoW,0,width);
      int posY=(int)map(gridY*rectSizeY2,0,videoH,0,height);
      //rect(gridX*rectSizeX2, gridY*rectSizeY2, rectSizeX2, rectSizeY2);
     // text(s,gridX*rectSize, gridY*rectSize);
      text(s,posX, posY);
      j++;
    }
  }
}
void keyReleased(){
 // if (key=='c' || key=='C') GenerativeDesign.saveASE(this, colors, timestamp()+".ase");
 // if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  //if (key=='p' || key=='P') savePDF = true;

  //if (key == '1') img = loadImage("pic1.jpg");
  //if (key == '2') img = loadImage("pic2.jpg"); 
  //if (key == '3') img = loadImage("pic3.jpg"); 

  if (key == '4') sortMode = null;
  if (key == '5') sortMode = GenerativeDesign.HUE;
  if (key == '6') sortMode = GenerativeDesign.SATURATION;
  if (key == '7') sortMode = GenerativeDesign.BRIGHTNESS;
  if (key == '8') sortMode = GenerativeDesign.GRAYSCALE;
}
 
void movieEvent(Movie m) {
  m.read();
  
  if(bfirstFrame){
    videoW=myMovie.width;
    videoH=myMovie.height;
    println("Video Width: "+videoW);
    bfirstFrame = false;
  }
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println("channel: " + channel);
  println(" number: " + number);
  println(" value: " + value);
  
  if(number == 16){
    medidaTiles = (int)map(value, 0,127, minMedidaTiles, 500);
  }
  else if(number == 32){
    textAlign(LEFT, BOTTOM);
  }
  else if(number == 33){
    textAlign(CENTER, CENTER);
  }
  else if(number == 0){
    amountTextSize1 = (int)map(value, 0,127, 0, 160);
  }
  else if(number == 1){
    amountTextSize2 = (int)map(value, 0,127, 0, 160);
  }
  else if(number == 17){
    alphaFondo = map(value, 0,127, 0, 255);
  }

}