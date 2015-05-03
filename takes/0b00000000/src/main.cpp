#include "ofMain.h"
#include "ofApp.h"

//========================================================================
int main( ){
    // ofSetupOpenGL(1280*0.75,720*0.75,OF_FULLSCREEN); // <-------- setup the GL context | OF_WINDOW
    ofSetupOpenGL(1366,768,OF_FULLSCREEN); // <-------- setup the GL context | OF_WINDOW

	// ofSetupOpenGL(2*1195, 2*845, OF_WINDOW); // <-------- setup the GL context | OF_WINDOW

	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp(new ofApp());

}

