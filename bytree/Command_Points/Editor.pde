class Editor{
  float xo, yo, tileEdge, tileRad;
  float xi, yi, xf, yf; 
  PImage CmdPtIcon, WallsIcon, TilesIcon;
  boolean creatingWall, pushed, draggingStp, deleting;
  int stpSelected;
  ArrayList<PVector>i; // temp storage for walls
  ArrayList<PVector>f;
  FloatList wallWidths;
  ArrayList<PVector>stpts2; // temp storage for starting points
  ArrayList<PVector>stpts3;
  ArrayList<PVector>stpts4;
  ArrayList<CommandPt> tempCmds;
  UISet ui, cmd, stp, til, wal;
  Slider scoreRateSlider;
  letter action, type;
  number size, total, scoreRate, wallWidth, totalPlayers;
  bool delete;
  
  Editor(){
    tileEdge = 80;
    tileRad = tileEdge/2f;
    xo = (tileEdge*((width/tileEdge) - floor(width/tileEdge)))/2f;
    yo = (tileEdge*(((height-header)/tileEdge) - floor((height-header)/tileEdge)))/2f;
    i = new ArrayList();
    f = new ArrayList();
    wallWidths = new FloatList();
    stpts2 = new ArrayList();
    stpts3 = new ArrayList();
    stpts4 = new ArrayList();
    tempCmds = new ArrayList();
    
    delete = new bool();
    
    action = new letter('c');
    ui = new UISet( 12, 9, 13, 1, 0.8 );
    ui.setScheme( #FC9C00,  30);
    ui.beginRow( 0, 0 );
    ui.addCharSet("Command Points", 'c', action, 'c');
    ui.addCharSet("Starting Positions", 'c', action, 'p');
    ui.addCharSet("Tiles", 'c', action, 't');
    ui.addCharSet("Walls", 'c', action, 'w');
    
    type = new letter('a');
    size = new number( 80 );
    total = new number( 2 );
    cmd = new UISet( 12, 9, 13, 0.95, 0.8 );
    cmd.setScheme( #FC9C00,  30);
    cmd.addDropDown( 0, 1, "cmdPt type", 'c', type );
    cmd.set.get(0).add('v', "victory", 'c');
    cmd.set.get(0).add('s', "score", 'c');
    cmd.set.get(0).add('f', "Speed", 'c');
    cmd.set.get(0).add('w', "Weight", 'c');
    cmd.set.get(0).add('l', "Lock", 'c');
    cmd.addLabel(1, 1, "Size:", 'c');
    cmd.addSlider( 2, 1, size, 60, 100 );
    cmd.addLabel(3, 1, "Total:", 'c');
    cmd.addSlider( 4, 1, total, 1/600f, 1/60f );
    cmd.addToggle(8, 1, "delete", 'c', delete);
    scoreRate = new number( 10 );
    float[]d = cmd.returnDimensions( 5, 1 );
    scoreRateSlider = new Slider( d[0], d[1], d[2], d[3], scoreRate, 2, 50 );
    
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
    wal.addToggle(8, 1, "delete", 'c', delete);
    
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
      
      for( int a = 0; a < tempCmds.size(); a++ ){           //CMDS
         draw_cmd( tempCmds.get(a).x, tempCmds.get(a).y, tempCmds.get(a).size );
      }
      
      for( int a = 0; a < i.size(); a++ ){                  //WALLS
        strokeWeight(wallWidths.get(a));            
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
          if( type.l == 's' ) scoreRateSlider.exe(cmd.CS);
          
          if( delete.b ){
            if( mousePressed ){
              float sqrt2o2 = sqrt(2)*0.625;
              for( int a = 0; a < tempCmds.size(); a++ ){
                if( dist( mouseX, mouseY, tempCmds.get(a).x, tempCmds.get(a).y ) < tempCmds.get(a).size * sqrt2o2 ){
                  tempCmds.remove(a);
                }
              }
            }
          }
          else{
            if( pushed ){
              if( !mousePressed  && mouseY > header){
                boolean same = false;
                for( int a = 0; a < tempCmds.size(); a++ ){ 
                  if( mX == tempCmds.get(a).x && mY == tempCmds.get(a).y ){
                    same = true;
                    break;
                  }
                }
                if( ! same ){
                  tempCmds.add( new CommandPt(type.l, mX, mY, size.n, total.n, 0) );
                  pushed = false;
                }
              }
            }
            else{
              if ( mousePressed  && mouseY > header){
                 pushed = true;
              }
            }
            
            if(mY > header){
              draw_cmd(mX, mY, size.n);
            }
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
          
          if( delete.b ){
            if( mousePressed ){
              for( int a = 0; a < i.size(); a++ ){
                if( mX == i.get(a).x && mY == i.get(a).y ){
                  i.remove(a);
                  f.remove(a);
                }
                else if( mX == f.get(a).x && mY == f.get(a).y ){
                  i.remove(a);
                  f.remove(a);
                }
              }
            }
          }
          else{
            if(creatingWall){
              strokeWeight(wallWidth.n);
              line(xi, yi, mX, mY);
              strokeWeight(1);
              if( mousePressed ){
                pushed = true;
              }
              else{
                if(pushed  && mouseY > header){
                  pushed = false;
                  creatingWall = false;
                  i.add( new PVector( xi, yi ) );
                  f.add( new PVector( mX, mY ) );
                  wallWidths.append( wallWidth.n );
                }
              }
            }
            else{
              if( mousePressed  && mouseY > header){
                pushed = true;
              }
              else{
                if(pushed && mouseY > header){
                  pushed = false;
                  creatingWall = true;
                  xi = mX;
                  yi = mY;
                } 
              }
            }
          }
          ellipse( mX, mY, wallWidth.n, wallWidth.n ); // CURSOR
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
