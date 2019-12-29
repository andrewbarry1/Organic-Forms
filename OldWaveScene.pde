public class OldWaveScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  int n;
  float[] A;
  float[] Omega;
  float[] Theta;
  float[] Y;
  int t;

  final int CHANGE_TIME = 1000;
  int newSin;
  float newA, oldA;
  float newOmega, oldOmega;
  float newTheta, oldTheta;
  color oldColor;
  color newColor;
  boolean fadeOut;

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  public OldWaveScene(int n, int seed, boolean fadeOut) {
    this.fadeOut = fadeOut;
    randomSeed(seed);
    image = createGraphics(width, height);
    this.n = n;

    A = new float[n];
    Omega = new float[n];
    Theta = new float[n];
    Y = new float[width];

    for (int i = 0; i < n; i++) {
      A[i] = random(50);
      Omega[i] = random(0.01);
      Theta[i] = random(TWO_PI);
    }

    t = CHANGE_TIME + 1;
    oldColor = RAND_COLOR();
    newColor = RAND_COLOR();
  }

  public void update(long dt) {
    t += dt;

    if (t > CHANGE_TIME) {
      newSin = floor(random(n));
      newA = random(50);
      oldA = A[newSin];
      newOmega = random(0.01);
      oldOmega = Omega[newSin];
      newTheta = random(TWO_PI);
      oldTheta = Theta[newSin];
      oldColor = newColor;
      newColor = RAND_COLOR();
      t = 0;
    }

    A[newSin] = map(t, 0, CHANGE_TIME, oldA, newA);
    Omega[newSin] = map(t, 0, CHANGE_TIME, oldOmega, newOmega);
    Theta[newSin] = map(t, 0, CHANGE_TIME, oldTheta, newTheta);


    for (int i = 0; i < width; i++) {
      float result = 0;
      for (int j = 0; j < n; j++) result += A[j] * sin((Omega[j] * i) + Theta[j]);
      Y[i] = result;
    }
  }

  public void draw() {
    image.beginDraw();
    image.background(0);
    image.pushMatrix();
    image.translate(0, height/2);
    image.noStroke();

    image.fill(lerpColor(oldColor, newColor, t / (float)CHANGE_TIME));
    for (int i = 0; i < width; i++) image.ellipse(i, Y[i], 25, 25);

    image.popMatrix();
    image.endDraw();
  }

  boolean preUpdate() { 
    return false;
  }
  float fadeInTime() { 
    return 0;
  }
  float fadeOutTime() { 
    if (fadeOut) return 10000;
    else return 0;
  }
  long length() { 
    if (fadeOut) return 19250;
    else return 19500;
  }
}
