#include "pontos.h"

Pontos::Pontos()
{
    // this->set(ofRandomWidth(), ofRandomHeight());
    this->set(ofGetWidth()/2.0, ofGetHeight()/2.0);
    vel.set(ofRandom(0.3, 4.0), 0);
    vel.rotate(ofRandom(0, 360));
    acc.set(0, 0);
}

Pontos::Pontos( ofVec2f pos_, ofVec2f vel_, ofVec2f acc_ )
{
    this->set(pos_);
    vel.set(vel_);
    acc.set(acc_);
}

void
Pontos::update()
{
    vel += acc;
    *this += vel;

    if(this->x < 0){
        this->x = 0;
        vel.x = -vel.x;
    }
    else if(this->x > ofGetWidth()){
        this->x = ofGetWidth();
        vel.x = -vel.x;   
    }

    if(this->y < 0){
        this->y = 0;
        vel.y = -vel.y;
    }
    else if(this->y > ofGetHeight()){
        this->y = ofGetHeight();
        vel.y = -vel.y;   
    }

}

void 
Pontos::display()
{
    // ofFill();
    // ofSetColor(38, 38, 36);
    // ofCircle(*this, 5);
    // ofNoFill();
}

void
Pontos::addForce( ofVec2f &center, float radius, float strength){
    ofVec2f diff = *this - center;

    if (diff.length() < radius){
        float pct = 1 - (diff.length() / radius);
        diff.normalize();
        acc.x += diff.x * pct * strength;
        acc.y += diff.y * pct * strength;
    }else{
        acc.set(0, 0);
    }
}