#ifndef pontos_h
#define pontos_h

#include "ofMain.h"

class Pontos: public ofVec2f {

public:

	Pontos();
	Pontos(ofVec2f pos_, ofVec2f vel_, ofVec2f acc_);

	void update();
	void display();
    void addForce( ofVec2f &center, float radius, float strength);

	ofVec2f pos, vel, acc;
};

#endif