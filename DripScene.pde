public class Icicle {

  int length;
  color col;
  float speed;
  int x;
  float tDelay;

  PVector drip;

  public Icicle(int length, color col, float speed, float tDelay, int x) {
    this.length = length + floor(tDelay * 100);
    this.col = col;
    this.speed = speed;
    this.tDelay = tDelay;
    this.x = x;
    this.drip = null;
  }

  public void update(long dt) {
    if (drip != null) {
      drip.y += (dt / 5f) * speed;
      if (drip.y > height + 25 + (tDelay * 100)) drip.y = length;
    }
  }

  public void draw(PGraphics image, float prog) {
    image.pushMatrix();
    image.translate(0, -tDelay * 100);

    image.fill(col);
    image.noStroke();

    float tProg = prog * speed;
    image.rect(x - 12.5, 0, 25, min(length, tProg));
    image.ellipse(x, min(length, tProg), 25, 25);

    if (tProg >= length) {
      if (drip == null)
        drip = new PVector(x, tProg);
      else
        image.ellipse(drip.x, drip.y, 25, 25);
    }

    image.popMatrix();
  }
}

public class DripScene implements Scene {

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  int n;
  Icicle[] icicles;
  float prog;
  PGraphics image;

  public DripScene(int n) {
    image = createGraphics(width, height);
    this.n = n;
    restart();
  }

  public void update(long dt) {
    prog += 100 * (dt / 1000f);

    // update drips
    for (int i = 0; i < n; i++) {
      icicles[i].update(dt);
    }
  }

  public void restart() {
    prog = 0;
    icicles = new Icicle[n];

    // generate the delays, shuffle them
    float[] delays = new float[n];
    float delay = 0;
    for (int i = 0; i < n; i++) {
      delays[i] = delay;
      delay += random(0.5, 1.5);
    }
    for (int i = 0; i < 100; i++) {
      int j = floor(random(n));
      int k = floor(random(n));
      float temp = delays[j];
      delays[j] = delays[k];
      delays[k] = temp;
    }

    // generate the icicles
    for (int i = 0; i < n; i++) {
      icicles[i] = new Icicle(floor(random(175, 375)), RAND_COLOR(), random(0.75f) + 0.75f, delays[i], floor((i + 1) * width / (n + 1)));
    }
    image.beginDraw();
    image.background(0);
    image.endDraw();
  }

  public void draw() {
    image.beginDraw();
    image.fill(0, 0, 0, 25);
    image.rect(0, 0, width, height);

    for (int i = 0; i < n; i++) {
      icicles[i].draw(image, prog);
    }
    image.endDraw();
  }


  public PGraphics getImage() {
    return image;
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
