import processing.video.Capture;

Capture video;

PImage prevFrame;
 
float threshold = 50;

float avgX, avgY;

void setup() {
  size(600,400);
  video = new Capture(this, 640, 480,30);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);
  image(video, 0, 0);
  video.loadPixels();
  prevFrame.loadPixels();
}

  float sumX = 0;
  float sumY = 0;
  int motionCount = 0;