public class Toss {
  public PVector old;
  public PVector pos;
  public PVector vel;
  public color col;

  public Toss(PVector pos, PVector vel, color col) {
    this.pos = pos;
    this.vel = vel;
    this.col = col;
  }
}

public class TossesScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  ArrayList<Toss> balls;
  long t;
  long next;
  final int BALL_INTERVAL = 100;
  final PVector GRAVITY = new PVector(0, 5);

  public TossesScene() {
    image = createGraphics(width, height);
    balls = new ArrayList<Toss>();
    t = 0;
    next = 0;
  }

  public void update(long dt) {
    t += (dt/2);
    float dtf = dt / 1000f;
    if (t > next) {
      next += BALL_INTERVAL;
      PVector rPos;
      PVector rVel;
      if (random(1) > 0.5) { // go right
        rPos = new PVector(random(width/2), height + 50);
        rVel = new PVector(random(10, 30), random(40, 60) * -1);
      } else {
        rPos = new PVector(random(width/2, width), height + 50);
        rVel = new PVector(random(10, 30) * -1, random(40, 60) * -1);
      }
      rVel.mult(dtf).mult(100);
      balls.add(new Toss(rPos, rVel, RAND_COLOR()));
    }

    for (Toss t : balls) {
      t.old = new PVector(t.pos.x, t.pos.y);
      t.vel.add(GRAVITY);
      t.pos.add(t.vel);
    }
  }

  public void draw() {
    image.beginDraw();
    //image.background(0);
    image.noStroke();
    image.fill(0, 0, 0, 25);
    image.rect(0, 0, width, height);
    image.strokeWeight(50);
    for (Toss t : balls) {
      image.fill(t.col);
      image.stroke(t.col);
      image.line(t.old.x, t.old.y, t.pos.x, t.pos.y);
      //image.ellipse(t.pos.x, t.pos.y, 25, 25);
    }

    image.endDraw();
  }

  boolean preUpdate() { 
    return true;
  }
  float fadeInTime() { 
    return 0;
  }
  float fadeOutTime() { 
    return 0;
  }
  long length() {
    return 9600;
  }
}
