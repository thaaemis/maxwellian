int wid = 640;
int hei = 360;
int num_balls = 200;
float m = pow(10,-22);
float pi = 3.1415926;
float k = 1.3806488*pow(10,-23);
float T = 30000;
float di = 6;

PFont f;
 
float[] t = new float[10000];
int[] maxwell = new int[300];

float[][] pos = new float[num_balls][3];


ball[] balls = new ball[num_balls];


void setup()
{
  size(wid, hei);
  fill(0,150);
  noStroke();

  // Get real Maxwell distribution
  int summaxwell = 0;
  for (int i=1; i<300; i++) {
    float maxnow = pow(m/(2*pi*k*T),3/2)*4*pi*i*i*pow(2.71,-m*i*i/(2*k*T))*1000;
    maxwell[i] = int(maxnow);
    summaxwell = summaxwell + maxwell[i];
    println(i+" "+maxwell[i]+"\n");
  }
  for (int i=0; i<300; i++) {
    maxwell[i] = int(maxwell[i] * 10000 / summaxwell);
  }
  int count=0;
  for (int i=0; i<300; i++) {
    for (int j=maxwell[i]; j>0; j--) {
      int sign = count%2 == 0? 1:-1;
      t[count] = float(maxwell[i])/20*sign;
      count = count+1;
    }
  }
  
  // Declare balls with random starting points and maxwellian velocities
  for (int i=1; i<num_balls; i++) {
    balls[i] = new ball(di, random(wid), random(hei), t[int(random(0,100))], t[int(random(0,100))], 0);
  }
  
  for (int i=0; i<num_balls; i++) {
    for (int j=0; j<3; j++) {
      pos[i][j] = 0;
    }
  }
  
  f = createFont("Arial",16,true);
}


void draw()
{
  background(255);
  textFont(f,16);
  fill(0);
  text("Temp = "+nf(T,4,0), 10, 30);
  
  for (int i=1; i<num_balls; i++) {
    balls[i].display();
    balls[i].move();
    pos[i][0] = balls[i].h();
    pos[i][1] = balls[i].w();
    pos[i][2] = balls[i].r();
  } 
  
  for (int i=1; i<num_balls; i++) {
    balls[i].collision(pos,i);
  }
}
  
class ball
{
  float diam; // ball diameter (constant)
  float xpos; // ball xposition
  float ypos; // ball vertical position
  float vx; // ball velocity in x
  float vy; // ball velocity in y
  int col; // recent collision info
  
  ball(float idiam, float ix, float iy, float ivx, float ivy, int icol) {
    diam = idiam;
    xpos = ix;
    ypos = iy; 
    vx = ivx;
    vy = ivy;
    col = icol;
  }
  
  float h() {
    return ypos;
  }
  
  float w() {
    return xpos;
  }
  
  float r() {
    return diam/2;
  }
  
  void move () {
    xpos = xpos + vx;
    ypos = ypos + vy;
    if (xpos - diam/2 < 0 | xpos + diam/2 > wid) {
      vx = -vx;
      col = 30;
    }
    if (ypos - diam/2 < 0 | ypos + diam/2 > hei) {
      vy = -vy;
      col = 30;
    }
  }
  
  void collision(float[][] pos, int index) {
    for (int i=0;i<num_balls;i++) {
      if (i != index) {
        float diffy = ypos - pos[i][1];
        float diffx = xpos - pos[i][0];
        float sumrad = (pos[i][2] + diam)/2;
        float colangle = atan(diffy/diffx);
        if (sqrt(pow(diffx,2) + pow(diffy,2)) < sumrad) {
          vx = -vx*cos(colangle);
          vy = -vy*sin(colangle);
          col = 30;
        }
      }
    }
  }
  
  void display() {
    fill(0);
    col = col - 1;
    //trail(diam, xpos, ypos);
    if (col > 0) {
      fill(col*12, 0, 0);
    }
    ellipse(xpos, ypos, diam, diam);
  }
  
  void trail(int diamI, float xin, float yin) {
    float posx = xin;
    for (int i=10; i>0; i--) {
      fill(i*25);
      if (vx>0) {
        posx = xin - i*7;
      } else {
        posx = xin + i*7;
      }
      ellipse(posx, yin, diamI, diamI);
    }
  }
}
