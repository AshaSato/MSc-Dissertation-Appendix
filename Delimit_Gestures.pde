import processing.video.*;
import g4p_controls.*;

//sketch for coding data from BSL experiment 
//expects: skeleton file, experiment file and video file.  

//outputs: datafile combining experiment info with skeleton info. 


//for datafile with everything: 
//header 
//pID TRIALNO BLOCK ITEM ICONIC VERIDICAL DUMMYIC SIGN ENG RESPONSE IC_RATING STRATEGY Miliseconds  Frame  Amplitude  j0X  j0Y  j0Z  j1X  j1Y  j1Z  j2X  j2Y  j2Z  j3X  j3Y  j3Z  j4X  j4Y  j4Z  j5X  j5Y  j5Z  j6X  j6Y  j6Z  j7X  j7Y  j7Z  j8X  j8Y  j8Z  j9X  j9Y  j9Z  j10X  j10Y  j10Z  j11X  j11Y  j11Z  j12X  j12Y  j12Z  j13X  j13Y  j13Z  j14X  j14Y  j14Z  j15X  j15Y  j15Z  j16X  j16Y  j16Z  j17X  j17Y  j17Z  j18X  j18Y  j18Z  j19X  j19Y  j19Z  j20X  j20Y  j20Z  j21X  j21Y  j21Z  j22X  j22Y  j22Z  j23X  j23Y  j23Z  j24X  j24Y  j24Z  j25X  j25Y  j25Z  


//start screen
GTextField pid;
GButton selectskeletonData, selectExpData, selectVideo;
String skelPath, expPath, vidPath;
boolean skelSelect, expSelect, vidSelect, filesSelected;
boolean codingStarted = false;
GButton startCoding;


// necessary bits
String pID;

Movie mov;
Table skeletonData;
Table stimTable;

int skeletonRow; //current Row in skeleton data file
int stimRow; //current Row in experiment data file 
int counter = 0;


//variables for storing beginning and end Frame and Millisecond of Gesture
//and button to set them
int bRow;
int bFrame;
int eFrame;

int eRow;
float bMilis;
float eMilis;

GButton correct;
GButton incorrect;

GButton Gstart;
GButton Gend;

GButton writeGesture;
GButton nextTrial, prevTrial;

GButton hesitation,mirrored;

String breakPoints = "";


Float progress;
int alpha;
int jointSize = 10;
color jointCol =#FF9900 ;
color boneCol = #449D92 ;

// variables for reading and writing from experiment datafile
String BLOCK;
String ITEM;
String VIDSHOWN;
String ENG;
String RESPONSE;
String STRATEGY;


int ICONIC;
int VERIDICAL;
int DUMMYIC;
int TRIAL;
int RATING;
int CORRECT;
int HESITATION;
int MIRRORED;



//and from skeleonFile 
String TIMESTAMP;
int MILISECONDS = 0;
float FRAMERATE = 0.0;
int FRAME = 0;







//filename stuff
PrintWriter output;
String jointNames;

GButton DONE;

void setup() {
  size(1200, 600);
  surface.setResizable(true);
  background(255);
  G4P.setGlobalColorScheme(G4P.YELLOW_SCHEME);
  
  //joint names
  
  jointNames = "HDX" +"\t"+ "HDY"+"\t"+ "HDZ" +"\t"+
                "NKX" +"\t"+"NKY"+"\t"+ "NKZ" +"\t"+
                 "CBX"+"\t"+ "CBY"+"\t"+ "CBZ" +"\t"+
                 "TX"+"\t"+ "TY"+"\t"+ "TZ"+"\t"+
                 "RHPX"+"\t"+ "RHPY"+"\t"+ "RHPZ"+"\t"+
                 "LHPX" +"\t"+"LHPY" +"\t"+"LHPZ"+"\t"+
                 "RSX" +"\t"+"RSY"+"\t"+ "RSZ" +"\t"+
                 "LSX"+"\t"+ "LSY"+"\t"+ "LSZ"+"\t"+
                 "REX"+"\t"+ "REY"+"\t"+ "REZ"+"\t"+
                 "LEX"+"\t"+ "LEY"+"\t"+ "LEZ"+"\t"+
                 "RWX" +"\t"+"RWY"+"\t"+ "RWZ"+"\t"+
                 "LWX"+"\t"+ "LWY"+"\t"+ "LWZ"+"\t"+
                 "RHX"+"\t"+ "RHY" +"\t"+"RHZ"+"\t"+
                 "LHX"+"\t"+ "LHY"+"\t"+ "LHZ" +"\t"+              
                 "RHHX"+"\t"+ "RHHY"+"\t"+ "RHHZ"+"\t"+
                 "LHHX"+"\t"+ "LHHY"+"\t"+ "LHHZ"+"\t"+
                 "RHHHX"+"\t"+ "RHHHY"+"\t"+ "RHHHZ"+"\t"+
                "LHHHX"+"\t"+ "LHHHY "+"\t"+"LHHHZ";
  
  //get joint names
  //for (int j = 0; j<26; j++) {
  //  jointNames +="j"+j+"X\t"+"j"+j+"Y\t"+"j"+j+"Z\t";
  //}

  selectskeletonData = new GButton(this, 100, 100, 100, 100, "Select Skelton File");
  selectExpData = new GButton(this, 100, 250, 100, 100, "Select Experiment File");
  selectVideo = new GButton(this, 100, 400, 100, 100, "Select Video File");

  startCoding = new GButton (this, width*.8, height*.5, 100, 100, "Begin");
  startCoding.setVisible(false);

  Gstart = new GButton(this, 400, 20, 100, 100, "Gesture begins");
  Gend = new GButton(this, 400, 130, 100, 100, "Gesture ends");
  Gstart.setVisible(false);
  Gend.setVisible(false);
  
  correct = new GButton(this, 600,200,50,50, "YES");
  correct.setLocalColorScheme(G4P.GREEN_SCHEME);
  correct.setVisible(false);
  
  incorrect = new GButton(this, 650,200,50,50, "NO");
  incorrect.setLocalColorScheme(G4P.RED_SCHEME);
  incorrect.setVisible(false);
  
  hesitation = new GButton(this, 600,150,50,50, "HES");
  hesitation.setLocalColorScheme(G4P.BLUE_SCHEME);
  hesitation.setVisible(false);
  
  mirrored = new GButton(this, 650,150,50,50, "MIRR");
  mirrored.setLocalColorScheme(G4P.PURPLE_SCHEME);
  mirrored.setVisible(false);
  
  writeGesture = new GButton(this, 600,300,100,100, "Write Gesture");
  writeGesture.setLocalColorScheme(G4P.ORANGE_SCHEME);
  writeGesture.setVisible(false);
  
  nextTrial = new GButton(this,600,450,50,50, "+");
  nextTrial.setVisible(false);
  
  prevTrial = new GButton(this, 650,450,50,50, "-");
  prevTrial.setVisible(false);
  
  DONE = new GButton(this, width-120,height-120, 100,100, "Exit");
  
  pid = new GTextField(this, width*.8, height*.4,100,30);
  pid.setPromptText("Participant ID");
} //end setup


void draw() {
  background(255);
  alpha -=10;
  if (codingStarted == true) {

   // <-------------------------------------------------------------------------------------------------------------------------------------//LEFT PANEL//

    //draw skeleton
    skellyDraw(200, 150);
    //draw movie
    
    
    //loop between start and end points. 
    if(mov.time() > eMilis) {
    mov.jump(bMilis);
    }
    
    
    image(mov, 0, 380, 512, 424);
    line(512, 0, 512, height);

    //display info about trial 
    fill(boneCol);
    text("TRIAL: " + TRIAL, 10, 20);
    text("BLOCK: "+ BLOCK, 10, 40);
    text("ITEM: "+ITEM, 10, 60); 
    text("ICONIC: "+ICONIC, 10, 80);
    text("VERIDICAL: "+VERIDICAL, 10, 100);
    text("DUMMYIC: "+DUMMYIC, 10, 120);
    text("VIDSHOWN: "+VIDSHOWN, 10, 140);
    text("ENG: "+ENG, 10, 160);
    text("RESPONSE: "+RESPONSE, 10, 180);
    text("RATING: "+RATING, 10, 200);
    text("STRATEGY: "+STRATEGY, 10, 220);
    text("CORRECT: "+CORRECT, 760, 140);
    text("HESITATION: "+HESITATION,760,160);
    text("MIRRORED: "+MIRRORED,760,180);

    //display info about skeleton Data
    text("TIMESTAMP: "+skeletonData.getInt(skeletonRow, 0), 200,10);
    text("MILISECONDS: " + skeletonData.getInt(skeletonRow, 1), 200, 20);
    text("CURRENT FRAME: " +skeletonData.getInt(skeletonRow, 3), 200, 40);
    text("CURRENT ROW: " + skeletonRow, 200,60);
    
    text("bMILIS: " + bMilis, 800,100);
    text("eMILIS: " + eMilis, 800,120);
   //draw progress bar at bottom 
    
    fill(jointCol);
    noStroke();
    rect(0,height-10,512,height-10);
    
    progress = map(skeletonRow,0,skeletonData.getRowCount(), 0,512);
    fill(boneCol);
    rect(0,height-10, progress, height-10);
    
    



     // <----------------------------------------------------------------------------------------------------------------------------------------//MIDDLE PANEL

    fill(jointCol);
    textSize(50);
    text(ITEM, 550, 50);
    textSize(30);
    text("row "+bRow + " : "+eRow,550,80);
    //text(bFrame + " : "+eFrame, 550, 80);
    //text(bMilis + " : "+eMilis, 550, 110);
    textSize(12);




    //control playback of video and skeleton using left and right arrow key. 

    if (keyPressed == true) {
      if (key == CODED) {
        if (keyCode == RIGHT) {         //fast
          //unless reached end of file
          if (skeletonRow < skeletonData.getRowCount()-1) {
            skeletonRow +=6;
            fill(jointCol, alpha);
            stroke(boneCol, alpha);
            triangle(320, 50, 320, 80, 340, 65);
          }
        }//end keyRIGHT
        else if (keyCode == LEFT) {     //fast
          //unless reached beginning of file
          if (skeletonRow > 0) {
            skeletonRow -=6;
            fill(jointCol, alpha);
            stroke(boneCol, alpha);
            triangle(340, 50,340, 80, 320, 65);
          }
        } //end keyLEFT                  //slow
        else if (keyCode == UP) {
          //unless reached end of file
          if (skeletonRow < skeletonData.getRowCount()-1) {
            skeletonRow +=1;
            fill(jointCol, alpha);
            stroke(boneCol, alpha);
            triangle(320, 50, 320, 80, 340, 65);
          }
        }//end keyUP
        else if (keyCode == DOWN) {          //slow
          //unless reached beginning of file
          if (skeletonRow > 0) {
            skeletonRow -=1;
            fill(jointCol, alpha);
            stroke(boneCol, alpha);
            triangle(340, 50,340, 80, 320, 65);
          }
        }//end keyDOWN
      } //end keyCODED
      else if (key == ',') { //slide the video window backwards/forwards to see the gesture (because it goes out of sync as the experiment progresses)
        eMilis -=.1;
        bMilis -=.1;
      } else if (key == '.') {
        eMilis +=.1;
        bMilis +=.1;
      }
  }//end keyPressed
  }//end if codingStarted 


  //start screen: 
  //selected file paths appear on the screen
  //until startCoding button is pressed. 
  else if (skelSelect == true && codingStarted == false) { 
    fill(0);
    text(skelPath, 200, 150);
  }
  if (expSelect == true && codingStarted == false) {
    fill(0);
    text(expPath, 200, 300);
  }
  if (vidSelect == true && codingStarted == false) {
    fill(0);
    text(vidPath, 200, 450);
  }
}//end draw


public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) {
  if (textcontrol== pid) {
    pID = textcontrol.getText();
  }
}

public void handleButtonEvents(GButton button, GEvent event) {
  //File selection
  if (button == selectskeletonData | button == selectExpData | button == selectVideo) {
    getFile(button);
  } else if (button == startCoding) {
    codingStarted = true;
    selectskeletonData.setVisible(false);
    selectExpData.setVisible(false);
    selectVideo.setVisible(false);
    startCoding.setVisible(false);
    pid.setVisible(false);
    
    output = createWriter("/extra/"+pID+".txt");
    output.println("pID" +"\t" +"TIMESTAMP"+ "\t" + "MILISECONDS" + "\t"+ "FRAME" + "\t" + "TRIAL" + "\t" + "BLOCK" + "\t" +"ITEM" 
    + "\t" +"ICONIC" + "\t" +"VERIDICAL" + "\t" +"DUMMYIC" + "\t" +"VIDSHOWN" 
    + "\t" +"ENG" + "\t" +"RESPONSE" + "\t" +"RATING" + "\t" +"STRATEGY"+ "\t" + "CORRECT" + "\t" +"HESITATION"+ "\t" + "MIRRORED" + "\t"
    + jointNames);
    loadTrial();
    
    correct.setVisible(true);
    incorrect.setVisible(true);
    hesitation.setVisible(true);
    mirrored.setVisible(true);
    Gstart.setVisible(true);
    Gend.setVisible(true);
    writeGesture.setVisible(true);
    nextTrial.setVisible(true);
    prevTrial.setVisible(true);
    DONE.setVisible(true);
  } else if (button == Gstart| button == Gend) {
    delimitGesture(button);
  } else if (button == writeGesture){
    writeGesture();
    stimRow+=1;
    loadTrial();
    bRow = 0;
    eRow = 0;
    Gstart.setLocalColorScheme(G4P.YELLOW_SCHEME);
    Gend.setLocalColorScheme(G4P.YELLOW_SCHEME);
    mov.pause();
  } else if (button == nextTrial) {
    stimRow+=1;
    bRow = 0;
    eRow = 0;
    loadTrial();
 } else if (button == prevTrial) {
   stimRow -=1;
   bRow = 0;
   eRow = 0;
   loadTrial();
 } else if (button == correct) {
   CORRECT = 1;
  // incorrect.setVisible(false);
 } else if (button == incorrect) {
   CORRECT = 0;
  // correct.setVisible(false);
 } else if (button == hesitation){
   if (HESITATION == 0) {
     HESITATION = 1;
   } else if (HESITATION == 1) {
     HESITATION = 0;
   }
  // hesitation.setVisible(false);
 } else if (button == mirrored){
   if (MIRRORED == 0) {
   MIRRORED = 1;
 } else if (MIRRORED == 1) {
 MIRRORED = 0;
 }
  // mirrored.setVisible(false);
 }else if (button == DONE) {
  output.flush();
  output.close();
  exit();
  }
}  

String jData = "";
//this needs fixing to read the data for the jointnames. 
public void writeGesture() {
    correct.setVisible(true);
  incorrect.setVisible(true);
  hesitation.setVisible(true);
  mirrored.setVisible(true);
  for(int i = bRow; i < eRow; i++) {
    //for each for in the gesture 
    jData += skeletonData.getInt(i, "HDX"); jData += "\t";  jData += skeletonData.getInt(i, "HDY"); jData += "\t"; jData += skeletonData.getInt(i, "HDZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "NKX"); jData += "\t"; jData += skeletonData.getInt(i, "NKY"); jData += "\t";  jData += skeletonData.getInt(i, "NKZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "CBX");
    jData += "\t";
    jData += skeletonData.getInt(i, "CBY");
    jData += "\t";
    jData += skeletonData.getInt(i, "CBZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "TX");
    jData += "\t";
    jData += skeletonData.getInt(i, "TY");
    jData += "\t";
    jData += skeletonData.getInt(i, "TZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHPX");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHPY");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHPZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHPX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHPY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHPZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "RSX");
    jData += "\t";
    jData += skeletonData.getInt(i, "RSY");
    jData += "\t";
    jData += skeletonData.getInt(i, "RSZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LSX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LSY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LSZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "REX");
    jData += "\t";
    jData += skeletonData.getInt(i, "REY");
    jData += "\t";
    jData += skeletonData.getInt(i, "REZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LEX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LEY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LEZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "RWX");
    jData += "\t";
    jData += skeletonData.getInt(i, "RWY");
    jData += "\t";
    jData += skeletonData.getInt(i, "RWZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LWX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LWY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LWZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHX");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHY");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHHX");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHHY");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHHZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHHX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHHY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHHZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHHHX");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHHHY");
    jData += "\t";
    jData += skeletonData.getInt(i, "RHHHZ");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHHHX");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHHHY");
    jData += "\t";
    jData += skeletonData.getInt(i, "LHHHZ");
    jData += "\t";
    //earlier code: for reading ALL joints
    //for (int j = 0; j<26; j++) {
    //jData+= skeletonData.getInt(i, "j"+j+"X");
    //jData+= "\t";
    //jData+= skeletonData.getInt(i, "j"+j+"Y");
    //jData+= "\t";
    //jData+= skeletonData.getInt(i, "j"+j+"Z");
    //jData += "\t";
    
    TIMESTAMP = skeletonData.getString(i,0);
    MILISECONDS = skeletonData.getInt(i,1);
    FRAMERATE = skeletonData.getFloat(i,2);
    FRAME = skeletonData.getInt(i,3);

        output.println(pID + "\t" + TIMESTAMP + "\t" +MILISECONDS + "\t" + FRAME + "\t"+TRIAL + "\t" + BLOCK + "\t" +ITEM 
    + "\t" +ICONIC + "\t" +VERIDICAL + "\t" +DUMMYIC + "\t" +VIDSHOWN 
    + "\t" +ENG + "\t" +RESPONSE + "\t" +RATING + "\t" +STRATEGY+ "\t" + CORRECT + "\t" + HESITATION + "\t"+ MIRRORED + "\t"
    + jData)
    ;
    jData = "";
  }
  }






public void delimitGesture(GButton button) {
  if (button == Gstart) {
    bRow = skeletonRow;
    Gstart.setLocalColorScheme(G4P.ORANGE_SCHEME);
    bFrame = skeletonData.getInt(skeletonRow, 3);
    bMilis = skeletonData.getInt(bRow, 1);
  } else if (button == Gend) {
    eRow = skeletonRow;
    Gend.setLocalColorScheme(G4P.ORANGE_SCHEME);
    eFrame = skeletonData.getInt(skeletonRow, 3);
    eMilis = skeletonData.getInt(skeletonRow, 1);
    mov.play();
    mov.jump(bMilis);
  }
}





public void getFile(GButton button) {
  //opens file dialogs, puts path into string and initializes the relevant data structure
  //if all three files have been selected, BEGIN button becomes available.
  if (button == selectskeletonData) {
    skelSelect = true;
    String skel = G4P.selectInput("choose Skeleton File");

    //initialize skeleton data 
    skelPath = skel.replace('\\', '/');
    skeletonData = loadTable(skelPath, "header,tsv");
    skeletonRow = 0;

    if (expSelect == true && vidSelect == true) {
      startCoding.setVisible(true);
    }
  } else if (button == selectExpData) {
    expSelect = true;
    String exp = G4P.selectInput("choose Experiment File");

    //initialize experiment data
    expPath = exp.replace('\\', '/');
    stimTable = loadTable(expPath, "header, tsv");
    stimRow = 0;
    loadTrial();

    if (skelSelect == true && vidSelect == true) {
      startCoding.setVisible(true);
    }
  } else if (button == selectVideo) {
    vidSelect = true;
    String vid = G4P.selectInput("choose Video File");

    //initialize video data
    vidPath = vid.replace('\\', '/');
    mov = new Movie(this, vidPath);
    bMilis = 0;
    eMilis = mov.duration();
    mov.pause();
    if (skelSelect == true & expSelect == true) {
      startCoding.setVisible(true);
    }
  }
}//end getFile()



void skellyDraw(int x, int y) { //x,y = collarbone coords.
  pushMatrix();
  translate(x,y);
  //get joint coords
  
  //collarbone
  int CBX = skeletonData.getInt(skeletonRow, "CBX");
  int CBY = skeletonData.getInt(skeletonRow, "CBY");
  //head
  int HDX = skeletonData.getInt(skeletonRow, "HDX");
  int HDY = skeletonData.getInt(skeletonRow, "HDY");
  //neck
  int NKX = skeletonData.getInt(skeletonRow, "NKX");
  int NKY = skeletonData.getInt(skeletonRow, "NKX");
  //torso
  int TX = skeletonData.getInt(skeletonRow, "TX");
  int TY = skeletonData.getInt(skeletonRow, "TY");
  //hips
  int RHPX = skeletonData.getInt(skeletonRow, "RHPX");
  int RHPY = skeletonData.getInt(skeletonRow, "RHPY");
  int LHPX = skeletonData.getInt(skeletonRow, "LHPX");
  int LHPY = skeletonData.getInt(skeletonRow, "LHPY");
  
  //shoulders
  int RSX = skeletonData.getInt(skeletonRow, "RSX");
  int RSY = skeletonData.getInt(skeletonRow, "RSY");
  int LSX = skeletonData.getInt(skeletonRow, "LSX");
  int LSY = skeletonData.getInt(skeletonRow, "LSY");
  //elbows
  int REX = skeletonData.getInt(skeletonRow, "REX");
  int REY = skeletonData.getInt(skeletonRow, "REY");
  int LEX = skeletonData.getInt(skeletonRow, "LEX");
  int LEY = skeletonData.getInt(skeletonRow, "LEY");
  //wrists
  int RWX = skeletonData.getInt(skeletonRow, "RWX");
  int RWY = skeletonData.getInt(skeletonRow, "RWY");
  int LWX = skeletonData.getInt(skeletonRow, "LWX");
  int LWY = skeletonData.getInt(skeletonRow, "LWY");
  
  //hands
  int RHX = skeletonData.getInt(skeletonRow, "RHX");
  int RHY = skeletonData.getInt(skeletonRow, "RHY");
  int LHX = skeletonData.getInt(skeletonRow, "LHX");
  int LHY = skeletonData.getInt(skeletonRow, "LHY");
  
  int RHHX = skeletonData.getInt(skeletonRow, "RHHX");
  int RHHY = skeletonData.getInt(skeletonRow, "RHHY");
  int LHHX = skeletonData.getInt(skeletonRow, "LHHX");
  int LHHY = skeletonData.getInt(skeletonRow, "LHHY");
  
  int RHHHX = skeletonData.getInt(skeletonRow, "RHHHX");
  int RHHHY = skeletonData.getInt(skeletonRow, "RHHHY");
  int LHHHX = skeletonData.getInt(skeletonRow, "LHHHX");
  int LHHHY = skeletonData.getInt(skeletonRow, "LHHHY");
  
  
  
  //draw bones
  strokeWeight(2);
  stroke(#8AD897);
  line(CBX,CBY,RSX,RSY); // r shouder
  line(CBX,CBY,LSX,LSY); // l shoulder
  
  line(RSX,RSY,REX,REY); // r arm
  line(LSX,LSY,LEX,LEY); // l arm
  
  line(REX,REY, RWX,RWY); // r forearm
  line(LEX, LEY, LWX,LWY); // l forearm
  strokeWeight(1);
  stroke(#0A9376);
  
  line(HDX,HDY,NKX,NKY); // neck
  line(CBX, CBY, TX,TY); // torso
  line(TX,TY,RHPX,RHPY); // right hip
  line(TX,TY, LHPX,LHPY); // left hip
  line(LHPX,LHPY,RHPX,RHPY); // hips
 
  line(RWX,RWY, RHX,RHY); // r hand
  line(LWX,LWY, LHX, LHY); // l hand  
  
  line(RHX,RHY, RHHX, RHHY); // r hand
  line(LHX,LHY, LHHX, LHHY); // l hand
  
  line(RHX,RHY,RHHHX,RHHHY); // r hand
  line(LHX, LHY, LHHHX,LHHHY);  // l hand
  
  //draw joints
  noStroke();
  fill(#DCEADF);
  ellipse(HDX,HDY, 35,50); //head
  
  fill(#0A675F);
  ellipse(CBX,CBY, jointSize,jointSize); // collarbone
  ellipse(RSX, RSY, jointSize, jointSize); // r shoulder
  ellipse(LSX,LSY, jointSize,jointSize); // l shoulder
  ellipse(REX,REY, jointSize,jointSize); // r elbow
  ellipse(LEX,LEY, jointSize,jointSize); // l elbow
  ellipse(RWX,RWY, jointSize, jointSize); // r wrist
  ellipse(LWX,LWY, jointSize, jointSize); // l wrist
  
  //transparent stuff
  fill(#0A9376,50);
  ellipse(LHX,LHY, 20,20); //l hand
  ellipse(RHX,RHY, 20, 20); // r hand
  ellipse(NKX,NKY, jointSize,jointSize); // neck
 
  
  popMatrix();

}








public void loadTrial() {
  TRIAL = stimTable.getInt(stimRow, 1);
  BLOCK = stimTable.getString(stimRow, 2);
  ITEM = stimTable.getString(stimRow, 3);
  ICONIC = stimTable.getInt(stimRow, 4);
  VERIDICAL = stimTable.getInt(stimRow, 5);
  DUMMYIC = stimTable.getInt(stimRow, 6);
  VIDSHOWN = stimTable.getString(stimRow, 7);
  ENG = stimTable.getString(stimRow, 8);
  RESPONSE = stimTable.getString(stimRow, 9);
  RATING = stimTable.getInt(stimRow,10);
  STRATEGY = stimTable.getString(stimRow,11);
  HESITATION = 0;
  MIRRORED = 0;
}

void keyPressed() {
  alpha = 255;
}

void movieEvent(Movie m) {
 m.read();
}
