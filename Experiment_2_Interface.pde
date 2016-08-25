import g4p_controls.*;
import processing.video.*;



//Data collection for BSL iconicity experiment
//trains participants on 16 signs (2 blocks)
//tests production and recall (counter-balanced blocks)


//This sketch expects to be inside a folder with a data folder containing "stimuli.txt" and video files. 

//Experimenter Presses button when participant ready to move on







///////////////////////////
//                       //
//      - GLOBALS -      //
//                       //
///////////////////////////



// - FILE - // 
String fn = "participantID.txt";
PrintWriter output;

// - EXPERIMENT STRUCTURE STUFF -//
Table stimTable;
int trialNo;
int currentTrial;
int level = 0; //zero except for debugging
int step = 0;

String item;
int iconic;
int veridical;
int dummyic;
String s; //to hold Movie filename String
String eng;
Movie signVid;


boolean engDisplayed;
boolean vPlayed;

int engStartTime;
int vidStartTime;
int engDuration = 1000;


//-- GUI STUFF --//
StringList choices; 
GButton LEVEL, TRIAL;
GButton train1, train2, test1, test2;
GWindow controls;

GButton c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;
//GButton[] bList = {c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15};








///////////////////////////
//                       //
//      -  SETUP  -      //
//                       //
///////////////////////////

void setup() {
  
  //--GENERAL + FORMATTING --//
  size(1200, 800);
  background(255);
  fill(0);
  textSize(40);
  textAlign(CENTER);
  imageMode(CENTER);

  output = createWriter(fn);
  output.println("HEADER LINE");
  
  
  //-- EXPERIMENT STRUCTURE STUFF --//
  
  stimTable = loadTable("stimuli.txt", "header,tsv");
  trialNo = 0;
  currentTrial = int(random(stimTable.getRowCount()));
  loadTrial();


  //--GUI STUFF --//
   G4P.setGlobalColorScheme(GCScheme.YELLOW_SCHEME);
   
   controls = GWindow.getWindow(this, "Controls", 50,10,500,500,JAVA2D);
   controls.addDrawHandler(this,"drawControls");
   
   LEVEL = new GButton(controls, 10, 10,120,60, "LEVEL +");
   LEVEL.setVisible(true);
   LEVEL.setEnabled(true);
   
   TRIAL = new GButton(controls, 10, 100, 120,60, "TRIAL+");
   TRIAL.setVisible(false);
   TRIAL.setEnabled(false);
   
   
    choices = new StringList(stimTable.getStringColumn("ENG"));
    choices.shuffle();
   
   //--RECALL TEST STUFF --//
  //this is tedious as anything but the clearest way to initialize all the choice buttons in the right place :(
  c0 = new GButton(this, 700, height*.3-25, 80, 50, choices.get(0));
  c0.setVisible(false);
  c0.setEnabled(false);
  c1 = new GButton(this, 800, height*.3-25, 80, 50, choices.get(1));
  c1.setVisible(false);
  c1.setEnabled(false);
  c2 = new GButton(this, 900, height*.3-25, 80, 50, choices.get(2));
  c2.setVisible(false);
  c2.setEnabled(false);
  c3 = new GButton(this, 1000, height*.3-25, 80, 50, choices.get(3));
  c3.setVisible(false);
  c3.setEnabled(false);  

  c4 = new GButton(this, 700, height*.4-25, 80, 50, choices.get(4));
  c4.setVisible(false);
  c4.setEnabled(false);
  c5 = new GButton(this, 800, height*.4-25, 80, 50, choices.get(5));
  c5.setVisible(false);
  c5.setEnabled(false);
  c6 = new GButton(this, 900, height*.4-25, 80, 50, choices.get(6));
  c6.setVisible(false);
  c6.setEnabled(false);
  c7 = new GButton(this, 1000, height*.4-25, 80, 50, choices.get(7));
  c7.setVisible(false);
  c7.setEnabled(false);

  c8 = new GButton(this, 700, height*.5-25, 80, 50, choices.get(8));
  c8.setVisible(false);
  c8.setEnabled(false);
  c9 = new GButton(this, 800, height*.5-25, 80, 50, choices.get(9));
  c9.setVisible(false);
  c9.setEnabled(false);
  c10 = new GButton(this, 900, height*.5-25, 80, 50, choices.get(10));
  c10.setVisible(false);
  c10.setEnabled(false);
  c11 = new GButton(this, 1000, height*.5-25, 80, 50, choices.get(11));
  c11.setVisible(false);
  c11.setEnabled(false);

  c12 = new GButton(this, 700, height*.6-25, 80, 50, choices.get(12));
  c12.setVisible(false);
  c12.setEnabled(false);
  c13 = new GButton(this, 800, height*.6-25, 80, 50, choices.get(13));
  c13.setVisible(false);
  c13.setEnabled(false);
  c14 = new GButton(this, 900, height*.6-25, 80, 50, choices.get(14));
  c14.setVisible(false);
  c14.setEnabled(false);
  c15 = new GButton(this, 1000, height*.6-25, 80, 50, choices.get(15));
  c15.setVisible(false);
  c15.setEnabled(false);

 
 


}





///////////////////////////
//                       //
//     -  CONTROLS  -    //
//                       //
///////////////////////////

public void drawControls(PApplet c, GWinData data) {
  c.background(255);
  //the rest is all done through the button handler
  c.fill(0);
  c.textSize(30);
  
  c.text("Level: "+level+" TRAINING BLOCK 1", 140, c.height-40);
  c.text("trialNo: "+trialNo, 140, 40);
  c.text("currentTrial"+currentTrial, 140, 80);
  c.text("item: "+item, 140, 120);
  c.text("iconic: "+iconic, 140, 160);
  c.text("veridical: "+veridical, 140, 200);
  c.text("dummyic: "+dummyic, 140, 240);
  c.text("signVid: "+s, 140, 280);
  c.text("eng: "+eng,140, 320);
 
  
}










///////////////////////////
//                       //
//    -  MAIN DRAW  -    //
//                       //
///////////////////////////


void draw() {
  background(255);


  switch(level) {

  case 0 : 
    {

      text("CASE ZERO"+
      "\nnewline", width*.5, height*.3);
     // text(level+" INSTRUCTION SCREEN", width*.5, height-40);

      break;
    } //end case 0 

  case 1: 
    {
      background(255);
      //text(level+" TRAINING BLOCK 1", width*.5, height-40);
      //text("trialNo: "+trialNo, 50, 30);
      //text("currentTrial"+currentTrial, 50, 50);
      //text("item: "+item, 50, 90);
      //text("iconic: "+iconic, 50, 110);
      //text("veridical: "+veridical, 50, 130);
      //text("dummyic: "+dummyic, 50, 150);
      //text("signVid: "+s, 50, 170);
      //text("eng: "+eng, 50, 190);
      
      
    switch(step) {
   
      case 0: //step0
      //--display english--//
      loadTrial();
      if (millis() - engStartTime > engDuration) {
      engDisplayed = true;
      loadTrial();
      vidStartTime = millis();
      step = 1;
    }
      if (!engDisplayed) { //displays English until engDisplayed is true
      text(eng, width/2, height/2);
    }
      break; //break step0
        
      
      case 1: //step1
      //--display Sign --//
      if (millis()-vidStartTime > (signVid.duration()*1000+500)) { //sets vPlayed to true 
      vPlayed = true;
    }  if (!vPlayed) { //reads video image until vPlayed is true
      image(signVid, width/2,height/2);
    } else {
      vidStartTime = millis();
      vPlayed = false;
      signVid.jump(0);
      signVid.play();
      step = 2;
    }
    break; //break step1
    
      case 2://step2
      //-- display English and Sign --//
      if (millis()-vidStartTime > (signVid.duration()*1000)) { //sets vPlayed to true
      vPlayed = true;
    }  if (!vPlayed) { //reads video image until vPlayed is true
      text(eng, width/2, 150);
      image(signVid, width/2,height/2);
    } else {
       text(eng, width/2, 150);
       text("Now Copy the Sign", width/2, height*0.3); //once video has played, elicit copying
       text("say 'next' when you are ready to move on", width/2, height*0.6);
    }
      
     break;  //break step2
    
    } //end switch(step);


      break;
    }//end case 1

  case 2 : 
    {

      //text("Training Block 2", width*.5, height*.5);
      //text(level+" INSTRUCTION SCREEN", width*.5, height-40);
      
      text("Thankyou. Please take a moment to stretch, shake out your arms, etc. \n"+
      "In the next section you will see the same signs again, and you will be asked to copy them again. \n" +
      "Try to Remember to stand in a neutral position with your arms by your side\n"+
      "whenever you are not producing a sign:"+
      "\n\n \n\n\nSay 'next' when you are ready to begin.", width*.5, height*.3);
      
      
      break;
    }//end case 2

  case 3: 
    {
      //text(level+" TRAINING BLOCK 2", width*.5, height-40);
      //text("trialNo: "+trialNo, 50, 30);
      //text("currentTrial"+currentTrial, 50, 50);
      //text("item: "+item, 50, 90);
      //text("iconic: "+iconic, 50, 110);
      //text("veridical: "+veridical, 50, 130);
      //text("dummyic: "+dummyic, 50, 150);
      //text("signVid: "+s, 50, 170);
      //text("eng: "+eng, 50, 190);
      //image(signVid, 200, 0);
      
 switch(step) {
   
      case 0: //step0
      //--display english--//
      loadTrial();
      if (millis() - engStartTime > engDuration) {
      engDisplayed = true;
      loadTrial();
      vidStartTime = millis();
      step = 1;
    }
      if (!engDisplayed) { //displays English until engDisplayed is true
      text(eng, width/2, height/2);
    }
      break; //break step0
        
      
      case 1: //step1
      //--display Sign --//
      if (millis()-vidStartTime > (signVid.duration()*1000+500)) { //sets vPlayed to true 
      vPlayed = true;
    }  if (!vPlayed) { //reads video image until vPlayed is true
      image(signVid, width/2,height/2);
    } else {
      vidStartTime = millis();
      vPlayed = false;
      signVid.jump(0);
      signVid.play();
      step = 2;
    }
    break; //break step1
    
      case 2://step2
      //-- display English and Sign --//
      if (millis()-vidStartTime > (signVid.duration()*1000)) { //sets vPlayed to true
      vPlayed = true;
    }  if (!vPlayed) { //reads video image until vPlayed is true
      text(eng, width/2, 150);
      image(signVid, width/2,height/2);
    } else {
       text(eng, width/2, 150);
       text("Now Copy the Sign", width/2, height*0.3); //once video has played, elicit copying
       text("say 'next' when you are ready to move on", width/2, height*0.6);
    }
      
     break;  //break step2
    
    } //end switch(step)





      break;
    }//end case 3

  case 4: 
    {

     // text("Production Test", width*.5, height*.5);
     // text(level+" INSTRUCTION SCREEN", width*.5, height-40);
     
      text("Thankyou. Please take a moment to stretch, shake out your arms, etc. \n"+
      "In the next section you will see English words, and you will be asked to produce the corresponding sign. \n" +
      "Try to Remember to stand in a neutral position with your arms by your side\n"+
      "whenever you are not producing a sign:"+
      "\n\n \n\n\nSay 'next' when you are ready to begin.", width*.5, height*.3);
     
     
      break;
    }

  case 5 : 
    {
      //text(level+" PRODUCTION TEST", width*.5, height-40);    
      //text("trialNo: "+trialNo, 50, 30);
      //text("currentTrial"+currentTrial, 50, 50);
      //text("item: "+item, 50, 90);
      //text("iconic: "+iconic, 50, 110);
      //text("veridical: "+veridical, 50, 130);
      //text("dummyic: "+dummyic, 50, 150);
      //text("signVid: "+s, 50, 170);
      //text("eng: "+eng, 50, 190);
      
      
 
      //--display english--//
      loadTrial();
      text("Please produce the sign for:",width/2,height*0.2);
      text("say 'next' when you are ready to move on", width/2, height*0.6);
      text(eng, width/2, height/2);

      break;
    }

  case 6 : 
    {

      //text("Recall Test", width*.5, height*.5);
      //text(level+" INSTRUCTION SCREEN", width*.5, height-40);
      
      text(
      "For the next section you will use the laptop." +
      
      "In the next section you will see videos of signs, and you will be asked to pick the correct English word. \n" +
      "For this section you will use the laptop"
      , width*.5, height*.3);
      

      break;
    }

  case 7: 
    {
      //text(level+" RECALL TEST", width*.5, height-40);     
      //text("trialNo: "+trialNo, 50, 30);
      //text("currentTrial"+currentTrial, 50, 50);
      //text("item: "+item, 50, 90);
      //text("iconic: "+iconic, 50, 110);
      //text("veridical: "+veridical, 50, 130);
      //text("dummyic: "+dummyic, 50, 150);
      //text("signVid: "+s, 50, 170);
      //text("eng: "+eng, 50, 190);
      //image(signVid, 200, 0);
      signVid.play();
      signVid.loop();
      image(signVid, width*.25,height*.45,854*.75,480*.75);
      text("What is this Sign?\n Pick the correct English word from the array on the right.", width*.25, height*.75);
       
      //choices presented thru buttonhandler
      break;
    }

  case 8: 
    {
      hideChoices();
      textSize(40);
      text("THE END!", width*.5, height*.50);
    }
  }//end switch(level)
}//end draw






///////////////////////////
//                       //
//     - FUNCTIONS -     //
//          ETC          //
//                       //
///////////////////////////


void loadTrial() { //reads all info from stimTable. 
  item = stimTable.getString(currentTrial, 0);
  iconic = stimTable.getInt(currentTrial, 1);
  veridical = stimTable.getInt(currentTrial, 2);
  dummyic = stimTable.getInt(currentTrial, 3);
  s = stimTable.getString(currentTrial, 4);
  signVid = new Movie(this, s);
  signVid.play();
  //signVid.loop();
  eng = stimTable.getString(currentTrial, 5);
}



public void handleButtonEvents(GButton button, GEvent event) {  
  
  if(button == LEVEL) {
    engDisplayed = false;
    vPlayed = false;
    level +=1;
    button.setVisible(false);
    button.setEnabled(false);
    TRIAL.setVisible(true);
    TRIAL.setEnabled(true);
    engStartTime = millis();
    step = 0;
    if (level == 7) {
        loadChoices();
        loadTrial();
        signVid.play();
        signVid.loop();
      } else if (level == 8) {
        hideChoices();
      }
  } else if (button == TRIAL) {
    if (trialNo == 15) {
    trialNo = 0;
    level +=1;
    button.setVisible(false);
    button.setEnabled(false);
    LEVEL.setVisible(true);
    LEVEL.setEnabled(true);
    stimTable =loadTable("stimuli.txt", "header,tsv");
  } else {
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    engDisplayed = false;
    vPlayed = false;
    engStartTime = millis();
    step = 0;
    loadTrial();
  }
  } else if (button == c0) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(0));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(0));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
    
  } else if (button == c1) {
   if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(1));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(1));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  } 
  } else if (button == c2) {
   if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(2));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(2));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  } 
  } else if (button == c3) {
   if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(2));
    output.flush();
    output.close();  
  } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(2));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  } 
  } else if (button == c4) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(4));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(4));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c5) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(5));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(5));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c6) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(6));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(6));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c7) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(7));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(7));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c8) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(8));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(8));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c9) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(9));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(9));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c10) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(10));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(10));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c11) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(11));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(11));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c12) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(12));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(12));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c13) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(13));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(13));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c14) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(14));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(14));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  } else if (button == c15) {
    if (trialNo == 15) {
    level +=1;
    output.println("RECALL\t"+trialNo+"\t"+choices.get(15));
    output.flush();
    output.close();
    } else  {
    background(255);
    output.println("RECALL\t"+trialNo+"\t"+choices.get(15));
    trialNo +=1;
    stimTable.removeRow(currentTrial);
    currentTrial = int(random(stimTable.getRowCount()));
    loadTrial();
  }
  }
}



void loadChoices() {
  //for (int b = 0; b < buttonList.length; b++) {
  //buttonList[b].setVisible(true);
  //buttonList[b].setEnabled(true);
  //}
  c0.setVisible(true); 
  c0.setEnabled(true);
  c1.setVisible(true); 
  c1.setEnabled(true);
  c2.setVisible(true); 
  c2.setEnabled(true);
  c3.setVisible(true); 
  c3.setEnabled(true);
  c4.setVisible(true); 
  c4.setEnabled(true);
  c5.setVisible(true); 
  c5.setEnabled(true);
  c6.setVisible(true); 
  c6.setEnabled(true);
  c7.setVisible(true); 
  c7.setEnabled(true);
  c8.setVisible(true); 
  c8.setEnabled(true);
  c9.setVisible(true); 
  c9.setEnabled(true);
  c10.setVisible(true); 
  c10.setEnabled(true);
  c11.setVisible(true); 
  c11.setEnabled(true);
  c12.setVisible(true); 
  c12.setEnabled(true);
  c13.setVisible(true); 
  c13.setEnabled(true);
  c14.setVisible(true); 
  c14.setEnabled(true);
  c15.setVisible(true); 
  c15.setEnabled(true);
}

void hideChoices() {

  //for (int b = 0; b < buttonList.length; b++) {
  //  buttonList[b].setVisible(false);
  //  buttonList[b].setEnabled(false);
  //}

  c0.setVisible(false); 
  c0.setEnabled(false);
  c1.setVisible(false); 
  c1.setEnabled(false);
  c2.setVisible(false); 
  c2.setEnabled(false);
  c3.setVisible(false); 
  c3.setEnabled(false);
  c4.setVisible(false); 
  c4.setEnabled(false);
  c5.setVisible(false); 
  c5.setEnabled(false);
  c6.setVisible(false); 
  c6.setEnabled(false);
  c7.setVisible(false); 
  c7.setEnabled(false);
  c8.setVisible(false); 
  c8.setEnabled(false);
  c9.setVisible(false); 
  c9.setEnabled(false);
  c10.setVisible(false); 
  c10.setEnabled(false);
  c11.setVisible(false); 
  c11.setEnabled(false);
  c12.setVisible(false); 
  c12.setEnabled(false);
  c13.setVisible(false); 
  c13.setEnabled(false);
  c14.setVisible(false); 
  c14.setEnabled(false);
  c15.setVisible(false); 
  c15.setEnabled(false);
}





void movieEvent(Movie m) {
  m.read();
}