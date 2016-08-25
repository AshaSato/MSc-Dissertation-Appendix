import g4p_controls.*;



//data collection for experiment 1
//elicits production of 32 signs in 5 blocks. 

//Experimenter Presses Button when informant Ready to Move on.




///////////////////////////
//                       //
//      - GLOBALS -      //
//                       //
///////////////////////////

  // -FILE - //
  
String fn = "Logfile_XX.txt";
PrintWriter output;

  //-- EXPERIMENT STRUCTURE STUFF --//
  
Table stimTable;
int level = 0; //should  be zero expect for testing and debugging


int trialNo; //number of trials completed 
int currentTrial; //index of item in stimuli table


String Prompt;


  //-- GUI STUFF --//
GWindow controls;

GButton btnLaunch;
GButton btnNext;
GButton btnRound2, btnRound3, btnRound4;







///////////////////////////
//                       //
//     - FUNCTIONS -     //
//          ETC          //
//                       //
///////////////////////////

//Button Handler
public void handleButtonEvents(GButton button, GEvent event) {
  if (button == btnLaunch) {
    //Launch Experiment
    level = 1;
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
    button.setVisible(false);
    button.setEnabled(false);
    btnNext.setVisible(true);
    btnNext.setEnabled(true);
  } else if (button == btnNext) {
    if(trialNo > 30) {
    level+=1;
    button.setVisible(false);
    button.setEnabled(false);
    
    if (level == 2){
    btnRound2.setVisible(true);
    btnRound2.setEnabled(true);
    } else if (level == 4)  {
    btnRound3.setVisible(true);
    btnRound3.setEnabled(true);
    } else if (level == 6) {
    btnRound4.setVisible(true);
    btnRound4.setEnabled(true);
    }
    }
    trialNo+=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  } else if (button == btnRound2 | button == btnRound3 | button == btnRound4) {
    level+=1;
    trialNo = 0;
    stimTable = loadTable("DeafStimuli.txt", "header,tsv");
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
    button.setVisible(false);
    button.setEnabled(false);
    btnNext.setVisible(true);
    btnNext.setEnabled(true);
  }
}



void loadTrial() {
  Prompt = stimTable.getString(currentTrial,0);

}



///////////////////////////
//                       //
//      -  SETUP  -      //
//                       //
///////////////////////////

void setup() {
  
  //-- GENERAL + FORMATTING --//
  //size(800,800);
  fullScreen(2);
  textAlign(CENTER);
  textSize(70);
    
  output = createWriter(fn);
  output.println("THIS IS THE HEADER LINE");
  
  //--EXPERIMENT STRUCTURE STUFF--//
  stimTable = loadTable("DeafStimuli.txt", "header,tsv");
  
  //--GUI STUFF--//
  G4P.setGlobalColorScheme(GCScheme.YELLOW_SCHEME);
  controls = GWindow.getWindow(this, "Controls", 50,10,500,800,JAVA2D);
  controls.addDrawHandler(this, "drawControls");

  btnLaunch = new GButton(controls, controls.width*.5-60,100,120,60, "Launch Experiment");
  
  btnNext = new GButton(controls, controls.width*.5-60,300,120,60, "Next Trial");
  btnNext.setVisible(false);
  btnNext.setEnabled(false);
  
  btnRound2 = new GButton(controls, controls.width*.5-60,200,120,60,"Round2");
  btnRound2.setVisible(false);
  btnRound2.setEnabled(false);
  
  btnRound3 = new GButton(controls, controls.width*.5-60,200,120,60,"Round3");
  btnRound3.setVisible(false);
  btnRound3.setEnabled(false);
  
  btnRound4 = new GButton(controls, controls.width*.5-60,200,120,60,"Round4");
  btnRound4.setVisible(false);
  btnRound4.setEnabled(false);
  
}









///////////////////////////
//                       //
//     -  CONTROLS  -    //
//                       //
///////////////////////////

public void drawControls(PApplet c, GWinData data) {
  c.background(255);
  //the rest is all done through the button handler
}






///////////////////////////
//                       //
//    -  MAIN DRAW  -   //
//                       //
///////////////////////////
void draw() {
  background(255);
  fill(0);
  
  
  switch(level) {
    case 0: {
     //--instruction screen--//
      //text(level,100,100);
      textSize(30);
      text("+", width*.5, height*.5);
      textSize(60);
      
      break;
    } //end case 0 (instructions)
    
    case 1: {
      //-- LEVEL 1--// //-ROUND 1-//
      //text(level,100,100);
      //text("Please produce the sign for ... ",width*.5,height*.3);
      text(Prompt, width*.5, height*.4);
      //text(trialNo, width*.5, height*.5);
      break;
    } //end of case 1 (block 1)
    
    
    case 2: {
      //--LEVEL 2--//
      trialNo = 0;
      //text(level,100,100);
      textSize(30);
      text("Block 2",width*.5,height*.3);
      textSize(60);
      break;
    } //end of case 2 (instruction)
    
    case 3: {
      //--LEVEL 3--// //-ROUND 2-//
      //text(level,100,100);
      //text("Please produce the sign for ... ",width*.5,height*.3);
      text(Prompt, width*.5, height*.4);
     // text(trialNo, width*.5, height*.5);
      
      break;
    } //end of case 3 (round 2)
    
    case 4 : {
      //--LEVEL4--//
      //text(level,100,100);
      textSize(30);
      text("Block 3",width*.5,height*.3);
      textSize(60);
      break;
    }//end of case 4 (instruction) 
    
    
    case 5: {
      //--LEVEL 5--// //-ROUND3-//
     // text(level,100,100);
     // text("Please produce the sign for ... ",width*.5,height*.3);
      text(Prompt, width*.5, height*.4);
     // text(trialNo, width*.5, height*.5);
      
      break;
    } //end of case 5 (round 3)
    
     case 6 : {
      //--LEVEL6--//
      //text(level,100,100);
      textSize(30);
      text("Block 4",width*.5,height*.3);
      textSize(60);
      break;
    }//end of case6 (instruction) 
    
    
    case 7: {
      //--LEVEL 7--// //-ROUND4-//
     // text(level,100,100);
      //text("Please produce the sign for ... ",width*.5,height*.3);
      text(Prompt, width*.5, height*.4);
     // text(trialNo, width*.5, height*.5);

      
      break;
    } //end of case 7 (round 4)
  
    case 8 : {
      //--LEVEL6--//
      //text(level,100,100);
      text("The END!",width*.5,height*.3);
      break;
    }//end of case6 (instruction) 
  
  
  }//end switch(level)

} //end draw loop