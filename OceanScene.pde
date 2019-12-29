public class Seaweed {

  int x;
  color col;
  int length;
  int o;
  float[] Y;

  public Seaweed(int x, int length, color col) {
    this.col = col;
    this.x = x;
    this.length = length;
    o = 0;
    Y = new float[length];
  }

  public void update() {
    o++;
    for (int i = o; i < o + length; i++) {
      Y[i - o] = 20 * sin(0.02 * i);
    }
  }

  public void draw(PGraphics image) {
    image.fill(col);
    for (int i = 0; i < Y.length; i++) image.ellipse(Y[i] + x - Y[0], height - i, 25, 25);
  }
}

public class OceanDot {
  public PVector pos;
  float angle;
  long t;
  boolean left;
  color col;

  public float getNewAngle() {
    float angle = random(PI/4f) - PI/8f;
    if (left) angle += PI;
    return angle;
  }

  public OceanDot(PVector pos, boolean left, color col) {
    this.pos = pos;
    this.left = left;
    this.angle = getNewAngle();
    this.t = 0;
    this.col = col;
  }

  public void update(long dt) {
    t += dt;
    float dtf = dt / 1000f;
    if (t > 3000) {
      t = 0;
      angle = getNewAngle();
    }
    pos.add(new PVector(50 * cos(angle), 50 * sin(angle)).mult(dtf));
  }

  public void draw(PGraphics image) {
    image.fill(col);
    image.ellipse(pos.x, pos.y, 25, 25);
  }
}

public class OceanScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }
  color RAND_COLOR(int alpha) {
    return color(random(120, 150), random(120, 150), random (120, 150), alpha);
  }


  Seaweed[] w;
  ArrayList<OceanDot> dotsBehind;
  ArrayList<OceanDot> dotsInfront;

  public OceanScene() {
    randomSeed(2);
    image = createGraphics(width, height);

    w = new Seaweed[] {
      new Seaweed(400, 600, RAND_COLOR()), 
      new Seaweed(550, 350, RAND_COLOR()), 
      new Seaweed(1750, 850, RAND_COLOR()), 
      new Seaweed(1500, 500, RAND_COLOR())
    };
    dotsBehind = new ArrayList<OceanDot>();
    dotsInfront = new ArrayList<OceanDot>();
    for (int i = 0; i < 50; i++) {
      dotsBehind.add(new OceanDot(new PVector(random(width + 100) - 50, random(height + 100) - 50), true, RAND_COLOR(128)));
      dotsInfront.add(new OceanDot(new PVector(random(width + 100) - 50, random(height + 100) - 50), false, RAND_COLOR(128)));
    }
  }

  public void update(long dt) {
    for (int i = 0; i < dotsBehind.size(); i++) { dotsBehind.get(i).update(dt); dotsInfront.get(i).update(dt); }
    for (int i = 0; i < w.length; i++) w[i].update();
  }

  public void draw() {
    image.beginDraw();
    image.background(0);
    image.noStroke();

    for (OceanDot d : dotsBehind) d.draw(image);
    for (int i = 0; i < w.length; i++) w[i].draw(image);
    for (OceanDot d : dotsInfront) d.draw(image);

    image.endDraw();
  }

  boolean preUpdate() { 
    return false;
  }
  float fadeInTime() { 
    return 0;
  }
  float fadeOutTime() { 
    return 0;
  }
  long length() { 
    return 19250;
  }
}
