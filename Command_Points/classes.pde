
class Player{
  float p1Ownage=0, p2Ownage=0, p1Score=0, p2Score=0, p1acc=600, p2acc=600, Acmds, scoreBar;
  int p1Wins=0, p2Wins=0; // vitorias
}

class editor{
  int W=0,C=0, wait=0;
  float xi, yi, xf, yf; //valores da criacao de paredes 
  char Otype='a'; // moment controla as telas(menus, jogo, editor..), tambem controla as funcoes do mouse dentro do mousePressed(), Otype: tipo de command
  PImage CmdPtIcon, WallsIcon, TilesIcon;
  boolean makingCmds=false, creatingWall=false, makingWalls=false, makingTiles=false, deleting=false, settingType=false, settingSize=false, settingEase=false, settingScoreRate=false;
  float Osize = 58, Oease = 1/90f, OscoreRate = 1/60f;
}

class CommandPt {
  float x, y, size, ease, owner, scoreRate;
  char type;
  boolean active;
  CommandPt(){
    active = false;
  }
  CommandPt(char type_, float x_, float y_, float size_, float ease_, float scoreRate_){
  x=x_;
  y=y_;
  size=size_;
  ease=ease_;                 //1/90f;
  owner=0;
  type = type_;
  scoreRate = scoreRate_;    //1/60f;
  active = true;
  /*
  types:
  a: standard
  b: dynamic, adds score
  c: subtracts from adversary
  d: robber
  s: speed bonus
  w: weight bonus
  */
}
  char type(){return type;}
  boolean active(){return active;}
  float owner(){return owner;}
  void setOwner(float owner_){owner=owner_;}
  void go(){
    if(owner<0){
      float theta = map(owner, -50.01, 0, 3*HALF_PI, -HALF_PI);
      fill(255);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, theta, 3*HALF_PI, PIE);
      fill(R1, G1, B1);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, -HALF_PI, theta, PIE);
    }
    else if(owner>=0){
      float theta = map(owner, 0, 50.01, 3*HALF_PI, -HALF_PI);
      fill(R2, G2, B2);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, theta, 3*HALF_PI, PIE);
      fill(255);
      arc(x, y, 1.25*sqrt(2)*size, 1.25*sqrt(2)*size, -HALF_PI, theta, PIE);
    }
 
    fill(255);
    ellipse(x, y, sqrt(2)*size, sqrt(2)*size);
    
    boolean isp1=false, isp2=false;
    if((p1.getX()>(x-(size/2f)))&&(p1.getX()<(x+(size/2f)))&&(p1.getY()>(y-(size/2f)))&&(p1.getY()<(y+(size/2f)))){
      isp1 = true;
    }
    if((p2.getX()>(x-(size/2f)))&&(p2.getX()<(x+(size/2f)))&&(p2.getY()>(y-(size/2f)))&&(p2.getY()<(y+(size/2f)))){
      isp2 = true;
    }
    
    strokeWeight(2);
    if( isp1 && isp2 ){
      stroke((R1+R2)/2f, (G1+G2)/2f, (B1+B2)/2f); 
      owner += (p2.getWidth()*ease)-(p1.getWidth()*ease);
    }
    else if(isp1){
      owner-=p1.getWidth()*ease;
      owner=constrain(owner, -50, 50);
      stroke(R1, G1, B1);
    }
    else if(isp2){
      owner+=p2.getWidth()*ease;
      owner=constrain(owner, -50, 50);
      stroke( R2, G2, B2);
    }
    rect(x, y, size, size);
    stroke(0);
    strokeWeight(1);
    
    if(type=='b'){
      if(owner < 0){
        p1Score += map(owner, 0, -50, 0, 1)*scoreRate;
      }
      else if (owner > 0){
        p2Score += map(owner, 0, 50, 0, 1)*scoreRate;
      }
    }
    else if(type=='c'){
      if(owner < 0){
        p2Score -= map(owner, 0, -50, 0, 1)*scoreRate;
      }
      else if (owner > 0){
        p1Score -= map(owner, 0, 50, 0, 1)*scoreRate;
      }
    }
    else if(type=='d'){
      if(owner < 0){
        p1Score += map(owner, 0, -50, 0, 1)*scoreRate*0.5;
        p2Score -= map(owner, 0, -50, 0, 1)*scoreRate*0.5;
      }
      else if (owner > 0){
        p2Score += map(owner, 0, 50, 0, 1)*scoreRate*0.5;
        p1Score -= map(owner, 0, 50, 0, 1)*scoreRate*0.5;
      }
    }
    else if(type=='s'){
      if(owner < 0){
        p1acc = map(owner, 0, -50, 600, 750);
        p2acc = map(owner, 0, 50, 600, 750);
      }
      else if (owner > 0){
        p2acc = map(owner, 0, 50, 600, 750);
        p1acc = map(owner, 0, -50, 600, 750);
      }
    }
    else if(type=='w'){
      if(isp1 || isp2){
        if(owner == -50){
          p1.setWidth(25);
          p1.setHeight(25);
          p2.setWidth(20);
          p2.setHeight(20);
        }
        else if(owner == 50){
          p1.setWidth(20);
          p1.setHeight(20);
          p2.setWidth(25);
          p2.setHeight(25);
        }
        /*
        if(owner < 0){
          p1.setWidth(map(owner, 0, -50, 18, 25));
          p1.setHeight(map(owner, 0, -50, 18, 25));
        }
        else if (owner > 0){
          p2.setWidth(map(owner, 0, 50, 18, 25));
          p2.setHeight(map(owner, 0, 50, 18, 25));
        }
        */
      }
    }
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
