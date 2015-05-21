
class Player{
  public color c; 
  public char shape, fireKey;
  float ownage, score, acc;
  public float presence;
  int wins;
  public int frozen, weighted, speeded;
  public boolean fire;
  boolean pfire;
  Item item;
  
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
    acc = 1200;
    presence = 1;
    frozen = 0;
  }
  void exe(int i){//++++++++++++++++++++++++++{}*
    if( weighted == 1 ){
      p[i].setDensity(1.0);
    }
    if( weighted > 0 ) weighted --;
    //++++++++++++++++++++++++++++++++++++++++{}*
    if( speeded == 1 ){
      acc = 1200;
    }
    if( speeded > 0 ) speeded --;
    //++++++++++++++++++++++++++++++++++++++++{}*
    if( frozen == 1 ){
      p[i].setStroke(0);
      p[i].setStrokeWeight( 1 );
    }
    if( frozen > 0 ) frozen --;
    //++++++++++++++++++++++++++++++++++++++++{}*
    if( pfire && !fire ){
      if( item.count > 0 ){
        item.exe( i, p[i].getX(), p[i].getY() );
      }
      if(item.count == 0){
        item = new Item();
      }
    }
    pfire = fire;
  }
  void receive_Item( Item it ){
    item = it.get();
  }
  void weight_bonus( FPoly p ){
    
  }
  void use_Item(){
    
  }
}
//X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>||>
//<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X||>
//X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>||>

class Map{
  float xo, yo, tileEdge, tileRad;
  int L, C;
  CommandPt[] cmds;
  Tile[][] tiles;
  //IntList spTilesX, spTilesY;
  PVector[]wall_I;
  PVector[]wall_F;
  float[]wall_W;
  PVector[] startingLocations2;
  PVector[] startingLocations3;
  PVector[] startingLocations4;
  float Acmds, scoreBar;
  Map( float TE, ArrayList<CommandPt> c, Tile[][] t, ArrayList<PVector>i, ArrayList<PVector>f, FloatList w, ArrayList<PVector>s2, ArrayList<PVector>s3, ArrayList<PVector>s4 ){
    tileEdge = TE;
    tileRad = tileEdge/2f;
    xo = (tileEdge*((width/tileEdge) - floor(width/tileEdge)))/2f;
    yo = (tileEdge*(((height-header)/tileEdge) - floor((height-header)/tileEdge)))/2f;
    L = ceil(width/tileEdge)+1;
    C = ceil((height-header)/tileEdge)+1;
    
    cmds = c.toArray( new CommandPt[c.size()] );
    
    tiles = t;   

    wall_I = i.toArray( new PVector[i.size()] );
    wall_F = f.toArray( new PVector[f.size()] );
    wall_W = w.array();//toArray( new float[w.size()] );
    
    startingLocations2 = s2.toArray( new PVector[s2.size()] );
    startingLocations3 = s3.toArray( new PVector[s3.size()] );
    startingLocations4 = s4.toArray( new PVector[s4.size()] );
  }
  void initWalls(){
    wall = new FBox[wall_I.length];
    for(int o = 0; o < wall.length; o++){
      wall[o] = new FBox(dist(wall_I[o].x, wall_I[o].y, wall_F[o].x, wall_F[o].y), wall_W[o]);
      wall[o].setRotation(atan2(wall_F[o].y - wall_I[o].y, wall_F[o].x - wall_I[o].x));
      wall[o].setPosition((wall_I[o].x+wall_F[o].x)/2f, (wall_I[o].y+wall_F[o].y)/2f);
      wall[o].setStatic(true);
      world.add(wall[o]);
    }
  }
  void exe(){
    for(int i = 0; i < p.length; i++){
        int x = floor((p[i].getX() - xo)/tileEdge)+1;
        int y = floor((p[i].getY() - header - yo)/tileEdge)+1;
        tiles[x][y].engage( i );
    }
    
    for(int x = -1; x < L-1; x++){   
      for(int y = -1; y < C-1; y++){
        tiles[x+1][y+1].exe(xo + (x * tileEdge), yo + header + (y * tileEdge), tileEdge, tileEdge);
      }
    }
    
    for(int i = 0; i < cmds.length; i++) cmds[i].exe();
    
  }
}

class Header{
  int[] ScoreRectX;
  color[] ScoreTextC;
  PImage[] Icons;
  int[] IconCountX;
  Header(){
    Icons = new PImage[6];
    Icons[0] = loadImage("Lock.png");
    Icons[1] = loadImage("Bomb.png");
    Icons[2] = loadImage("Freeze.png");
    Icons[3] = loadImage("CmdPt icon.png");
    Icons[4] = loadImage("Speed.png");
    Icons[5] = loadImage("Weight.png");
    int iconEdge = 50;
    Icons[0].resize(iconEdge, iconEdge);
    Icons[1].resize(iconEdge, iconEdge);
    Icons[2].resize(iconEdge, iconEdge);
    Icons[3].resize(iconEdge, iconEdge);
    Icons[4].resize(iconEdge, iconEdge);
    Icons[5].resize(iconEdge, iconEdge);
    
  }
}
//X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>||>
//<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X||>
//X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>||>

class CommandPt {
  float x, y, size;
  char type;
  float domination, total, scoreRate, rad;
  public int owner;
  public boolean locked;
  
  CommandPt(char type_, float x_, float y_, float size_, float total_, float scoreRate_){
    x = x_;
    y = y_;
    size = size_;
    type = type_;
    total = total_;
    owner = -1;
    domination = 0;
    scoreRate = scoreRate_;
    rad = (size * (sqrt(2)/2f) ); //+ ( square_l * (sqrt(2)/2f)) )
    locked = false;
  }
  
  void exe(){
   
    float pdom = domination;

    for( int i = 0; i < playerCount.n; i++ ){
      if( this.inside( p[i].getX(), p[i].getY() ) ){
        if( owner == i ){
          if( domination < total ){
            domination = constrain( domination + players.get(i).presence, 0, total );
          }
        }
        else if( !locked ){
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
    
    if( domination == total || domination == 0){
      if( owner >= 0 ) fill(players.get(int(owner)).c);
      else fill(255);
      ellipse( x, y, radius, radius );
    }
    else{
      fill(255);
      ellipse(x, y, radius, radius);
      if( owner >= 0 ) fill(players.get(int(owner)).c);
      else fill(255);
      arc(x, y, radius, radius, theta, 3*HALF_PI, PIE);
    }
    fill(255);
    radius /= 1.25;
    ellipse(x, y, radius, radius);
    rect(x-(size/2f), y-(size/2f), size, size);
    if( locked ) {
      fill(0);
      text("Locked", x - textWidth("locked")/2f, y -10 );
    }
  }
  boolean inside( float x_, float y_ ){
    if( dist( x_, y_, x, y ) <= rad ) return true;
    else return false; 
  }
  void instacapture( int i ){
     if(owner == i){
       domination = total; 
     }
     else{
       owner = i;
       domination = total - domination;
     }
  }
}
//X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>||>
//<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X||>
//X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>X<>||>

class Tile{
  color c;
  public float friction;
  Tile(color c_, float f ){
    c = c_;
    friction = f; 
  }
  Tile get(){ return new Tile( c, friction ); }
  void exe(float x, float y, float w, float h){
    fill( c );
    rect( x, y, w, h );
  }
  void engage( int i ){
    p[i].setDamping( friction );
  }
}
//><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><8

class ItemTile extends Tile{
  char item;
  int cooldown;
  ItemTile( color c_, float f ){
    super( c_, f );
    item = '0';
    cooldown = 180;
  }
  void exe(float x, float y, float w, float h){
    if( cooldown == 1 ){
      int r = round( random(-0.4999, 5.4999) );
      switch( r ){
        case 0: item ='l'; break;
        case 1: item ='b'; break;
        case 2: item ='f'; break;
        case 3: item ='i'; break;
        case 4: item ='s'; break;
        case 5: item ='w'; break;
      }
    }
    if( cooldown > 0 ) cooldown--;
    
    fill( c ); //currentMap.tiles[x+1][y+1].
    rect( x, y, w, h );
    switch( item ){ // ICONS
      case 'l': break;
      case 'b': break;
      case 'f': break;
      case 'i': break;
      case 's': break;
      case 'w': break;
    }
  }
  void engage( int i ){
    p[i].setDamping( friction );
    if( item != '0' ){
      switch( item ){ // ICONS
        case 'l': players.get(i).receive_Item( new Lock("Lock", 1)); break;
        case 'b': players.get(i).receive_Item( new Bomb("Bomb", 2)); break;
        case 'f': players.get(i).receive_Item( new Freeze("Freeze", 3)); break;
        case 'i': players.get(i).receive_Item( new Instacapture("Instacapture", 1)); break;
        case 's': players.get(i).receive_Item( new Speed("Speed", 1)); break;
        case 'w': players.get(i).receive_Item( new Weight("Weight", 1)); break;
      }
      item = '0';
      cooldown = 600;
    }
  }
}
//O><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O
//><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><8
//O><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O><><><><><><><><><O

class Item {
  String name;
  public int count;
  Item(){}
  Item( String n, int c ){
    name = n;
    count = c;
  }
  void exe(int a, float x, float y){}
  Item get(){ return new Item(); }
}
//:::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]&

class Lock extends Item{
  Lock( String n, int c ){
    super(n, c);
  }
  void exe(int a, float x, float y){
    for(int i = 0; i < currentMap.cmds.length; i++){
      if( currentMap.cmds[i].inside( x, y ) && currentMap.cmds[i].owner == a ){
        currentMap.cmds[i].locked = true;
        count --;
        break;
      }
    }
  }
  Lock get(){ return new Lock ( name, count ); }
}
//:::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]&

class Bomb extends Item{
  Bomb( String n, int c ){
    super(n, c);
  }
  void exe(int a, float x, float y){
    for(int i = 0; i < currentMap.cmds.length; i++){
      if( currentMap.cmds[i].inside( x, y ) ){
        if( currentMap.cmds[i].locked ){
          currentMap.cmds[i].locked = false;
        }
        // special fx
        fill(255, 0, 0);
        ellipse( x, y, 150, 150 );
        break;
      }
    }
    for(int i = 0; i < p.length; i++){
      PVector f = new PVector( p[i].getX() - x, p[i].getY() - y );
      f.setMag( map( dist(p[i].getX(), p[i].getY(), x, y ), 0, width, 100000, 0 ) );
      p[i].addForce( f.x, f.y );
    }
    count --;
  }
  Bomb get(){ return new Bomb ( name, count ); }
}
//:::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]&

class Freeze extends Item{
  Freeze( String n, int c ){
    super(n, c);
  }
  void exe(int a, float x, float y){
    for(int i = 0; i < p.length; i++){
      if( i != a ){
        float d = dist(x, y, p[i].getX(), p[i].getY() );
        if( d < 85 ){
          players.get(i).frozen = 350;
          p[i].setStroke(0, 50, 255);
          p[i].setStrokeWeight( 5 );
          p[i].setVelocity(0, 0);
        }
      }
    }
    count --;
  }
  Freeze get(){ return new Freeze ( name, count ); }
}
//:::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]&

class Instacapture extends Item{
  Instacapture( String n, int c ){
    super(n, c);
  }
  void exe(int a, float x, float y){
    for(int i = 0; i < currentMap.cmds.length; i++){
      if( currentMap.cmds[i].inside( x, y ) ){
        currentMap.cmds[i].instacapture( a );
        break;
      }
    }
    count --;
  }
  Instacapture get(){ return new Instacapture( name, count ); }
}
//:::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]&

class Speed extends Item{
  Speed( String n, int c ){
    super(n, c);
  }
  void exe(int a, float x, float y){
    players.get(a).acc += 1200;
    players.get(a).speeded = 720;
    count --;
  }
  Speed get(){ return new Speed ( name, count ); }
}
//:::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]::::::[]&

class Weight extends Item{
  Weight( String n, int c ){
    super(n, c);
  }
  void exe(int a, float x, float y){
    //world.remove(p[a]);
    //p[a] = new FPoly();
    //init_fisica_player(a, p[a], 2);
    p[a].setDensity(10);
    players.get(a).weighted = 720;
    count --;
  }
  Weight get(){ return new Weight ( name, count ); }
}
  /*
  lock
  bomb (destroys lock, stuns(?))
  freeze AOE (x3)
  instacapture
  speed
  weight
  */
