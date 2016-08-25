import g4p_controls.*;
import processing.svg.*;
import processing.sound.*;
import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;


Amplitude amp;
AudioIn in;

KinectPV2 kinect;
color coordCol;

int timeElapsed;
int timeBegan;

boolean recordingStarted = false;
GTextField pID;
GButton startRecording, stopRecording;
String fn;

PrintWriter output;

void setup() {
  size(512, 500, P3D);
  kinect = new KinectPV2(this);
  coordCol = color(#FF03B4);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableDepthImg(true);

  kinect.init();
  
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
  timeBegan = millis();
 
 
  startRecording = new GButton(this, width*.25-50,50,100,100, "START RECORDING");
  startRecording.setVisible(false);
  startRecording.setVisible(false);
  stopRecording = new GButton(this, width*.75-50,50,100,100, "STOP RECORDING");
  stopRecording.setVisible(false);
  stopRecording.setVisible(false);
  
  pID = new GTextField(this, width*.5-50,50, 100,100);
  pID.setPromptText("PARTICIPANT ID");
  

}

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) {
  if (textcontrol == pID) {
  fn = textcontrol.getText();
  if (fn.length() > 2) {
  startRecording.setVisible(true);
  startRecording.setVisible(true);
  }
  }
}



public void handleButtonEvents(GButton button, GEvent event) {
  if(button == startRecording) {
      String jointNames = "";
  for(int j = 0; j<26;j++){
  jointNames +="j"+j+"X\t"+"j"+j+"Y\t"+"j"+j+"Z\t";
  }
    output = createWriter(fn+".txt");
    output.println("TimeStamp\tMiliseconds\tFrameRate\tFrame\tAmplitude\t"+jointNames);
    recordingStarted = true;
    button.setVisible(false);
    button.setVisible(false);
    pID.setVisible(false);
    pID.setVisible(false);
    stopRecording.setVisible(true);
    stopRecording.setVisible(true);
  }
  
  else if(button == stopRecording) {
    output.flush();
    output.close();
    exit();
  }
}





void draw() {
  background(255);
  //textSize(14);
  //text("Skeleton coords test",50,30);
     //headers for data section
  //textSize(20);
  //fill(0);
  //text("Collarbone",200,100);
  //text("R.Shoulder",50,170); 
  //text("L.Shoulder",350,170);
  //text("R.Elbow",50,240);
  //text("L.Elbow",350,240);
  //text("R.Wrist",50,310);
  //text("L.Wrist",350,310);
  //text("R.Hand",50,380);
  //text("L.Hand",350,380);
  
  //image(kinect.getDepthMaskImage(), 0, 500);
  //get the skeletons as an Arraylist of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    
    //if the skeleton is being tracked, compute the skleton joints
    if (skeleton.isTracked()) {
      textSize(14);
      text("Skeleton Tracked: TRUE",50,50);
      KJoint[] joints = skeleton.getJoints();
      int [] rawDepth = kinect.getRawDepthData();
      
      //get and display all joints
      String alljoints = "";
      
      for (int j = 0; j < joints.length; j++) {
      int jX = int(joints[j].getX());
      int jY = int(joints[j].getY());
      int jindex = jX+jY*width;
      int jZ = 0;
      if(jindex >0 & jindex <rawDepth.length) {
        jZ = rawDepth[jindex];
      } alljoints += jX+"\t"+jY+"\t"+jZ+"\t";
      }   
      
      //color col  = skeleton.getIndexColor();
      //fill(col);
      //stroke(col);
     // translate(0,500);
      //drawBody(joints);
      
      if(recordingStarted){
       output.println(hour()+":"+minute()+":"+second() + "\t"+millis() + "\t"+frameRate +"\t"+frameCount+"\t"+amp.analyze()+"\t"+
     alljoints);
   }
      

    }
  }
//
  fill(255, 0, 0);
}

//draw the body
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //Single joints
  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  fill(0);
  ellipse(0, 0, 10, 10);
  popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  fill(0);
  stroke(0);
  ellipse(0, 0, 10, 10);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());

}

//draw a ellipse depending on the hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */

//Depending on the hand state change the color
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    break;
  }
}