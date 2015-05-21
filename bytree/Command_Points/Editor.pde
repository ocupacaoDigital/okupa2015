class Editor{
  float xo, yo, tileEdge, tileRad;
  int L, C;
  float xi, yi, xf, yf; 
  PImage CmdPtIcon, WallsIcon, TilesIcon;
  boolean creatingWall, pushed, draggingStp, deleting;
  int stpSelected;
  ArrayList<PVector>i; // temp storage for walls
  ArrayList<PVector>f;
  FloatList wallWidths;
  Tile[] templates;
  Tile[][] tiles;
  ArrayList<PVector>stpts2; // temp storage for starting points
  ArrayList<PVector>stpts3;
  ArrayList<PVector>stpts4;
  ArrayList<CommandPt> tempCmds;
  UISet ui, cmd, stp, til, wal;
  Slider scoreRateSlider;
  letter action, type, tileType;
  number size, total, scoreRate, wallWidth, totalPlayers;
  bool delete, done;
  
  Editor(int o){}
  Editor(){
    tileEdge = 70;
    tileRad = tileEdge/2f;
    xo = (tileEdge*((width/tileEdge) - floor(width/tileEdge)))/2f;
    yo = (tileEdge*(((height-header)/tileEdge) - floor((height-header)/tileEdge)))/2f;
    
    i = new ArrayList();
    f = new ArrayList();
    wallWidths = new FloatList();
    
    templates = new Tile[5];
    templates[0] = new Tile( #989079, 1.5 );
    templates[1] = new Tile( #C2E8E8, 0 );
    templates[2] = new Tile( #C1935A, 5 );
    templates[3] = new Tile( #69E064, 1.5 );
    templates[4] = new Tile( #F28D20, 1.5 );
    L = ceil(width/tileEdge)+1;
    C = ceil((height-header)/tileEdge)+1;
    tiles = new Tile[L][C];
    for(int x = 0; x < L; x++){
      for(int y = 0; y < C; y++){
        tiles[x][y] = templates[0].get();
      }
    }
    
    stpts2 = new ArrayList();
    stpts3 = new ArrayList();
    stpts4 = new ArrayList();
    
    tempCmds = new ArrayList();
    
    delete = new bool();
    done = new bool();
    
    action = new letter('c');
    ui = new UISet( 12, 9, 13, 1, 0.8 );
    ui.setScheme( #FC9C00,  30);
    ui.beginRow( 0, 0 );
    ui.addCharSet("Command Points", 'c', action, 'c');
    ui.addCharSet("Starting Positions", 'c', action, 'p');
    ui.addCharSet("Tiles", 'c', action, 't');
    ui.addCharSet("Walls", 'c', action, 'w');
    //ui.addCharSet(8, 0, "Done", 'c', moment, 'm');
    ui.addToggle(8, 0, "Done", 'c', done);
    
    type = new letter('a');
    size = new number( 80 );
    total = new number( 300 );
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
    cmd.addSlider( 4, 1, total, 100, 500 );
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
    
    tileType = new letter('c');
    til = new UISet( 12, 9, 13, 0.95, 0.8 );
    til.setScheme( #FC9C00,  30);
    til.beginRow(0, 1);
    til.addCharSet("concrete", 'c', tileType, 'c' );
    til.addCharSet("ice", 'c', tileType, 'i' );
    til.addCharSet("mud", 'c', tileType, 'm' );
    til.addCharSet("Item", 'c', tileType, 'b' );
    til.addCharSet("Trap", 'c', tileType, 't' );
    
    wallWidth = new number( 8 );
    wal = new UISet( 12, 9, 13, 0.95, 0.8 );
    wal.setScheme( #FC9C00,  30);
    wal.addSlider( 0, 1, wallWidth, 2, 64 );
    wal.addToggle(8, 1, "delete", 'c', delete);
    
  }
  
  void exe(){//$S$S$S*$S$S$S$S$S$S$*S$S$S$S$S$S$S$S$S*$S$S$S$S$S$S$S$S$S*$S$S$S$S$S$S$S$S*$S$S$S$S$S$S$S$*S$S$S$S$S$S$S$S$S$S$S$S*$S$S$S$S$S$S$S$S$S$S$S$S$
      
      this.display();
      
      fill(255);
      rect(0, 0, width, header);
      
      ui.exe();
      
      if( done.b ){
        currentMap = new Map(tileEdge, tempCmds, tiles, i, f, wallWidths, stpts2, stpts3, stpts4);      
        moment.l = 'm';
        done.b = false;
      }
      
     float mX = xo + tileRad * round((mouseX - xo)/tileRad);
     float mY = header + yo + tileRad * round((mouseY - header - yo)/tileRad);
      
      switch( action.l ){//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|
        case 'c': ///|\\|//|\\|//|\\|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|
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

          if( mousePressed  && mouseY > header){
            int x = floor((mouseX - xo)/tileEdge)+1;
            int y = floor((mouseY - header - yo)/tileEdge)+1;
            switch(tileType.l){
              case 'c': tiles[x][y] = templates[0]; break; // concrete
              case 'i': tiles[x][y] = templates[1]; break; // ice
              case 'm': tiles[x][y] = templates[2]; break; // mud
              case 'b': tiles[x][y] = templates[3]; break; // bonus
              case 't': tiles[x][y] = templates[4]; break; // trap
            }
            pushed = false;
          }
        
        break;   //|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//
        case 'w'://|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\|//|\\ 
          wal.exe();
          
          if( delete.b ){
            if( mousePressed ){
              for( int a = 0; a < i.size(); a++ ){
                if( mX == i.get(a).x && mY == i.get(a).y ){
                  i.remove(a);
                  f.remove(a);
                  wallWidths.remove(a);
                }
                else if( mX == f.get(a).x && mY == f.get(a).y ){
                  i.remove(a);
                  f.remove(a);
                  wallWidths.remove(a);
                }
              }
            }
            fill(255, 0, 0);
            ellipse( mX, mY, wallWidth.n, wallWidth.n ); // CURSOR
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
            fill(0);
            ellipse( mX, mY, wallWidth.n, wallWidth.n ); // CURSOR
          }
          
          break; //',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',
      }//',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',',
    
  }
  void display(){
    
    for(int x = -1; x < L-1; x++){                        //TILES
      for(int y = -1; y < C-1; y++){
        fill( tiles[x+1][y+1].c );
        rect( xo + (x * tileEdge), yo + header + (y * tileEdge), tileEdge, tileEdge);
      }
    }    
    /*
    for( float y = header+yo; y < height; y += tileEdge){ // GRID
      line(0, y, width, y);
    }
    for( float x = xo; x < width; x += tileEdge){
      line(x, header, x, height);
    }
    */
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
  }
}

void draw_cmd( float x, float y, float s ){
  float radius = sqrt(2)*s;         
  fill(255);
  ellipse(x, y, 1.25*radius, 1.25*radius);
  ellipse(x, y, radius, radius);
  rect(x-(s/2f), y-(s/2f), s, s);
}
