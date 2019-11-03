import themidibus.*; 
import processing.video.*;
import generativedesign.*;
import oscP5.*;
import netP5.*;

Movie myMovie;
String[] movies;
color[] colors;
color[] colors2;
float videoW;
float videoH;
boolean bfirstFrame = true;
int alpha=20;
PFont myFont;
int soundReceived=1;
int compas=0;
//noise
float nStep=0.1;
float noise1=0;

String sortMode = null;

//osc
OscP5 oscP5;
NetAddress myRemoteLocation;

// midi
MidiBus myBus;

void setup() {
  size(5120, 1080);
  // MOVIE
  movies= new String[6];
  movies[0] =  "../../VIDEOS/toro1.mov";
  movies[1] = "../../VIDEOS/CTD1.mov";
  movies[2] = "../../VIDEOS/gatohumano.mov";
  movies[3] = "../../VIDEOS/tie_shoes.mp4";
  movies[4] = "../../VIDEOS/robotojos.mov";
  movies[5] = "http://192.168.0.190:8080/?action=stream";
  
  
  myMovie=new Movie(this, movies[0]);
  myMovie.play();
  myMovie.loop();
  
  // SETTINGS
  noStroke();
  //noCursor();
  oscP5 = new OscP5(this,8001);
  
  // MIDI
  MidiBus.list();
  myBus = new MidiBus(this, 0, -1);
  
  myFont = createFont("./../FONT/Raleway-SemiBold.ttf", 32);
  textFont(myFont);
  textSize(32);
  textAlign(CENTER, CENTER);
}

void draw() {
  
  //background(0);
  //image(myMovie, 0, 0);
  int tileCount =(int) videoW/ max(mouseX, 15);
  float rectSizeX1 = videoW / float(tileCount);
  float rectSizeY1 = videoH / float(tileCount);
  //int tileCount =(int) width / max(mouseX, 5);
  //float rectSize = height / float(tileCount);
  textAlign(CENTER,CENTER);

  // get colors from image
  int i = 0; 
  colors = new color[tileCount*tileCount];
  
  //image(myMovie, 0, 0);
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      int px = (int) (gridX * rectSizeX1);
      int py = (int) (gridY * rectSizeY1);
      //colors[i] = i.get(px, py);
      colors[i] = myMovie.get(px, py);
      i++;
    }
  }
  noise1+=nStep;
  //int tileCount2 =(int)(tileCount/2);//(int)(noise(noise1)*2+1)
  //int tileCount2 =(int)(tileCount/(noise(noise1)*2+1));
  soundReceived=(int)map(soundReceived,0,36,5,10);
  int tileCount2 =(int)(tileCount/soundReceived);
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
      textSize(rectSizeY1);
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
      textSize((int)(rectSizeY2*(noise(noise1)*2+0.1)));
      int posX=(int)map(gridX*rectSizeX2,0,videoW,0,width);
      int posY=(int)map(gridY*rectSizeY2,0,videoH,0,height);
      //rect(gridX*rectSizeX2, gridY*rectSizeY2, rectSizeX2, rectSizeY2);
     // text(s,gridX*rectSize, gridY*rectSize);
      text(s,posX, posY);
      j++;
    }
  }
  fill(0,alpha);
  rect(0,0,width,height);
}

void keyReleased(){
 // if (key=='c' || key=='C') GenerativeDesign.saveASE(this, colors, timestamp()+".ase");
 // if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  //if (key=='p' || key=='P') savePDF = true;

  if (key == '1') changeVideo(0);
  if (key == '2') changeVideo(1); 
  if (key == '3') changeVideo(2); 
  if (key == '4') changeVideo(3); 
  if (key == '5') changeVideo(4); 
  if (key == '6') changeVideo(5);
  if (key == '7') sortMode = null;
  if (key == '8') sortMode = GenerativeDesign.HUE;
  if (key == '9') sortMode = GenerativeDesign.SATURATION;
  if (key == '0') sortMode = GenerativeDesign.BRIGHTNESS;
  if (key == '-') sortMode = GenerativeDesign.GRAYSCALE;
  if (key == 'q') alpha++;println("Alpha: "+alpha);
  if (key == 'a') alpha--;println("Alpha: "+alpha);
  if (key == 'w') alpha+=10;println("Alpha: "+alpha);
  if (key == 's') alpha-=10;println("Alpha: "+alpha);
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
void changeVideo(int v){
  //int r=(int)random(0,2);
  println("CHANGE VIDEO: "+v+" name"+myMovie.filename);
  //myMovie.stop();
  myMovie=new Movie(this,movies[v]);
  myMovie.play();
  myMovie.loop();
  bfirstFrame = true;
}
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println("channel: " + channel);
  println(" number: " + number);
  println(" value: " + value);
}
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  if(theOscMessage.checkAddrPattern("/sound")==true) {
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());
    soundReceived=theOscMessage.get(0).intValue();
    println(" Value: "+soundReceived);
  }
  if(compas==0){
    changeVideo((int)random(0,4));
    compas++;
    compas=compas%8;
  }
}
