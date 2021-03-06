import processing.video.*;
 
Capture video;
 
PImage prevFrame;
 
float threshold = 50;

float avgX, avgY;
 
void setup() {
  size(600,400);
  video = new Capture(this, 640, 480,30);
  video.start();
  ps = new ParticleSystem(new PVector(width/2, 50));
  prevFrame = createImage(video.width, video.height, RGB);
  minim = new Minim(this);
  player = minim.loadFile("sandstorm.mp3", 2048);
  player.play();
}
 
void captureEvent(Capture video) {
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();
  video.read();
}
 
void draw() {
  background(0);
  image(video, 0, 0);
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
 
  float sumX = 0;
  float sumY = 0;
  int motionCount = 0;
 
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      color current = video.pixels[x+y*video.width];
 
      color previous = prevFrame.pixels[x+y*video.width];
 
      float r1 = red(current);
      float g1 = green(current);
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous);
      float b2 = blue(previous);
 
      float diff = dist(r1, g1, b1, r2, g2, b2);
 
      if (diff > threshold){
        sumX += x;
        sumY += y;
        motionCount ++;
      }
    }
  }
 
  avgX = sumX / motionCount;
  avgY = sumY / motionCount;
  
  ps.addParticle(new PVector(avgX, avgY));
  ps.run();
 
 
  smooth();
  noStroke();
}
 
  ParticleSystem ps;
 
 
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
 
  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }
 
  void addParticle(PVector pos) {
    particles.add(new Particle(pos));
  }
 
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
 
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
 
  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 255.0;
  }
 
  void run() {
    update();
    display();
  }
 
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }
 
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }
 
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}