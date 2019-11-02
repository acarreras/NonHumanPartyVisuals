  
import processing.video.*;
import generativedesign.*;
Movie myMovie;
color[] colors;
color[] colors2;
float videoW;
float videoH;

String sortMode = null;

void setup() {
  size(2560, 1080);
  myMovie = new Movie(this, "CTD1.mov");
  myMovie.play();
  myMovie.loop();
  noStroke();
  noCursor();
  
}

void draw() {
  videoW=myMovie.width;
  videoH=myMovie.height;
  println("Video Width: "+videoW);
  //background(0);
  //image(myMovie, 0, 0);
  int tileCount =(int) videoW/ max(mouseX, 5);
  float rectSizeX1 = videoW / float(tileCount);
  float rectSizeY1 = videoH / float(tileCount);
  //int tileCount =(int) width / max(mouseX, 5);
  //float rectSize = height / float(tileCount);

  // get colors from image
  int i = 0; 
  colors = new color[tileCount*tileCount];
  image(myMovie, 0, 0);
  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      int px = (int) (gridX * rectSizeX1);
      int py = (int) (gridY * rectSizeY1);
      //colors[i] = img.get(px, py);
      colors[i] = get(px, py);
      i++;
    }
  }
  int tileCount2 =tileCount/2;
  float rectSizeX2 = videoW / float(tileCount2);
  float rectSizeY2 = videoH / float(tileCount2);
  int j = 0; 
  colors2 = new color[tileCount2*tileCount2];
  for (int gridY=0; gridY<tileCount2; gridY++) {
    for (int gridX=0; gridX<tileCount2; gridX++) {
      int px = (int) (gridX * rectSizeX2);
      int py = (int) (gridY * rectSizeY2);
      //colors[i] = img.get(px, py);
      colors2[j] = get(px, py);
      j++;
    }
  }
  background(0);
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
      r=(int)map(r,0,255,255,0);
      g=(int)green(colors2[j]);
      g=(int)map(g,0,255,255,0);
      b=(int)blue(colors2[j]);
      b=(int)map(b,0,255,255,0);
      colors2[j]= color(r,g,b);
      stroke(colors2[j]);
      fill(colors2[j]);
      textSize(rectSizeY2);
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
}
