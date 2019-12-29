public class Flower {
  public static final float PETAL_LENGTH = 200;

  public float x;
  public float y;
  public float[] petals;
  float[] petalTimers;
  float theta;

  color petalColor;
  color centerColor;

  boolean colorShift;
  color newColor;
  float nextColorTime;
  final float COLOR_SHIFT_TIME = 30f;

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }


  float t;

  public Flower(float x, float y, int nPetals, boolean finished, color center, color petalcol, boolean colorShift) {
    this.x = x;
    this.y = y;
    this.theta = random(0, TWO_PI);

    this.colorShift = colorShift;
    this.newColor = RAND_COLOR();
    this.nextColorTime = COLOR_SHIFT_TIME;

    petalColor = petalcol;
    centerColor = center;
    petals = new float[nPetals];
    petalTimers = new float[nPetals];
    t = 0;
    for (int i = 0; i < nPetals; i++) {
      if (finished) petals[i] = PETAL_LENGTH; 
      petalTimers[i] = 0.5 * i * (PETAL_LENGTH / nPetals);
    }
  }

  public void update(float dt) {
    t += dt;
    for (int i = 0; i < petals.length; i++) {
      if (petalTimers[i] > 0) petalTimers[i] -= dt * 2;
      else if (petals[i] < PETAL_LENGTH) petals[i] += dt * 2;
    }
    theta += (dt / 20);

    if (colorShift && t >= nextColorTime) {
      petalColor = newColor;
      newColor = RAND_COLOR();
      nextColorTime += COLOR_SHIFT_TIME;
    }
  }

  public void draw(PGraphics image) {
    image.strokeWeight(25);
    image.noFill();
    if (colorShift) image.stroke(lerpColor(petalColor, newColor, (t - (nextColorTime - COLOR_SHIFT_TIME)) / COLOR_SHIFT_TIME));
    else image.stroke(petalColor);
    for (int i = 0; i < petals.length; i++) {
      float omega = i * (TWO_PI / petals.length);
      image.line(0, 0, (petals[i] + 5*sin(0.7*(t + i))) * cos(omega), (petals[i] + 5*sin(0.7*(t + i))) * sin(omega));
    }
    image.fill(centerColor);
    image.noStroke();
    image.ellipse(0, 0, 50, 50);
  }
}

public class FlowerScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  Flower[] flowers;
  boolean oneFlower;

  public FlowerScene(boolean oneFlower) {
    this.oneFlower = oneFlower;
    image = createGraphics(width, height);
    flowers = new Flower[oneFlower ? 1 : 3];
    if (oneFlower) flowers[0] = new Flower(width/2, height/2, 16, false, RAND_COLOR(), RAND_COLOR(), !oneFlower);
    else {
      flowers[0] = new Flower(width/6, height/3, 16, true, RAND_COLOR(), RAND_COLOR(), !oneFlower);
      flowers[1] = new Flower(2*width/4, 2*height/3, 16, true, RAND_COLOR(), RAND_COLOR(), !oneFlower);
      flowers[2] = new Flower(5*width/6, height/3, 16, true, RAND_COLOR(), RAND_COLOR(), !oneFlower);
    }
  }

  long tDelay = 5000;
  public void update(long dt) {
    if (tDelay > 0 && oneFlower) { 
      tDelay -= dt; 
      return;
    }
    for (int i = 0; i < flowers.length; i++) {
      flowers[i].update(dt / 100f);
    }
  }

  public void draw() {
    image.beginDraw();
    image.fill(0, 30);
    image.rect(0, 0, width, height);
    for (int i = 0; i < flowers.length; i++) {
      Flower f = flowers[i];
      image.pushMatrix();
      image.translate(f.x, f.y);
      image.rotate(f.theta);
      f.draw(image);
      image.popMatrix();
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
    if (!oneFlower) return 10020;
    else return 9370;
  }
}
