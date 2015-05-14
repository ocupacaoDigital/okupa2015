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
  if(keyCode==BACKSPACE){moment.l='m';}
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

}

void mouseReleased(){

}
