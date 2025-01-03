import java.io.File;  // Import the File class

boolean go = false; 

File choise;


void setup() {
  size(100,100);
  background(255,0,0);
  selectFolder("Select a folder to process:", "folderSelected");
}

void draw(){
  
  if(go){
  File dir = new File(choise.getAbsolutePath());
  File [] files = dir.listFiles();
  for(int i=0;i<files.length;i++){
    println(files[i].getPath()+" "+files[i].getName()+" "+(float)files[i].length()/1000000+"Mb  "+((float)(i*100)/(float)files.length)+" %");
    if(files[i].isFile()){
      PImage a = loadImage(files[i].getAbsolutePath());
      if(a.width>displayWidth||a.height>displayHeight){
          print("resize"+files[i].length());
          if(a.width>displayWidth){
            a.resize(displayWidth,0);
          }else{
            a.resize(0,displayHeight);
          }
          a.save(choise.getAbsolutePath()+"\\"+files[i].getName());
          println(" ->");
        }else{
         
          println("ok"); 
        }
    }
   
  }
   
   println("THE END");
   go=false;
   background(0,255,0);
   }
}


void folderSelected(File selection) {
  background(255,0,0);
    if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    choise=selection;
    println("User selected " + choise.getAbsolutePath());
    go=true;
    
  }
}


void mousePressed(){
  exit();
}
