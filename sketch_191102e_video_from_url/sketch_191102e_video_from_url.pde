import processing.video.*;
Movie mov;

void setup() {
  size(800, 360);

  //mov = new Movie(this, "http://www.hackdiary.com/misc/Utopia-Ep-1.mov"); // working
  mov = new Movie(this, "http://192.168.0.189:8080/?action=stream");
  mov.play();
}

void draw() {
  background(255);
  image(mov, 0, 0);
}


void movieEvent(Movie m) {
  m.read();
}