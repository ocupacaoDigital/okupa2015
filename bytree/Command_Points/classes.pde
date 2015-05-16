
class Player{
  public color c; 
  public char shape;
  float ownage, score, acc;
  public float presence;
  int wins;
  Player(){
    c = color(random(255), random(255), random(255));
    char s = ' ';
    switch( int(random(-0.4999, 3.4999))){
      case 0: s = 't'; break;
      case 1: s = 's'; break;
      case 2: s = 'p'; break;
      case 3: s = 'h'; break;
    }
    shape = s;
  }
  void weight_bonus( FPoly p ){
    
  }
}

class Map{
  CommandPt[] cmds;
  ArrayList<PVector>i; // temp storage for walls
  ArrayList<PVector>f;
  PVector[] startingLocations2;
  PVector[] startingLocations3;
  PVector[] startingLocations4;
  float Acmds, scoreBar;
}

class CommandPt {
  float x, y, size;
  char type;
  float owner, domination, total, scoreRate, rad;
  
  CommandPt(char type_, float x_, float y_, float size_, float total_, float scoreRate_){
    x = x_;
    y = y_;
    size = size_;
    type = type_;
    total = total_;
    owner = -1;
    domination = 0;
    scoreRate = scoreRate_;
    rad = ( (size * (sqrt(2)/2f) ) + ( square_l * (sqrt(2)/2f)) );
  }
  void exe(){
    
    float pdom = domination;
    
    for( int i = 0; i < playerCount.n; i++ ){
      if( dist( p[i].getX(), p[i].getY(), x, y ) <= rad ){
        if( owner == i ){
          if( domination < total ){
            domination = constrain( domination + players.get(i).presence, 0, total );
          }
        }
        else{
          if( domination > 0 ){
            domination = constrain( domination - players.get(i).presence, 0, total );
          }
          else if( domination == 0 ){
            owner = i;
            domination = constrain( domination + players.get(i).presence, 0, total );
          }
        }
      }
    }
    if( pdom != domination ){
      if( domination == 0 ){
        
      }
      else if ( domination == total ){
        
      }
    }
    
    float radius = 1.25*sqrt(2)*size;  
    float theta = map(domination, 0, total, 3*HALF_PI, -HALF_PI);    
    fill(255);
    ellipse(x, y, radius, radius);
    fill(players.get(int(owner)).c);
    arc(x, y, radius, radius, theta, 3*HALF_PI, PIE);
    fill(255);
    ellipse(x, y, radius, radius);
    rect(x-(size/2f), y-(size/2f), size, size);
  }
}

boolean is(int i, float x, float y, float size){ //detecta a presenca do FBox dentro de uma regiao quadrada com centro x,y e lado size.
  boolean is = false;
  if (i == 1){
    if((p1.getX()>(x-(size/2f)))&&(p1.getX()<(x+(size/2f)))&&(p1.getY()>(y-(size/2f)))&&(p1.getY()<(y+(size/2f)))){
      is = true;
    }
  }
  else if (i == 2){
    if((p2.getX()>(x-(size/2f)))&&(p2.getX()<(x+(size/2f)))&&(p2.getY()>(y-(size/2f)))&&(p2.getY()<(y+(size/2f)))){
      is = true;
    }
  }
  return is;
}

class Item {
  /*
  lock
  bomb (destroys lock)
  freeze AOE (x3)
  push AOE (x5)
  instacapture
  speed
  weight
  */
}
