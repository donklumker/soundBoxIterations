import processing.sound.*;



int d = 15;
// settings 4096/64, 2048/45, 1024/32, 512/16
int band = 2048;
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

void setup() {
  background(255, 129, 22);
  size(1100, 1100, P3D);

  fft = new FFT(this, band);
  in = new AudioIn (this, 0);
  in.start();

  fft.input(in);


  int wideCount = 45;
  int highCount = 45;
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


  //background(255, 129, 22);


  //camera (70.0, 35.0, 120.0, -120.0 , 150.0, 0.0, 0.0, 1.0, 0.0);


  // Turn on the lights.
  ambientLight(228, 255, 255);
  directionalLight(128, 128, 128, 0, 0, -1);

  for (int i = 0; i < count; i++) {

    push();
    translate(width/2+100, height/2-100, 0);
    rotateX (PI/4);
    rotateZ (PI/3);


    modA[i].updateDraw();
    pop();
  }
  
    fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate); 
  }
  fill(0);
  text("fps: " + frate, 10, 20); 
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
    strokeWeight(.4);
    stroke (255, 129, 22);
    ortho();


    fft.analyze(spectrum);



    zsz = map (spectrum [band], 0.000, 100.000, 0.000, 90000.000);
    lrp = lerp(0, zsz, .03);
    println(spectrum [band]);


    fill(155 + lrp *800, 120+lrp * 400, 255 - lrp *800);
    push();
    //point (xOff, yOff, (lrp * 20) /2);
    //translate(xOff+ random (2), yOff, (lrp *600)/2);
    //box(xsz, ysz, lrp *600);



    float dp = lrp*1300;

    PVector a1, b1, b2, b3, b4;
    float fX = xOff + d;
    float fY = yOff + d;
    
    float onX = xOff;
    float onY = yOff;


    a1 = new PVector ((onX+fX)/2, (onY+fY)/2, dp);
  

    b1 = new PVector (onX, onY, 0);
    b2 = new PVector (fX, onY, 0);
    b4 = new PVector (onX, fY, 0);
    b3 = new PVector (fX, fY, 0);

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
    vertex (b2.x, b2.y, b2.z);
    vertex (b1.x, b1.y, b1.z);
    endShape ();


    // sideB
    beginShape ();
    vertex (a1.x, a1.y, a1.z);
    vertex (b3.x, b3.y, b3.z);
    vertex (b2.x, b2.y, b2.z);
    endShape ();

    // sideC
    beginShape ();
    vertex (a1.x, a1.y, a1.z);
    vertex (b4.x, b4.y, b4.z);
    vertex (b3.x, b3.y, b4.z);
    endShape ();

    // sideD
    beginShape ();
    vertex (a1.x, a1.y, a1.z);
    vertex (b1.x, b1.y, b1.z);
    vertex (b4.x, b4.y, b4.z);
    endShape ();


    pop();
  }
}
