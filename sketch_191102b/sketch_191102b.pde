/**
 * sorts a given colour palette by saturation
 * @param cols array of integers in standard packed (A)RGB format
 * @return sorted version of array with element at last index
 * containing the most saturated item of the palette
 */
 
import java.util.Hashtable;
 
PImage img;
int[] colsRGB = new int[1080];
int[] colsRGBsorted = new int[1080];

int sortixMode = 1; // 1 SATURATION 2 LUMINANCIA 3 PROXIMITY
boolean bgray = false;

void setup(){
  size(2560, 1080);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  //noCursor();
  img = loadImage("./../VIDEOS/crash1.jpg");
  img.resize(width,height);
}


void draw(){
  int tileCount = width / max(mouseX, 5);
  float rectSize = width / float(tileCount);
  
  // data in
  for (int gridX=0; gridX<tileCount; gridX++) {
    for(int y=0; y<height; y++){
      colsRGB[y] = img.get(gridX,y);
    }
    if(sortixMode == 1){
      colsRGBsorted = sortBySaturation(colsRGB);
    }
    else if(sortixMode == 2){
      colsRGBsorted = sortByLuminance(colsRGB);
    }
    else if(sortixMode == 3){
      colsRGBsorted = sortByProximity(colsRGB, (int)(random(0,300)));
    }
    for(int y=0; y<height; y++){
      fill(colsRGBsorted[y]);
      rect(gridX*rectSize, y, rectSize, 1);
    }
  }
  if(bgray){
    filter(GRAY);
  }

}

void keyPressed(){
  if(key == '1'){
    sortixMode = 1;
  }
  else if(key == '2'){
    sortixMode = 2;
  }
  else if(key == '3'){
    sortixMode = 3;
  }
  else if(key == 'g'){
    bgray = !bgray;
  }
}
 
int[] sortBySaturation(int[] cols) {
  int[] sorted=new int[cols.length];
  Hashtable ht=new Hashtable();
  for(int i=0; i<cols.length; i++) {
    int r=(cols[i]>>16) & 0xff;
    int g=(cols[i]>>8) & 0xff;
    int b=cols[i] & 0xff;
    int maxComp = max(r,g,b);
    if (maxComp > 0) {
      sorted[i]=(int)((maxComp - min(r,g,b)) / (float)maxComp * 0x7fffffff);
    } 
    else
      sorted[i]=0;
    ht.put(new Integer(sorted[i]),new Integer(cols[i]));
  }
  sorted=sort(sorted);
  for(int i=0; i<sorted.length; i++) {
    sorted[i]=((Integer)ht.get(new Integer(sorted[i]))).intValue();
  }
  return sorted;
}

/**
 * sorts a given colour palette by luminance
 * @param cols array of integers in standard packed (A)RGB format
 * @return sorted version of array with element at last index
 * containing the "brightest" item of the palette
 */

int[] sortByLuminance(int[] cols) {
  int[] sorted=new int[cols.length];
  Hashtable ht=new Hashtable();
  for(int i=0; i<cols.length; i++) {
    // luminance = 0.3*red + 0.59*green + 0.11*blue
    // same equation in fixed point math...
    sorted[i]=(77*(cols[i]>>16&0xff) + 151*(cols[i]>>8&0xff) + 28*(cols[i]&0xff));
    ht.put(new Integer(sorted[i]),new Integer(cols[i]));
  }
  sorted=sort(sorted);
  for(int i=0; i<sorted.length; i++) {
    sorted[i]=((Integer)ht.get(new Integer(sorted[i]))).intValue();
  }
  return sorted;
}

/**
 * sorts a given colour palette by proximity to a colour
 * @param cols array of integers in standard packed (A)RGB format
 * @param basecol colour to which proximity of all palette items is calculated
 * @return sorted version of array with element at first index
 * containing the "closest" item of the palette
 */

int[] sortByProximity(int[] cols,int basecol) {
  int[] sorted=new int[cols.length];
  Hashtable ht=new Hashtable();
  int br=(basecol>>16) & 0xff;
  int bg=(basecol>>8) & 0xff;
  int bb=basecol & 0xff;
  for(int i=0; i<cols.length; i++) {
    int r=(cols[i]>>16) & 0xff;
    int g=(cols[i]>>8) & 0xff;
    int b=cols[i] & 0xff;
    sorted[i]=(br-r)*(br-r)+(bg-g)*(bg-g)+(bb-b)*(bb-b);
    ht.put(new Integer(sorted[i]),new Integer(cols[i]));
  }
  sorted=sort(sorted);
  for(int i=0; i<sorted.length; i++) {
    sorted[i]=((Integer)ht.get(new Integer(sorted[i]))).intValue();
  }
  return sorted;
}