class Editor{
  int W=0,C=0, wait=0;
  float xi, yi, xf, yf; //valores da criacao de paredes 
  //char Otype='a'; 
  PImage CmdPtIcon, WallsIcon, TilesIcon;
  boolean makingCmds=false, creatingWall=false, makingWalls=false, makingTiles=false, deleting=false, settingType=false, settingSize=false, settingEase=false, settingScoreRate=false;
  float Osize = 58, Oease = 1/90f, OscoreRate = 1/60f;
  UISet ui, cmd, stp, til, wal;
  letter action, cmdType;
  number cmdSize, ease, wallWidth, stpPlayer;
  
  Editor(){
    action = new letter('c');
    ui = new UISet( 12, 9, 13, 1, 0.8 );
    ui.setScheme( #FC9C00,  30);
    ui.beginRow( 0, 0 );
    ui.addCharSet("Command Points", 'c', action, 'c');
    ui.addCharSet("Starting Positions", 'c', action, 'p');
    ui.addCharSet("Tiles", 'c', action, 't');
    ui.addCharSet("Walls", 'c', action, 'w');
    
    cmdType = new letter('a');
    cmdSize = new number( 80 );
    ease = new number( 2 );
    cmd = new UISet( 12, 9, 13, 1, 0.8 );
    cmd.setScheme( #FC9C00,  30);
    cmd.beginRow( 0, 1 );  
    cmd.addDropDown( "cmdPt type", 'c', cmdType );
    cmd.set.get(0).add('a', "victory", 'c');
    cmd.set.get(0).add('s', "Speed", 'c');
    cmd.set.get(0).add('w', "Weight", 'c');
    cmd.set.get(0).add('l', "Lock", 'c');
    cmd.addSlider( cmdSize, 20, 80 );
    cmd.addSlider( ease, 1/600f, 1/60f );
    
    stpPlayer = new number( 0 );
    stp = new UISet( 12, 9, 13, 1, 0.8 );
    stp.setScheme( #FC9C00,  30);
    cmd.beginRow( 0, 1 );
    for( int i = 0; i < playerCount.n; i++ ){
      stp.addNumSet( "P"+str(i+1), 'c', stpPlayer, i );
    }
    
    til = new UISet( 12, 9, 13, 1, 0.8 );
    til.setScheme( #FC9C00,  30);
    
    wallWidth = new Number( 8 );
    wal = new UISet( 12, 9, 13, 1, 0.8 );
    wal.setScheme( #FC9C00,  30);
    wal = addSlider( 0, 1, wallWidth, 2, 64 );
    
    ui.addCharSet(8, 0, "Done", 'c', moment, 'm');
  }
  
  void exe(){
    
    background(230);
      
      for(int i=0; i<10; i++){
        if(cmds.get(i).active){
          cmds.get(i).go();
        }
      }
      
      world.step(); 
      world.draw();
      
      
      if(makingCmds){                  //criando commands
        if(wait>0){wait--;}                           //este wait eh para se certificar de que, quando voce seleciona outro tipo de command, 
        float radius = 1.25*sqrt(2)*Osize/2f;         //voce nao acidentalmente coloca um command em baixo daquela janelinha de selecao, entao ele nao deixa criar por [wait] frames.
        if((mouseY > 50+radius)&&(mouseY < height-radius)&&(mouseX > radius)&&(mouseX < width-radius)){
        fill(255);
        ellipse(mouseX, mouseY, 1.25*sqrt(2)*Osize, 1.25*sqrt(2)*Osize);
        ellipse(mouseX, mouseY, sqrt(2)*Osize, sqrt(2)*Osize);
        rect(mouseX, mouseY, Osize, Osize);
        }
        
        textFont(small, 22);            //seletor de tipo
        if(settingType){fill(210);}
        else if(mouseX>135 && mouseX<225 && mouseY>11 && mouseY<39){fill(190);}
        else {fill(150);}
        rect(180, 25, 90, 28);
        fill(255);text("type:  "+Otype, 156, 32);
        if(settingType){
          fill(160);
          rect(180, 123, 90, 168);
          fill(0);
          text("a", 175, 60); text("b", 175, 88); text("c", 175, 116); text("d", 175, 144); text("s", 175, 172); text("w", 174, 199);
          line(135, 67, 225, 67); line(135, 95, 225, 95); line(135, 123, 225, 123); line(135, 151, 225, 151); line(135, 179, 225, 179);
        }
        
        fill(150);                 //slider de tamanho
        rect(300, 25, 130, 28);
        fill(255);text("size:", 241, 32);
        fill(160);rect(317, 25, 86, 16);
        fill(170);rect(map(Osize, 20, 80, 274, 360), 25, 8, 20);
        if(settingSize){
          Osize = map(mouseX, 274, 360, 20, 80);
          Osize = constrain(Osize, 20, 80);
        }
        
        fill(150);                  //slider de facilidade (ease)
        rect(440, 25, 130, 28);
        fill(255);text("ease:", 378, 32);
        fill(160);rect(458, 25, 86, 16);
        fill(170);rect(map(Oease, 1/600f, 1/60f, 415, 501), 25, 8, 20);
        if(settingEase){
          Oease = map(mouseX, 415, 501, 1/600f, 1/60f);
          Oease = constrain(Oease, 1/600f, 1/60f);
        }
        
        if(Otype == 'b' || Otype == 'c' || Otype == 'd'){       //slider de taxa de pontuacao, soh eh ativo nos tipos relevantes
          fill(150);
          rect(562.5, 25, 95, 28);
          fill(255);text("rate:", 520, 32);
          fill(160);rect(580, 25, 50, 16);
          fill(170);rect(map(OscoreRate, 1/180f, 5/60f, 555, 605), 25, 8, 20);
          if(settingScoreRate){
            OscoreRate = map(mouseX, 555, 605, 1/180f, 5/60f );
            OscoreRate = constrain(OscoreRate, 1/180f, 5/60f);
          }
        }
        
      }
      else if(creatingWall){
        strokeWeight(5);  //faz aquela linha preta pra vizualizar a parede que voce esta criando. a criacao em si acontece no mousePressed()
        line(xi, yi, mouseX, mouseY);
        strokeWeight(1);
      }
      
      fill(150);
      rect(width-25, 25, 30, 30);
      rect(width-65, 25, 30, 30);
    
  }
  
}
