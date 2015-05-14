class Editor{
  float xo, yo, tileEdge, tileRad;
  float xi, yi, xf, yf; 
  PImage CmdPtIcon, WallsIcon, TilesIcon;
  boolean creatingWall, pushed, draggingStp, deleting;
  int stpSelected;
  ArrayList<PVector>i; // temp storage for walls
  ArrayList<PVector>f;
  ArrayList<PVector>stpts2; // temp storage for starting points
  ArrayList<PVector>stpts3;
  ArrayList<PVector>stpts4;
  ArrayList<CommandPt> tempCmds;
  UISet ui, cmd, stp, til, wal;
  letter action, cmdType;
  number cmdSize, ease, wallWidth, totalPlayers;
  
  Editor(){
    tileEdge = 80;
    tileRad = tileEdge/2f;
    xo = (tileEdge*((width/tileEdge) - floor(width/tileEdge)))/2f;
    yo = (tileEdge*(((height-header)/tileEdge) - floor((height-header)/tileEdge)))/2f;
    i = new ArrayList();
    f = new ArrayList();
    stpts2 = new ArrayList();
    stpts3 = new ArrayList();
    stpts4 = new ArrayList();
    tempCmds = new ArrayList();
    
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
    cmd = new UISet( 12, 9, 13, 0.95, 0.8 );
    cmd.setScheme( #FC9C00,  30);
    cmd.addDropDown( 0, 1, "cmdPt type", 'c', cmdType );
    cmd.set.get(0).add('a', "victory", 'c');
    cmd.set.get(0).add('a', "score", 'c');
    cmd.set.get(0).add('s', "Speed", 'c');
    cmd.set.get(0).add('w', "Weight", 'c');
    cmd.set.get(0).add('l', "Lock", 'c');
    cmd.addLabel(1, 1, "Size:", 'c');
    cmd.addSlider( 2, 1, cmdSize, 20, 80 );
    cmd.addLabel(3, 1, "Ease:", 'c');
    cmd.addSlider( 4, 1, ease, 1/600f, 1/60f );
    
    totalPlayers = new number( 2 );
    stp = new UISet( 12, 9, 13, 0.95, 0.8 );
    stp.setScheme( #FC9C00,  30);
    stp.beginRow( 0, 1 );
    for( int i = 2; i <= 4; i++ ){
      stp.addNumSet( str(i)+" Players", 'c', totalPlayers, i );
    }
    
    til = new UISet( 12, 9, 13, 0.95, 0.8 );
    til.setScheme( #FC9C00,  30);
    
    wallWidth = new number( 8 );
    wal = new UISet( 12, 9, 13, 0.95, 0.8 );
    wal.setScheme( #FC9C00,  30);
    wal.addSlider( 0, 1, wallWidth, 2, 64 );
    
    ui.addCharSet(8, 0, "Done", 'c', moment, 'm');
  }
  
  void exe(){
    
    background(230);
    
      for( float y = header+yo; y < height; y += tileEdge){ // GRID
        line(0, y, width, y);
      }
      for( float x = xo; x < width; x += tileEdge){         // GRID
        line(x, header, x, height);
      }
      
      strokeWeight(5);
      for( int a = 0; a < i.size(); a++ ){                  //WALLS
        line(i.get(a).x, i.get(a).y, f.get(a).x, f.get(a).y);
      }
      strokeWeight(1);
      
      switch(int(totalPlayers.n)){
        case 2:
        for( int a = 0; a < stpts2.size(); a++ ){        // starting points
          fill(255);
          rect(stpts2.get(a).x - 10, stpts2.get(a).y - 10, 20, 20);
          fill(0);
          text("P"+str(a+1), stpts2.get(a).x - 9, stpts2.get(a).y - 10 );
        }
        break;
        case 3:
        for( int a = 0; a < stpts3.size(); a++ ){       
          fill(255);
          rect(stpts3.get(a).x - 10, stpts3.get(a).y - 10, 20, 20);
          fill(0);
          text("P"+str(a+1), stpts3.get(a).x - 9, stpts3.get(a).y - 10 );
        }
        break;
        case 4:
        for( int a = 0; a < stpts4.size(); a++ ){       
          fill(255);
          rect(stpts4.get(a).x - 10, stpts4.get(a).y - 10, 20, 20);
          fill(0);
          text("P"+str(a+1), stpts4.get(a).x - 9, stpts4.get(a).y - 10 );
        }
        break;
      }
      
      
      /*
      for(int i=0; i<10; i++){
        if(cmds.get(i).active){
          cmds.get(i).go();
        }
      }
      */
      world.step(); 
      world.draw();
      
      ui.exe();
      
       float mX = xo + tileRad * round((mouseX - xo)/tileRad);
       float mY = header + yo + tileRad * round((mouseY - header - yo)/tileRad);
      
      switch( action.l ){//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|
        case 'c': ///|\\|//|\\|//|\\|//|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|
          cmd.exe();
          
          
          if( pushed ){
            if( !mousePressed ){
              tempCmds.add( new CommandPt(cmdType.l, mX, mY, cmdSize.n, ease.n, 0) );
              pushed = false;
            }
          }
          else{
            if ( mousePressed ){
               pushed = true;
            }
          }
          
          if(mY > header){
            draw_cmd(mX, mY, cmdSize.n);
          }
          break;//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
        case 'p':////|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\   
          stp.exe();
          
          if(pushed){
            if( !mousePressed  && mouseY > header){
              switch(int(totalPlayers.n)){
                case 2:
                if( stpts2.size() < 2 ) stpts2.add(new PVector(mX, mY));
                break;
                case 3:
                if( stpts3.size() < 3 ) stpts3.add(new PVector(mX, mY));
                break;
                case 4:
                if( stpts4.size() < 4 ) stpts4.add(new PVector(mX, mY));
                break;
              }
              pushed = false;
            }
          }
          else{
            if( mousePressed && mouseY > header){
              boolean drag = false;
              switch(int(totalPlayers.n)){
                case 2:
                for( int a = 0; a < stpts2.size(); a++ ){
                  if( stpts2.get(a).x == mX && stpts2.get(a).y == mY ){
                    draggingStp = true;
                    stpSelected = a;
                    drag = true;
                  }
                }
                break;
                case 3:
                for( int a = 0; a < stpts3.size(); a++ ){
                  if( stpts3.get(a).x == mX && stpts3.get(a).y == mY ){
                    draggingStp = true;
                    stpSelected = a;
                    drag = true;
                  }
                }
                break;
                case 4:
                for( int a = 0; a < stpts4.size(); a++ ){
                  if( stpts4.get(a).x == mX && stpts4.get(a).y == mY ){
                    draggingStp = true;
                    stpSelected = a;
                    drag = true;
                  }
                }
                break;
              }
              if( !drag ) pushed = true;
            }
          }
          
          if( !mousePressed ) draggingStp = false;
          
          if(draggingStp){
            switch(int(totalPlayers.n)){
              case 2:
              stpts2.get(stpSelected).x = mX;
              stpts2.get(stpSelected).y = mY;
              break;
              case 3:
              stpts3.get(stpSelected).x = mX;
              stpts3.get(stpSelected).y = mY;
              break;
              case 4:
              stpts4.get(stpSelected).x = mX;
              stpts4.get(stpSelected).y = mY;
              break;
            }
          }
        break;   //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
        case 't'://|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\
          til.exe();
        
        break;   //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
        case 'w'://|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\ 
          wal.exe();
          
          if(creatingWall){
            strokeWeight(5);
            line(xi, yi, mX, mY);
            strokeWeight(1);
            if( mousePressed ){
              pushed = true;
            }
            else{
              if(pushed){
                pushed = false;
                creatingWall = false;
                i.add( new PVector( xi, yi ) );
                f.add( new PVector( mX, mY ) );
              }
            }
          }
          else{
            if( mousePressed ){
              pushed = true;
            }
            else{
              if(pushed){
                pushed = false;
                creatingWall = true;
                xi = mX;
                yi = mY;
              } 
            }
          }
          ellipse( mX, mY, 4, 4 ); // CURSOR
          break;
      }
    
  }
  
}

void draw_cmd( float x, float y, float s ){
  float radius = sqrt(2)*s;         
  fill(255);
  ellipse(x, y, 1.25*radius, 1.25*radius);
  ellipse(x, y, radius, radius);
  rect(x-(s/2f), y-(s/2f), s, s);
}
