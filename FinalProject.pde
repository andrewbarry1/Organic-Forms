/**
Andrew Barry - Organic Forms

A computer nature documentary

**/

import processing.sound.*;

public interface Scene {
  void draw();
  void update(long dt);
  PGraphics getImage();
  
  boolean preUpdate(); // should this scene be updating while the previous scene is going?
  float fadeInTime(); // should this scene fade in?
  float fadeOutTime(); // should this scene fade out?
  long length(); // how long should this scene be visible?
}

public color BOLD_RAND_COLOR() {
  // generate a random color in a tight range that is guaranteed to not be grey (crappy algorithm)
  int thresh = 35, cDist = 0, r = 0, g = 0, b = 0;
  int MAX_ATTEMPTS = 1000;
  while (cDist < thresh & MAX_ATTEMPTS-- > 0) {
    r = floor(random(120, 150));
    g = floor(random(120, 150));
    b = floor(random(120, 150));
    cDist = abs(r - g) + abs(r - b) + abs(g - b);
  }
  return color(r, g, b);
}

int n;
Scene scene;
Scene nextScene;
long nextSceneTime;
ArrayList<Scene> oldScenes;
float fade;
SoundFile sound;
  PImage title;

// Processing starts millis() while it's still loading assets in setup()
// set baseline on the first real draw call and always subtract it from millis()
long baseline = -1;
long t() {
  return millis() - baseline;
}

void setup() {
  fullScreen();
  //size(1920, 1080);
  noCursor();

  n = 0;
  oldScenes = new ArrayList<Scene>();
  scene = new OrbitScene(7, true);
  nextScene = new CrystalScene();
  nextSceneTime = scene.length();
  title = loadImage("title.png");
  sound = new SoundFile(this, "xela.mp3");
  sound.play();
}

void draw() {
  if (baseline == -1) baseline = millis();
  // scene transitions
  if (t() > nextSceneTime) {
    oldScenes.add(scene);
    scene = nextScene;
    //System.out .println("Transition " + n + " at " + t());
    n++;
    switch (n) {
     case 1: { nextScene = new DripScene(20); break; } // CrystalScene > DripScene
     case 2: { nextScene = new OceanScene(); break; }  // DripScene > OceanScene
     case 3: { nextScene = new FlowerScene(true); break; } // DripScene > FlowerScene
     case 4: { nextScene = new OldWaveScene(30, 3, true); break; } // FlowerScene > OldWaveScene (slow)
     case 5: { nextScene = new StepsScene(true); break; } // OldWaveScene (slow) > StepsScene (TEMPO TRANSITION)
     case 6: { nextScene = new StepsScene(false); break; } // StepsScene zoom out
     case 7: { nextScene = new ArteryScene(5, 2); break; } // Steps zoomed out > ArteryScene
     case 8: { nextScene = new ArteryScene(5, 3); break; } // ArteryScene > Different ArteryScene
     case 9: { nextScene = new ArteryScene(5, 4); break; } // ArteryScene > another ArteryScene
     case 10: { nextScene = new OldWaveScene(30, 1, false); break; } // ArteryScene > OldWaveScene
     case 11: { nextScene = new SpiralScene(); break; } // OldWaveScene > SpiralScene
     case 12: { nextScene = oldScenes.get(7); break; } // SpiralScene > Stairs zoomed out again
     case 13: { nextScene = new BetterWaveScene(); break; } // Stairs zoomed out again > BetterWaveScene
     case 14: { nextScene = oldScenes.get(1); ((CrystalScene) nextScene).reuse(); break; } // BetterWaveScene > CrystalScene 2
     case 15: { nextScene = new FlowerScene(false); break; } // CrystalScene 2 > 3 FlowerScene
     case 16: { nextScene = new OrbitScene(7, false); break; } // 3 FlowerScene > OrbitScene (fade out, end)
     case 17: { nextScene = new BlankScene(); break; } 
     case 18: { exit(); }
    }
    nextSceneTime += scene.length();
    fade = 0;
  }
  
  // update & draw current scene
  scene.update(16);
  if (nextScene.preUpdate()) nextScene.update(16);
  scene.draw();
  image(scene.getImage(), 0, 0);
  
  // apply fades
  if (fade < scene.fadeInTime()) {
    float pct = 1 - (fade / scene.fadeInTime());
    fill(0, pct * 255);
    rect(0, 0, width, height);
    fade += 16;
  }
  else if (scene.fadeOutTime() != 0 && t() > nextSceneTime - scene.fadeOutTime() - 3000) {
    float pct = min(1, 1 - ((nextSceneTime - (t() + 3000)) / scene.fadeOutTime()));
    fill(0, pct * 255);
    rect(0, 0, width, height);
  }
  
  // show title image
  if (n == 0 && t() > 9601) {
    float pct = (t() - 9601) / 5000f;
    imageMode(CENTER);
    tint(255, pct * 255);
    image(title, width / 2, 150);
    noTint();
    imageMode(CORNER);
  }
}

void keyPressed() {
  if (keyCode == ESC) exit();
  //else if (keyCode == ENTER) System.out.println(t());
}
