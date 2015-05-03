#include "ofApp.h"

#define PONTOS_LENGTH 750
// #define PONTOS_LENGTH 1500

//--------------------------------------------------------------
void ofApp::setup(){
    // ofSetBackgroundAuto(false);
    // ofBackground(77,106,90);

    pontos = new Pontos[PONTOS_LENGTH];
    start = false;

    frameFoto = 0;
}

//--------------------------------------------------------------
void ofApp::update(){
    // ofSetWindowShape(2*1195, 2*845);
    // ofSetWindowShape(1195, 845);

    if(!start) return;
    
    ofVec2f mouse(mouseX, mouseY);
    for (register  int i = 0; i < PONTOS_LENGTH; ++i){
        // pontos[i].addAttractionForce(mouse, 300, 0.005);
        pontos[i].update();
    }

}

//--------------------------------------------------------------
void ofApp::draw(){

    // ofSetColor(77,106,90);
    ofSetColor(207,156,0);
    
    // ofBackground(242,193,46);
    // ofSetColor(217,43,43);
    
    // ofBackground(0,88,95);
    // ofSetColor(240,237,187);

    // ofBackground(236,240,240);
    // ofSetColor(231,76,60);
    
    ofBackgroundGradient(ofColor(90), ofColor(10));

    if(!start) return;

    for (register int i = 0; i < PONTOS_LENGTH - 1; ++i){
        for (register int j = i + 1; j < PONTOS_LENGTH; ++j){
                // if(pontos[i].distance(pontos[j]) && pontos[i].distance(pontos[j]) < 100){
                if(pontos[i].distance(pontos[j]) && pontos[i].distance(pontos[j]) < 70){
                    ofLine(pontos[i], pontos[j]);
                }
            }
    }

    // char buff[8];
    // sprintf (buff, "%04d", frameFoto++);
    // string frameName(buff);
    // frameName += ".png";
    // printf("%s\n", frameName.c_str());
    // ofSaveScreen(frameName);

}

//--------------------------------------------------------------
void ofApp::exit(){
    delete[] pontos;
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if(key == 's') start = true;
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
