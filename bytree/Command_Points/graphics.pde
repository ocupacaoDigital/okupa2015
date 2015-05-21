float tri_l;
float square_l;
float penta_l;
float hex_l;



void init_sides(float l){
  square_l = l;
  
  tri_l = sqrt( sq(l) * (4 / sqrt(3)) );
  
  penta_l = sqrt( sq(l) * (4/5.0) * (1 / tan( (3*PI)/10.0 ) ) );
  
  hex_l = sqrt( sq(l) * ( 2 / (3.0*sqrt(3)) ) );
}

void triangle(float x, float y, float l){
  float k = l * sqrt(3) * (1/6f);
  beginShape();
  vertex(x + (l/2f), y + k );
  vertex(x - (l/2f), y + k);
  vertex(x, y - 2*k);
  endShape(CLOSE);
}
void square(float x, float y, float l){
  l /= 2f;
  beginShape();
  vertex(x - l, y - l);
  vertex(x - l, y + l);
  vertex(x + l, y + l);
  vertex(x + l, y - l);
  endShape(CLOSE);
}
void pentagon(float x, float y, float l){
  float k = l / 1.175570505;
  float a = TWO_PI/5f;
  float o = - HALF_PI;
  beginShape();
  for(int i = 0; i < 5; i ++){
    vertex( x + k * cos( (i * a) + o ), y + k * sin( (i * a) + o ) );
  }
  endShape(CLOSE);
}
void hexagon(float x, float y, float l){
  float k = PI/3f;
  beginShape();
  vertex(x + l, y);
  vertex(x + l * cos(k), y + l * sin(k));
  vertex(x + l * cos(2*k), y + l * sin(2*k));
  vertex(x - l, y);
  vertex(x + l * cos(-2*k), y + l * sin(-2*k));
  vertex(x + l * cos(-k), y + l * sin(-k));
  endShape(CLOSE);
}

PImage icons( char t ){
  switch(t){
    case 'l': return icons[0];
    case 'b': return icons[1];
    case 'f': return icons[2];
    case 'i': return icons[3];
    case 's': return icons[4];
    case 'w': return icons[5];
    default: 
      PImage x;
      x = createImage(0, 0, RGB); 
      return x;
  }
}

