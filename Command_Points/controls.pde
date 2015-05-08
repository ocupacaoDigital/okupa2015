PVector wasdControls(float S){
  PVector Thrust_;
  Thrust_ = new PVector(0.0,0.0);
  if(w){Thrust_.add(0.0, -S, 0.0);}
  if(s){Thrust_.add(0.0, S, 0.0);}
  if(a){Thrust_.add(-S, 0.0, 0.0);}
  if(d){Thrust_.add(S, 0.0, 0.0);}
  return Thrust_;
}

PVector arrowControls(float S){
  PVector Thrust_;
  Thrust_ = new PVector(0.0,0.0);
  if(up){Thrust_.add(0.0, -S, 0.0);}
  if(down){Thrust_.add(0.0, S, 0.0);}
  if(left){Thrust_.add(-S, 0.0, 0.0);}
  if(right){Thrust_.add(S, 0.0, 0.0);}
  return Thrust_; //new PVector(Thrust_.x, Thrust_.y);
}


void keyPressed(){
  if(keyCode==BACKSPACE){moment='m';}
  if(keyCode==UP){up=true;}
  if(keyCode==DOWN){down=true;}
  if(keyCode==LEFT){left=true;}
  if(keyCode==RIGHT){right=true;}
  if(key=='w' || key=='W'){w=true;}
  if(key=='a' || key=='A'){a=true;}
  if(key=='s' || key=='S'){s=true;}
  if(key=='d' || key=='D'){d=true;}
}
void keyReleased(){
  if(keyCode==UP){up=false;}
  if(keyCode==DOWN){down=false;}
  if(keyCode==LEFT){left=false;}
  if(keyCode==RIGHT){right=false;}
  if(key=='w' || key=='W'){w=false;}
  if(key=='a' || key=='A'){a=false;}
  if(key=='s' || key=='S'){s=false;}
  if(key=='d' || key=='D'){d=false;}
}
void mousePressed(){
  if(moment == 'm'){
    if(mouseY>(1.5/5f)*height && mouseY<(2.5/5f)*height){moment='f';}
    else if(mouseY>(2.5/5f)*height && mouseY<(3.5/5f)*height){moment='e';}
    else if(mouseY>(3.5/5f)*height && mouseY<(4.5/5f)*height){
      if(mouseX > width/2f){moment='c';}
      else {moment='o';}
    }
  }
  else if(moment == 'e'){
    
    if(mouseX>10 && mouseX<40 && mouseY>10 && mouseY<40){makingCmds=true;makingWalls=false;makingTiles=false;deleting=false;}
    else if(mouseX>50 && mouseX<80 && mouseY>10 && mouseY<40){makingCmds=false;makingWalls=true;makingTiles=false;deleting=false;}
    else if(mouseX>90 && mouseX<120 && mouseY>10 && mouseY<40){makingCmds=false;makingWalls=false;makingTiles=true;deleting=false;}
    // deleting=false;
    
    if(makingCmds){
    if(mouseX>135 && mouseX<225 && mouseY>11 && mouseY<39){
      settingSize=false; settingEase=false; settingScoreRate=false;
      if(settingType){settingType=false;}
      else settingType=true;
    }
    else if(mouseX>274 && mouseX<360 && mouseY>17 && mouseY<33){settingSize=true; settingType=false; settingEase=false; settingScoreRate=false;}
    else if(mouseX>415 && mouseX<501 && mouseY>17 && mouseY<33){settingSize=false; settingType=false; settingEase=true; settingScoreRate=false;}//(395, 25, 86, 16)
    else if(mouseX>555 && mouseX<605 && mouseY>17 && mouseY<33){settingSize=false; settingType=false; settingEase=false; settingScoreRate=true;}
    
    if(settingType){
        if(mouseX>135 && mouseX<225 && mouseY>39 && mouseY<67){Otype = 'a';settingType=false;wait=20;}
        else if(mouseX>135 && mouseX<225 && mouseY>67 && mouseY<95){Otype = 'b';settingType=false;wait=20;}
        else if(mouseX>135 && mouseX<225 && mouseY>95 && mouseY<123){Otype = 'c';settingType=false;wait=20;}
        else if(mouseX>135 && mouseX<225 && mouseY>123 && mouseY<151){Otype = 'd';settingType=false;wait=20;}
        else if(mouseX>135 && mouseX<225 && mouseY>151 && mouseY<179){Otype = 's';settingType=false;wait=20;}
        else if(mouseX>135 && mouseX<225 && mouseY>179 && mouseY<207){Otype = 'w';settingType=false;wait=20;}
      }
    }
      
    if (mouseY>50){
      float radius = 1.25*sqrt(2)*Osize/2f;
      if(makingCmds && (mouseY > 50+radius)&&(mouseY < height-radius)&&(mouseX > radius)&&(mouseX < width-radius)&&(wait == 0)){
        cmds[C] = new CommandPt(Otype, mouseX, mouseY, Osize, Oease, OscoreRate);
          C++;
      }
        
        
      else if(makingWalls){
        if(!creatingWall){
          xi=mouseX; yi=mouseY;
          creatingWall=true;
        }
        else if(creatingWall){
          xf=mouseX; yf=mouseY;
          wall[W] = new FBox(dist(xi, yi, xf, yf), 8);
          wall[W].setRotation(getTheta(xi,yi,xf,yf));
          wall[W].setPosition((xi+xf)/2f, (yi+yf)/2f);
          wall[W].setStatic(true);
          world.add(wall[W]);
          creatingWall=false;
        }
      }
    }
  }
  else if(moment == 'o'){
    if(mouseX > width*(1/8f) &&  mouseX < width*(3/8f) ){
      if((mouseY - height*(1/7f))<=10){dR1=true;}
      else if((mouseY - height*(2/7f))<=10){dG1=true;}
      else if((mouseY - height*(3/7f))<=10){dB1=true;}
      else if((mouseY - height*(4/7f))<=10){dR2=true;}
      else if((mouseY - height*(5/7f))<=10){dG2=true;}
      else if((mouseY - height*(6/7f))<=10){dB2=true;}
    }
  }
  else if(moment == 'c'){moment='m';}
}

void mouseReleased(){
  if(moment == 'o'){
    dR1=false; dG1=false; dB1=false; dR2=false; dG2=false; dB2=false;
  }
  if(moment == 'e'){
    settingSize=false;
    settingEase=false;
    settingScoreRate=false;
  }
}
