import processing.sound.*;
int d = 7;
// settings 4096/64, 2048/45, 1024/32, 512/16
int band = 4096;
//int band = 1024;
int unit = d;
int count;
Module [] modA;
float[]spectrum  = new float [band];
AudioIn in;
FFT fft;
float bd = band;

//variables for the frame rate counter

int fcount, lastm;
float frate;
int fint = 3;

void settings() {

  int ratioW = 700;
  int ratioH = ratioW * 17/ 11;
  int roundH = round (ratioH);

  size(ratioW, roundH, P3D);
}

void setup() {
  //background(255, 129, 22);
  background(255);


  fft = new FFT(this, band);
  in = new AudioIn (this, 0);
  in.start();

  fft.input(in);

  int sqr = int (sqrt (band));
  int dim = sqr;
  int wideCount = dim;
  int highCount = dim;
  count = wideCount * highCount;

  modA = new Module [count];

  int index = 0;
  for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {
      modA[index++] = new Module(unit * x, unit * y, d, d, unit, y * x);
    }
  }
}

void draw() {


  background(255, 129, 22);


  //camera (70.0, 35.0, 120.0, -120.0 , 150.0, 0.0, 0.0, 1.0, 0.0);


  // Turn on the lights.
  ambientLight(228, 255, 255);
  directionalLight(128, 128, 128, 0, 0, -1);

  for (int i = 0; i < count; i++) {

    push();
    translate(width/2-70, height/2-75, 100);
    //rotateY (PI/4);
    rotateX (PI/4);
    rotateZ (PI/6);


    modA[i].updateDraw();
    pop();
  }
  push();
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate);
  }
  fill(0);
  push();
  noStroke();
  fill(25, 129, 22);
  rect (10, 10, 80, 10);

  pop();
  text("fps: " + frate, 10, 20);
  pop();
}

void keyTyped() {
  if (keyPressed == true || keyPressed == true) {
    save("3d-grid-box.tif");
  }
}

class Module {

  int xOff;
  int yOff;
  int xsz;
  int ysz;
  float zsz;
  float lrp;
  int unit; //may be need to fix
  int band; //may need to fix
  String str;




  Module (int _xOff, int _yOff, int _xsz, int _ysz, int _unit, int _band) {

    xOff = _xOff;
    yOff = _yOff;
    xsz = _xsz;
    ysz = _ysz;
    unit = _unit;
    band = _band;
  }



  void updateDraw() {
    //noStroke();
    strokeWeight(.1);
    stroke (255, 129, 22);
    //stroke (0);
    ortho();


    fft.analyze(spectrum);



    zsz = map (spectrum [band], 0.000, 100.000, 0.000, 90000.000);
    lrp = lerp(0, zsz, .03);

    String s = str (lrp);





    fill(200 + lrp *100, 100+lrp * 125, 155 - lrp *200);
    push();
    //point (xOff, yOff, (lrp * 20) /2);
    //translate(xOff+ random (2), yOff, (lrp *600)/2);
    //box(xsz, ysz, lrp *600);

    float noff = 0.0;
    float n = noise(noff) * d;
    float rnd = random (d);
    float dp = lrp*600;
    PVector a1, a2, a3, a4, b1, b2, b3, b4;
    float fX = xOff + d+rnd;
    float fY = yOff + d+rnd;
    float onX = xOff+rnd;
    float onY = yOff+rnd;
    //float tp = (d/2)*lrp;

    float tp = d*lrp%2;


    println (d*lrp);
    a1 = new PVector (onX+tp+n, onY+tp+n, dp);
    a2 = new PVector (fX-tp+n, onY+tp+n, dp);
    a4 = new PVector (onX+tp+n, fY-tp+n, dp);
    a3 = new PVector (fX-tp+n, fY-tp+n, dp);


    b1 = new PVector (onX+n, onY+n, 0);
    b2 = new PVector (fX+n, onY+n, 0);
    b4 = new PVector (onX+n, fY+n, 0);
    b3 = new PVector (fX+n, fY+n, 0);

  
    
    ////top
    //beginShape ();
    //vertex (a1.x, a1.y, a1.z);
    //vertex (a2.x, a2.y, a2.z);
    //vertex (a3.x, a3.y, a3.z);
    //vertex (a4.x, a4.y, a4.z);
    //endShape (CLOSE);

    // sideA
    beginShape ();
    vertex (a1.x, a1.y, a1.z);
    vertex (a2.x, a2.y, a2.z);
    vertex (b2.x, b2.y, b2.z);
    vertex (b1.x, b1.y, b1.z);
    endShape (CLOSE);


    // sideB
    beginShape ();
    vertex (a2.x, a2.y, a2.z);
    vertex (a3.x, a3.y, a3.z);
    vertex (b3.x, b3.y, b3.z);
    vertex (b2.x, b2.y, b2.z);
    endShape (CLOSE);

    // sideC
    beginShape ();
    vertex (a3.x, a3.y, a3.z);
    vertex (a4.x, a4.y, a4.z);
    vertex (b4.x, b4.y, b4.z);
    vertex (b3.x, b3.y, b4.z);
    endShape (CLOSE);

    // sideD
    beginShape ();
    vertex (a4.x, a4.y, a4.z);
    vertex (a1.x, a1.y, a1.z);
    vertex (b1.x, b1.y, b1.z);
    vertex (b4.x, b4.y, b4.z);
    endShape (CLOSE);
    pop();
    noff = noff + 0.001;
     
     push ();
    //textMode(SHAPE);
    textSize(5);
    text (s, a1.x, a2.y, dp);
    pop();
  }
   
}
