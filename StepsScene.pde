public class StepBall {
  public PVector old;
  public PVector pos;
  public PVector vel;
  public color col;
  public int nextStep;
  public int collisions;
  public boolean del = false;

  public StepBall(PVector pos, PVector vel, int firstStep, color col) {
    this.pos = pos;
    this.vel = vel;
    this.col = col;
    this.nextStep = firstStep;
    this.collisions = 0;
  }
}


public class StepSystem {
  int[] steps;
  ArrayList<StepBall> balls;
  color[] stepColors;
  float t;

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  public StepSystem(int nSteps) {
    steps = new int[nSteps - 1];
    for (int i = 0; i < nSteps - 1; i++) steps[i] = (i+1) * (height / 10);
    balls = new ArrayList<StepBall>();
    stepColors = new color[nSteps];
    for (int i = 0; i < nSteps; i++) stepColors[i] = RAND_COLOR();
    balls.add(new StepBall(new PVector(0, 0), new PVector(50, 0), steps[0], RAND_COLOR()));
  }

  public void update(long dt) {
    float dtf = dt / 1000f;
    t += dtf;
    if (t > 1.94) {
      t = 0;
      balls.add(new StepBall(new PVector(0, 0), new PVector(50, 0), steps[0], RAND_COLOR()));
    }
    for (int i = balls.size() - 1; i >= 0; i--) if (balls.get(i).del && balls.get(i).pos.y > (width+50)) balls.remove(i);
    for (StepBall t : balls) {
      t.vel.add(new PVector(0, 5));
      PVector step = new PVector(t.vel.x * dtf, t.vel.y * dtf);
      t.pos.add(step);
      if (t.pos.y > t.nextStep && !t.del) {
        t.vel = new PVector(t.vel.x, -250);
        if (t.collisions == steps.length - 1) t.del = true;
        else t.nextStep = steps[++t.collisions];
      }
    }
  }

  public void draw(PGraphics image, int xOffset, int yOffset) {
    image.strokeWeight(25);
    for (int x = xOffset + 30, n = 0; n < steps.length; x += 97) {
      image.noStroke();
      image.fill(stepColors[n]);
      image.rect(x - 35, steps[n] + yOffset + 10, 85, 25);
      image.stroke(stepColors[n]);
      image.line(x + 50 - 97, (n > 0 ? steps[n-1] : 0) + yOffset + 22.5, x - 25, (n > 0 ? steps[n-1] : 0) + yOffset + 22.5 + 300);
      n += 1;
    }
    image.noStroke();
    for (StepBall b : balls) {
      image.fill(b.col);
      image.ellipse(b.pos.x + xOffset, b.pos.y + yOffset, 25, 25);
    }
  }
}

public class StepsScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  StepSystem[] steps;
  int[] offsets;
  int[] yOffsets;
  boolean zoomed;

  public StepsScene(boolean zoomed) {
    image = createGraphics(width, height);
    this.zoomed = zoomed;
    if (zoomed) {
      steps = new StepSystem[] { new StepSystem(10) };
      offsets = new int[] { 100 };
      yOffsets = new int[] { -50 };
    } else {
      steps = new StepSystem[] {
        new StepSystem(12), 
        new StepSystem(12), 
        new StepSystem(12)
      };
      offsets = new int[] {-250, 500, 1350 };
      yOffsets = new int[] {-50, -50, -50};
    }
  }

  public void update(long dt) {
    for (int i = 0; i < steps.length; i++) steps[i].update(dt);
  }

  public void draw() {
    image.beginDraw();
    image.pushMatrix();
    image.background(0);
    if (zoomed) image.scale(3);
    for (int i = 0; i < steps.length; i++) {
      steps[i].draw(image, offsets[i], yOffsets[i]);
    }
    image.popMatrix();
    image.endDraw();
  }

  boolean preUpdate() {
    return !zoomed;
  }
  float fadeInTime() { 
    return 0;
  }
  float fadeOutTime() { 
    return 0;
  }
  long length() { 
    if (zoomed) return 9600;
    else return 9650;
  }
}
