public class Orbit {
  public float length;
  public color col;
  public int radius;
  public float dt;
  float initial;
  public boolean ready;
  public float speed;

  public Orbit(float length, color col, int radius, float dt, float speed) { 
    this.length = length;
    this.col = col;
    this.radius = radius;
    this.dt = dt;
    this.initial = dt;
    this.speed = speed;
  }

  public void update(float t) {
    dt += (t * speed);
  }

  public void draw(PGraphics image) {
    image.fill(0);
    if (dt - initial >= length) image.ellipse(cos(dt - length) * radius, sin(dt - length) * radius, 25 + (radius/50), 25 + (radius/50));
    image.fill(col);
    image.ellipse(cos(dt) * radius, sin(dt) * radius, 25, 25);
    if (dt - initial >= length) image.ellipse(cos(dt + .016 - length) * radius, sin(dt + .016 - length) * radius, 25, 25);
  }
}

public class OrbitScene implements Scene {

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  final int SPREAD = 100;

  int n;
  float[] dt_offsets;
  float dt;
  color[] colors;

  Orbit[] orbits;
  PGraphics image;
  public boolean isTitle;

  public OrbitScene(int n, boolean isTitle) {
    this.isTitle = isTitle;
    image = createGraphics(width, height);
    this.n = n;
    orbits = new Orbit[n];
    
    restart();
    for (int i = 0; i < 500; i++) { 
      update(16); 
      draw();
    }
  }

  public void update(long dt) {
    float t = dt / 1000f;

    for (Orbit o : orbits) {
      o.update(t);
    }
    this.dt += t;
  }

  public void restart() {
    randomSeed(2);
    dt = 0;
    for (int i = 0; i < n; i++) {
      orbits[i] = new Orbit(random(1, 5), RAND_COLOR(), (i + 1) * 50, random(TWO_PI), random(0.2, 0.45));
    }

    image.beginDraw();
    image.background(0);
    image.endDraw();
  }

  public void draw() {
    image.beginDraw();
    image.noStroke();

    image.pushMatrix();
    image.translate(width / 2, (height / 2) + (isTitle ? 100 : 0));

    image.noStroke();
    for (int i = 0; i < n; i++) {
      orbits[i].draw(image);
    }

    image.popMatrix();
    image.endDraw();
  }


  public PGraphics getImage() {
    return image;
  }

  boolean preUpdate() { 
    return false;
  }
  float fadeInTime() { 
    if (isTitle) return 19000;
    else return 0;
  }
  float fadeOutTime() { 
    if (isTitle) return 0;
    else return 7500;
  }
  long length() { 
    return 19250;
  }
}
