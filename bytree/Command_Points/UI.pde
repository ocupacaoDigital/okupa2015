/*
ColorScheme( color root, float contrast )

UISet( float m, float l, float c )
UISet( float m, float l, float c, float h, float v )
  setScheme(color root, float contrast )
  beginColumn(int l, int c)
  beginRow(int l, int c)
  displayGrid()
  exe()
  addLabel(float x, float y, String s)
  addLabel(int l, int c, String s, char p)
  addLabel(int l, int c, letter inc)
  addElement( UIElement E )
  addToggle(int l, int c, String label, char p, bool i)
  addNumSet(int l, int c, String label, char p, number i, float s)
  addCharSet(int l, int c, String label, char p, letter i, char s)
  addNumAdd(int l, int c, number i, float step, float min, float max)
  addPlusMinus(int l, int c, number i, boolean integer, float step, float min, float max)
  addSlider(int l, int c,  number i, float min, float max)
  addDropDown(int l, int c,  String label, char p, letter i)
  addYanker(int l, int c,  number i, float dom, float exp, float coeff, float min, float max)
  addColorSelector(int l, int c)

Static_String_Label(String st, char p, float x_, float y_, float w, float h)
Dynamic_Word_Label(word w_, char p, float x_, float y_, float w, float h)
Dynamic_Number_Label(number i, char p, float x_, float y_, float w, float h)
Dynamic_Letter_Label(letter i, char p, float x_, float y_, float w, float h)
*/
int textsize;

class number {
  public float n;
  number() {
  }
  number(float n) {
    this.n = n;
  }
}
class bool {
  public boolean b;
  bool() {
  }
  bool(boolean a) {
    b = a;
  }
}
class letter {
  public char l;
  letter() {
  }
  letter(char l) {
    this.l = l;
  }
}
class word {
  public String w;
  word() {
  }
  word(String w) {
    this.w = w;
  }
}
class pigment {
  public color p;
  pigment() {
  }
  pigment(color p) {
    this.p = p;
  }
}
//()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H
//)H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H(

class ColorScheme{
  public color dimmer, dim, bright, brighter;
  ColorScheme(){}
  ColorScheme( color root, float contrast ){
    dimmer = color( red(root) - 1.5*contrast, green(root) - 1.5*contrast, blue(root) - 1.5*contrast );
    dim = color( red(root) - 0.5*contrast, green(root) - 0.5*contrast, blue(root) - 0.5*contrast );
    bright = color( red(root) + 0.5*contrast, green(root) + 0.5*contrast, blue(root) + 0.5*contrast );
    brighter = color( red(root) + 1.5*contrast, green(root) + 1.5*contrast, blue(root) + 1.5*contrast );
  }
}

//()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H
//)H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H()H(

class UISet{
  ColorScheme CS;
  public float margin, line, column, H_percent, V_percent;
  ArrayList<UIElement> set;
  ArrayList<Label> labels;
  boolean columning, rowing;
  int i, j, c; // counters for columning/lining
  UISet( float m, float l, float c ){
    margin = m;
    line = (width - 2 * margin)/l;
    column = (height - 2 * margin)/c;
    H_percent = 1;
    V_percent = 1;
    set = new ArrayList();
  }
  UISet( float m, float l, float c, float h, float v ){
    margin = m;
    line = (width - 2 * margin)/l;
    column = (height - 2 * margin)/c;
    H_percent = h;
    V_percent = v;
    set = new ArrayList();
    labels  = new ArrayList();
  }
  void setScheme(color root, float contrast ){
    CS = new ColorScheme(root, contrast);
  }
  void beginColumn(int l, int c){
    columning = true;
    rowing = false;
    i = l;
    j = c;
    c = 0;
  }
  void beginRow(int l, int c){
    rowing = true;
    columning = false;
    i = l;
    j = c;
    c = 0;
  }
  void endRow(){rowing = false;}
  void endColumn(){columning = false;}
  
  void displayGrid(){
    rect( margin, margin, width - 2 * margin, height - 2 * margin );
    for(float x = margin; x < width - margin; x += line){
      line(x, margin, x,  height - margin);
    }
    for(float y = margin; y < height - margin; y += column){
      line(margin, y, width - margin, y);
    }
  }
  /* cannot be declared static; static methods can only be declared in a static or top level type
  static float[] returnDimensions( int l, int c, float m, float l, float c, float h, float v ){
    float[] d = new float[4];
    d[2] = (width - 2 * m)/l;
    d[3] = (height - 2 * m)/c;
    d[0] = m + (l * d[2]) + ( ( (ceil(h) - h) * d[2] ) / 2f );
    d[1] = m + (c * d[3]) + ( ( (ceil(v) - v ) * d[3]) / 2f );    
    return d;
  }
  */
  float[] returnDimensions( int l, int c ){
    float[] d = new float[4];
    d[0] = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    d[1] = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    d[2] = line * H_percent;
    d[3] = column * V_percent;    
    return d;
  }
  
  void exe(){
    textAlign(LEFT, TOP);
    for(int i = 0; i < set.size(); i++){
      set.get(i).exe(CS);
    }
    for(int i = 0; i < labels.size(); i++){
      labels.get(i).display();
    }
  }
  void addLabel(Label l){
    labels.add( l );
  }
  
  void addLabel(float x, float y, String s){
    labels.add( new Label( s, '0', x, y, 0, 0) );
  }
  
  void addLabel(int l, int c, String s, char p){
    float x = margin + (l * line);
    float y = margin + (c * column);
    labels.add( new Static_String_Label( s, p, x, y, line, column) );
  }
  
  void addLabel(int l, int c, letter inc){
    float x = margin + (l * line);
    float y = margin + (c * column);
    labels.add( new Dynamic_Letter_Label( inc, 'c', x, y, line, column) );
  }
  
  UIElement get( String s ){
    for(int i = 0; i < set.size(); i++){
      if( s.equals( set.get(i).label.returnS() ) ){
        return set.get(i);
      }
    }
    return null;
  }
  
  void remove( String s ){
    for(int i = 0; i < set.size(); i++){
      if( s.equals( set.get(i).label.returnS() ) ){
        set.remove(i);
        break;
      }
    }
  }
  
  void addElement( UIElement E ){
    set.add( E );
  }
  
  void addToggle(int l, int c, String label, char p, bool i) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new ToggleButton( x, y, H_percent * line, V_percent * column, label, p, i) );
  }
  
  void addToggle(String label, char p, bool inc) {
    if( columning ){
      this.addToggle( i, j + c, label, p, inc );
      c++;
    }
    else if( rowing ){
      this.addToggle( i + c, j, label, p, inc );
      c++;
    }
    else println( "addToggle", label, "failed: not columning nor rowing." );
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addNumSet(int l, int c, String label, char p, number i, float s) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new NumSetButton( x, y, H_percent * line, V_percent * column, label, p, i, s) );
  }
  void addNumSet(String label, char p, number inc, float s) {
    if( columning ){
      this.addNumSet( i, j + c, label, p, inc, s );
      c++;
    }
    else if( rowing ){
      this.addNumSet( i + c, j, label, p, inc, s );
      c++;
    }
    else println( "addNumSet failed: not columning nor rowing." );
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addCharSet(int l, int c, String label, char p, letter i, char s) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new CharSetButton( x, y, H_percent * line, V_percent * column, label, p, i, s) );
  }
  void addCharSet(String label, char p, letter inc, char s) {
    if( columning ){
      this.addCharSet( i, j + c, label, p, inc, s );
      c++;
    }
    else if( rowing ){
      this.addCharSet( i + c, j, label, p, inc, s );
      c++;
    }
    else println( "addCharSet failed: not columning nor rowing." );
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addNumAdd(int l, int c, number i, float step, float min, float max) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new NumAddButton( x, y, H_percent * line, V_percent * column, i, step, min, max) );
  }
  void addNumAdd(number inc, float step, float min, float max) {
    if( columning ){
      this.addNumAdd( i, j + c, inc, step, min, max);
      c++;
    }
    else if( rowing ){
      this.addNumAdd( i + c, j, inc, step, min, max);
      c++;
    }
    else println( "addNumAdd failed: not columning nor rowing." );
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addPlusMinus(int l, int c, number i, boolean integer, float step, float min, float max) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new PlusMinus( x, y, H_percent * line, V_percent * column, i, integer, step, min, max ) );
  }
  void addPlusMinus( number inc, boolean integer, float step, float min, float max ) {
    if( columning ){
      this.addPlusMinus( i, j + c, inc, integer, step, min, max);
      c++;    }
    else if( rowing ){
      this.addPlusMinus( i + c, j, inc, integer, step, min, max);
      c++;
    }
    else println( "addPlusMinus failed: not columning nor rowing." );
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addSlider(int l, int c,  number i, float min, float max) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new Slider( x, y, H_percent * line, V_percent * column, i, min, max) );
  }
  void addSlider( number inc, float min, float max) {
    if( columning ){
      this.addSlider( i, j + c, inc, min, max);
      c++;
    }
    else if( rowing ){
      this.addSlider( i + c, j, inc, min, max);
      c++;
    }
    else println( "addSlider failed: not columning nor rowing." );
  }
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addDropDown(int l, int c,  String label, char p, letter i){
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new DropDown( x, y, H_percent * line, V_percent * column, label, p, i ) );
  }
  void addDropDown( String label, char p, letter inc){
    if( columning ){
      this.addDropDown( i, j + c,  label, p, inc );
      c++;
    }
    else if( rowing ){
      this.addDropDown( i + c, j, label, p, inc );
      c++;
    }
    else println( "addDropDown", label, "failed: not columning nor rowing." );
  }  
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addYanker(int l, int c,  number i, float dom, float exp, float coeff, float min, float max) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new Yanker( x, y, H_percent * line, V_percent * column, i, dom, exp, coeff, min, max) );
  }
  void addYanker( number inc, float dom, float exp, float coeff, float min, float max) {
    if( columning ){
      this.addYanker( i, j + c, inc, dom, exp, coeff, min, max);
      c++;
    }
    else if( rowing ){
      this.addYanker( i + c, j, inc, dom, exp, coeff, min, max);
      c++;
    }
    else println( "addYanker failed: not columning nor rowing." );
  }    
  //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  void addColorSelector(int l, int c, pigment p) {
    float x = margin + (l * line) + ( ( (ceil(H_percent) - H_percent) * line ) / 2f );
    float y = margin + (c * column) + ( ( (ceil(V_percent) - V_percent ) * column) / 2f );
    set.add( new ColorSelector( x, y, H_percent * line, V_percent * column, p) );
  }
  void addColorSelector(pigment p) {
    if( columning ){
      this.addColorSelector( i, j + c, p);
      c++;
    }
    else if( rowing ){
      this.addColorSelector( i + c, j, p);
      c++;
    }
    else println( "addColorSelector failed: not columning nor rowing." );
  }   
}

//~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
// ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
//  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~


class Label{
  float x, y;
  public color c;
  Label(){}
  Label(String st, char p, float x_, float y_, float w, float h){
    int pad = 4;
    switch(p){
      case '0':
        x = x_;
        y = y_;
        break;
      case 'a': //above i.e. TOP, LEFT
        x = x_ + pad;
        y = y_ - textsize -pad; 
        break;
      case 'b': //below i.e. BOTTOM, LEFT
        x = x_ + pad;
        y = y_ + h + pad; 
        break;
      case 'l': //left 
        x = x_ + pad;
        y = y_ + ((h - textsize)/2f) - floor(textsize/4f) ;
        break;
      case 'r': //right
        x = x_ + w + pad;
        y = y_ + ((h - textsize)/2f) - floor(textsize/4f) ;
        break;
      case 'c': //centered
        x = x_ + (w/2f) - (textWidth(st)/2f);
        y = y_ + ((h - textsize)/2f) - floor(textsize/4f) ;
        break;  
       case 'm': //middle
        x = x_ + (w/2f);
        y = y_ + (h/2f);
        break; 
    }
    c = color(0);
  }
  void display(){}
  String returnS(){ return " "; }
}

// \|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\

class Static_String_Label extends Label{
  public String s;
  Static_String_Label(String st){s = st;}
  Static_String_Label(String st, char p, float x_, float y_, float w, float h){
    super(st, p, x_, y_, w, h);
    s = st;
  }
  void display(){
    fill(c);
    text(s, x, y);
  }
  String returnS(){ return s; }
}

// \|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\

class Dynamic_Word_Label extends Label{
  public word w;
  Dynamic_Word_Label(word w_, char p, float x_, float y_, float w, float h){
    super(w_.w, p, x_, y_, w, h);
    this.w = w_;
  }
  void display(){
    fill(c);
    text(w.w, x, y);
  }
}

// \|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\

class Dynamic_Number_Label extends Label{
  number incumbency;
  Dynamic_Number_Label(number i, char p, float x_, float y_, float w, float h){
    super("0", p, x_, y_- textsize/2f, w, h);
    incumbency = i;
  }
  void display(){
    fill(c);
    String s = str(int(incumbency.n));
    text( s, x - textWidth(s)/2f , y );
  }
}

// \|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\|/|\

class Dynamic_Letter_Label extends Label{
  letter incumbency;
  Dynamic_Letter_Label(letter i, char p, float x_, float y_, float w, float h){
    super("a", p, x_, y_, w, h);
    incumbency = i;
  }
  void display(){
    fill(c);
    text(str(incumbency.l), x, y);
  }
}
//8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8
// 8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8
//  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8

class UIElement {
  float x, y, w, h;
  boolean pushed;
  public Label label;
  UIElement(float x, float y, float w, float h){ // p = label position
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    //label = new Label(l, p, x, y, w, h);
  }
  boolean mouse_over(){
    if (mouseX>x && mouseX<(x+w) && mouseY>y && mouseY<(y+h))return true;
    else return false;
  }
  void Rect(){
    rect(x, y, w, h);
  }
  void exe(ColorScheme CS){}
  void add(char set, String label, char pos){}
  void setColor( color c ){}
}

//8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8
// 8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8
//  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8

class ToggleButton extends UIElement {
  bool incumbency;
  ToggleButton(float x, float y, float w, float h, String label_, char p, bool i) {
    super(x, y, w, h);
    label = new Static_String_Label( label_, p, x, y, w, h );
    incumbency = i;
  }
  void exe(ColorScheme CS){
    if ( mouse_over() ) {
      fill(CS.bright);
      if (mousePressed) {
        pushed = true;
      }
    }
    else {
      fill(CS.dim);
    }
    if (!mousePressed && pushed) {
      incumbency.b = !incumbency.b;
      pushed = false;
    }
    if (incumbency.b) {
      fill(CS.brighter);
    }
    super.Rect();
    super.label.display();
  }
}

//==================================================================================

class NumSetButton extends UIElement {
  number incumbency;
  float set;
  NumSetButton(float x, float y, float w, float h, String label_, char p, number i, float s) {
    super(x, y, w, h);
    incumbency = i;
    set = s;
    label = new Static_String_Label(label_, p, x, y, w, h);
  }
  void exe(ColorScheme CS){
    if ( mouse_over() ) {
      fill(CS.bright);
      if (mousePressed) {
        pushed = true;
      }
    }
    else {
      fill(CS.dim);
    }
    if (!mousePressed && pushed) {
      incumbency.n = set;
      pushed = false;
    }
    if (this.on()) {
      fill(CS.brighter);
    }
    super.Rect();
    label.display();
  }
  boolean on() {
    if (incumbency.n == set) {
      return true;
    }
    else return false;
  }
}

//==================================================================================

class CharSetButton extends UIElement {
  letter incumbency;
  public char set;
  CharSetButton(float x, float y, float w, float h, String label_, char p, letter i, char s) {
    super(x, y, w, h);
    incumbency = i;
    set = s;
    label = new Static_String_Label(label_, p, x, y, w, h);
  }
  void exe(ColorScheme CS){
    if ( mouse_over() ) {
      fill(CS.bright);
      if (mousePressed) {
        pushed = true;
      }
    }
    else {
      fill(CS.dim);
    }
    if (!mousePressed && pushed) {
      incumbency.l = set;
      pushed = false;
    }
    if (this.on()) {
      fill(CS.brighter);
    }
    super.Rect();
    super.label.display();
  }
  boolean on() {
    if (incumbency.l == set) {
      return true;
    }
    else return false;
  }
}

//==================================================================================

class DropDown extends UIElement{
  public ArrayList<CharSetButton> b;
  boolean open;
  letter incumbency;
  DropDown(float x, float y, float w, float h, String label_, char p, letter i){
    super(x, y, w, h);
    b = new ArrayList();
    incumbency = i; 
    label = new Static_String_Label(label_, p, x, y, w, h);
  }
  void add(char set, String label, char pos){
    b.add( new CharSetButton(x, y + ( (b.size()+1) * h ), w, h, label, pos, incumbency, set) );
  }
  void exe(ColorScheme CS){
    if(mouse_over()){
      fill(CS.bright);
      if(mousePressed){
        pushed = true; 
      }
    }
    else{ fill(CS.dim);}
    if(!mousePressed && pushed){
      open = !open;
      pushed = false;
    }
    if(open){
      for(int i = 0; i < b.size(); i++){
        if(!mousePressed &&  b.get(i).pushed )open = false; 
        b.get(i).exe(CS);
      }
      fill(CS.bright);
    }
    
    if( on() ) fill(CS.brighter); 
    
    super.Rect();
    super.label.display();
  }
  boolean on(){
    for(int i = 0; i < b.size(); i++) if(b.get(i).on()) return true;
    
    return false;
  }
}

//==================================================================================

class NumAddButton extends UIElement {
  number incumbency;
  float step, min, max;
  boolean warp;
  NumAddButton(float x, float y, float w, float h, number i, float step, float min, float max) {
    super(x, y, w, h);
    incumbency = i;
    this.step = step;
    if( min == max ){
      warp = false;
    }
    else{
      this.min = min;
      this.max = max;
      warp = true;
    }
  }
  NumAddButton(float x, float y, float w, float h, number i, float step) {
    super(x, y, w, h);
    incumbency = i;
    this.step = step;
    warp = false;
  }
  void exe(ColorScheme CS){
    if ( super.mouse_over() ) {
      fill(CS.bright);
      if (mousePressed) {
        pushed = true;
      }
    }
    else { 
      fill(CS.dim);
    }
    if (!mousePressed && pushed) {
      if (warp) {
        if (incumbency.n > max - step && step > 0) {
          incumbency.n = min;
        }
        else if (incumbency.n < min - step && step < 0) {
          incumbency.n = max;
        }
      }
      incumbency.n += step;
      
      fill(CS.brighter);
      pushed = false;
    }
    super.Rect();
    fill(0);
    if (step > 0) rect(x+(0.4*w), y+0.1*h, 0.2*w, 0.8*h);
    rect(x+(0.1*w), y+0.4*h, 0.8*w, 0.2*h);
  }
}

//==================================================================================

class PlusMinus extends UIElement{
  number incumbency;
  NumAddButton plus;
  NumAddButton minus;
  boolean integer;
  PlusMinus(float x, float y, float w, float h, number i, boolean integer, float step, float min, float max){
    super( x+h, y, w-(2*h), h );
    incumbency = i;
    this.integer = integer;
    plus = new NumAddButton(x + (w-h), y, h, h, i, step, min, max);
    minus = new NumAddButton(x, y, h, h, i, -step, min, max);
    label = new Dynamic_Number_Label( i, 'm', x, y, w, h );
  }
  PlusMinus(float x, float y, float w, float h, number i, boolean integer, float step) {
    super(x+h, y, w-(2*h), h);
    incumbency = i; 
    this.integer = integer;
    plus = new NumAddButton(x + (w-h), y, h, h, i, step);
    minus = new NumAddButton(x, y, h, h, i, -step);
    label = new Dynamic_Number_Label( i, 'm', x, y, w, h );
  }
  void exe(ColorScheme CS){
    plus.exe(CS);
    minus.exe(CS);    
    //label.s = (integer)? str(int(incumbency.n)) : str(incumbency.n);
    fill(CS.dimmer);
    super.Rect();
    super.label.display();
  }
}

//==================================================================================

class Slider extends UIElement {
  number incumbency;
  float min, max;
  Slider(float x, float y, float w, float h, number i, float min, float max) {
    super(x, y, w, h);
    incumbency = i;
    this.min = min;
    this.max = max;
  }
  void exe(ColorScheme CS){
    fill(CS.dimmer);
    super.Rect();
    //super.label.display();
    if ( super.mouse_over() ) {
      if (mousePressed) {
        incumbency.n = map(mouseX, x+4, x+w-4, min, max);
        incumbency.n = constrain(incumbency.n, min, max);
        fill(CS.brighter);
      }
      fill(CS.bright);
    }
    else{fill(CS.dim);}
    rect(map(constrain(incumbency.n, min, max), min, max, x+4, x+w-4)-4, y-1, 8, h+2);
  }
}

//==================================================================================

class subSlider extends UIElement {
  public float n;
  float min, max;
  boolean dragging, outpressed;
  subSlider(float x, float y, float w, float h, float min, float max) {
    super(x, y, w, h);
    //n = max/2f;
    n = min;
    this.min = min;
    this.max = max;
  }
  void exe() {
    boolean mo = mouse_over();
    if( !mo && mousePressed) outpressed = true;
    if ( mousePressed ) {
      if ( mo && !outpressed) {
        dragging = true;
      }
    }
    else{
      dragging = false;
      outpressed = false;
    }
    if(dragging) n = map(constrain(mouseY, y+4, y+h-4), y+h-4, y+4, min, max);
  }
  void display(ColorScheme CS){
    fill(CS.brighter);
    rect(x, map(n, min, max, y+h-6, y+3)-3, w, 6);
  }
}

//==================================================================================

class ColorSelector extends UIElement {
  pigment incumbency;
  subSlider red, green, blue;
  float bw;
  float bh;
  float N;
  float margin;
  ColorSelector(float x, float y, float w, float h, pigment p) {
    super(x, y, w, h);
    incumbency = p;
    margin = 2;
    bw = (w - (4*margin))/3f;
    bh = (h - (w/3f)) - 3*margin;
    red =   new subSlider(margin + x, y, bw, bh, 0, 255);
    green = new subSlider(2*margin + bw + x , y, bw, bh, 0, 255);
    blue =  new subSlider(3*margin + 2*bw + x, y, bw, bh, 0, 255);
    N = 90;
    label = new Static_String_Label("colorSelector");
  }
  void setColor( color c ){
    red.n = red(c);
    green.n = green(c);
    blue.n = blue(c);
  }
  void exe(ColorScheme CS){
    red.exe();
    green.exe();
    blue.exe();
    incumbency.p = color(red.n, green.n, blue.n);
    
    fill(0);stroke(0);
    Rect();
    
    for(float i = 1; i<=N ; i++){
      color co = lerpColor(color(255, green(incumbency.p), blue(incumbency.p)), color(0, green(incumbency.p), blue(incumbency.p)), i/N);
      fill(co);stroke(co);
      rect(x + margin, y + margin + ((i-1)*(bh/N)), bw, bh/N);
    }
    x += bw+margin;
    for(float i = 1; i<=N ; i++){
      color co = lerpColor(color(red(incumbency.p), 255, blue(incumbency.p)), color(red(incumbency.p), 0, blue(incumbency.p)), i/N);
      fill(co);stroke(co);
      rect(x + margin, y + margin + ((i-1)*(bh/N)), bw, bh/N);
    }
    x += bw+margin;
    for(float i = 1; i<=N ; i++){
      color co = lerpColor(color(red(incumbency.p), green(incumbency.p), 255), color(red(incumbency.p), green(incumbency.p), 0), i/N);
      fill(co);stroke(co);
      rect(x + margin, y + margin + ((i-1)*(bh/N)), bw, bh/N);
    }
    x -= 2*(bw+margin);
    stroke(0);
    red.display(CS);
    green.display(CS);
    blue.display(CS);
    fill(incumbency.p);
    rect(x + margin, y + bh + 3*margin, w - 2*margin, (w/3f) -2*margin); //+ 7.5*margin
  }
}

//==================================================================================

class Yanker extends UIElement {
  number incumbency;
  float min, max, X, domain, exp, coeff, zero;
  boolean held;
  PGraphics lines;
  Yanker(float x, float y, float w, float h, number i, float d, float e, float c, float min, float max) {
    super(x, y, w, h);
    incumbency = i;
    domain = d;
    exp = e;
    zero = (exp == 0)? 0 : 1;
    coeff = c;
    this.min = min;
    this.max = max;
    
    lines = createGraphics(int(w), int(h));
    lines.beginDraw();
    int l = ceil((w-10)/4f);
    float eqs = map(w, 4, w-4, -domain, domain);
    float m = exp_term(eqs) + eqs*coeff;
    float hh = h/2f;
    for(int n = 0; n < l; n++){
      int mx = 6+(n*4);
      eqs = map(mx, 4, w-4, -domain, domain);
      float wai = exp_term(eqs) + eqs*coeff;
      lines.line(mx, hh, mx, map(wai, -m, m, h-5, 5));
    }
    lines.line(w/2f, 4, w/2f, h-4);
    lines.endDraw();
  }
  float exp_term(float a){
    if( exp == 0 ) return 0;
    else{
      if(exp % 2 == 0 && a < 0) return -pow(a, exp);
      else return pow(a, exp);
    }
  }
  void exe(ColorScheme CS){
    fill(CS.dim);
    super.Rect();
    image(lines, x, y);
    
    if ( super.mouse_over() ) {
      fill(CS.bright);
      if (mousePressed) held = true;
    }
    if(!mousePressed) held = false;
    
    if(held){
      fill(CS.brighter);
      X = map(mouseX, x+4, x+w-4, -domain, domain);
      incumbency.n = constrain(incumbency.n + exp_term(X) + X*coeff, min, max);
    }
    else{
      if(abs(X)<0.05) X = 0;
      else X /= 2;
    }
    
    rect(map(constrain(X, -domain, domain), -domain, domain, x+4, x+w-4)-4, y-1, 8, h+2);
  }
}

