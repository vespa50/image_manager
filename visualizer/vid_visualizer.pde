import java.awt.Desktop;
import java.io.File;
import java.io.IOException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import processing.video.*;

final static int max_skip=7000;

String [] img1=new String[1];
String [] img2=new String[1];
String [] type=new String[1];
int dim=0;
String line="";
BufferedReader reader;
Movie image1;
Movie image2;
boolean show=false;
int i=0;
File f;
FileWriter app;
int file=0;
boolean choise [][];
boolean set=true;
boolean vedo=true;
boolean notfile=false;
boolean avanti=true;
boolean seev=false;
boolean first=true;
String target;
int k=0;

final boolean delatend=true;
String fappend="C:\\Users\\trava\\Desktop\\data\\tool\\video_visualizer\\append.txt";

void setup() {
  size(1600, 800);
  f= new File (fappend);
  if (f.isFile()) {
    println("try to restore");
    i=restore(choise);
  } else {
    f=null;
    println("select file");
    selectInput("Select a file to process:", "folderSelected");
  }

  textSize(60);
  fill(255, 255, 255);
}

void draw() {
  if (seev) {
    if (k==0) {
      for (int j=0; j<file-1; j++) {
        if (choise[j][0]) {
          println(img1[j]);
        } else if (choise[j][1]) {
          println(img2[j]);
        }
      }
    }
    if (k<file-1) {

      drawseed(choise[k][0], choise[k][1], img1[k], img2[k]);
      k++;
    } else {
      exit();
    }
  } else {
    if (set) {
      if (f!=null) {
        try {
          InputStream is = new FileInputStream(f);
          InputStreamReader reader1 = new InputStreamReader(is, "ISO-8859-1");
          reader = new BufferedReader(reader1);
        }
        catch (IOException e) {
          println("An error occurred.reader");
          e.printStackTrace();
        }
        set=false;
      }
    } else {
      //float rat =mouseX / (float) width;
      if (!show) {//load
        try {
          line=reader.readLine();
          println(line);
        }
        catch (IOException e) {
          println("An error occurred. line read 1");
          e.printStackTrace();
        }
        if (line!=null) {
          type=joinarray(type, line);
        } else {
          textSize(20);
          textAlign(BASELINE);
          show=true;
        }
        try {
          line=reader.readLine();
          println(line);
        }
        catch (IOException e) {
          println("An error occurred. line read 2");
          e.printStackTrace();
        }
        if (line!=null) {
          img1=joinarray(img1, line);
        } else {
          textSize(20);
          textAlign(BASELINE);
          show=true;
        }
        try {
          line=reader.readLine();
          println(line);
        }
        catch (IOException e) {
          println("An error occurred. line read 2");
          e.printStackTrace();
        }
        if (line!=null) {
          img2=joinarray(img2, line);
        } else {
          textSize(20);
          textAlign(BASELINE);
          show=true;
          choise=array(file);
        }
        file++;
        background(0, 0, 0);
        textAlign(CENTER, CENTER);
        text("reading"+file, width/2, height/2);
        if (show) {
          try {
            reader.close();
          }
          catch (IOException e) {
            println("An error occurred. reader close");
            e.printStackTrace();
          }
        }
      } else {//show
        background(0);
        f = new File(img1[i]);
        int wid=0;
        int hei=0;
        if (f.exists() && !f.isDirectory()) {

          if (Integer.parseInt(type[i].substring(type[i].lastIndexOf(" ")+1, type[i].length()))>max_skip) {
            println("not similar");
            notfile=true;
          }
          if (first&!notfile) {
            image1=new Movie(this, img1[i]);
            image1.play();
            println("first");
            if (i%10==0&i!=0) {
              app(i);
            }
          }
          if (f.length()==0|notfile) {
            first=true;
          } else {
            try {
              //image1.jump(rat*image1.duration());
              wid = image1.sourceWidth;
              hei = image1.sourceHeight;
              if (image1.sourceWidth>800) {
                scale((float)800/image1.sourceWidth);
                image(image1, 0, 0);
                scale((float)image1.sourceWidth/800);
              } else if (image1.sourceHeight>800) {
                scale((float)800/image1.sourceHeight);
                image(image1, 0, 0);
                scale((float)image1.sourceHeight/800);
              }
            }
            catch(ArrayIndexOutOfBoundsException e) {
              println("out of bound 1");
              first=true;
            }
          }
        } else {
          println("not file1"+f.getAbsolutePath());
          notfile=true;
        }
        if (!choise[i][0]) {
          fill(255, 255, 255);
        } else {
          fill(255, 0, 0);
        }
        if (vedo) {
          rect(10, 650, 630, 130);
          fill(0, 0, 0);
          text(img1[i]+" "+(float)f.length()/1048576+"Mb "+wid+"X"+hei, 10, 650, 630, 130);
        }
        f = new File(img2[i]);
        if (f.exists() && !f.isDirectory()&!notfile) {

          if (first&!notfile) {
            image2=new Movie(this, img2[i]);
            image2.speed(image1.frameRate/image2.frameRate);
            image2.play();
          }
          if (f.length()==0|notfile) {
            first=true;
          } else {
            try {
              //image2.jump(rat*image2.duration());
              wid = image2.sourceWidth;
              hei = image2.sourceHeight;
              translate(800, 0);
              if (image2.sourceWidth>800) {
                scale((float)800/image2.sourceWidth);
                image(image2, 0, 0);
                scale((float)image2.sourceWidth/800);
              } else if (image2.sourceHeight>800) {
                scale((float)800/image2.sourceHeight);
                image(image2, 0, 0);
                scale((float)image2.sourceHeight/800);
              }
              translate(-800, 0);
            }
            catch(ArrayIndexOutOfBoundsException e) {
              println("out of bound 2");
              first=true;
            }
          }
        } else {
          println("not file2"+f.getAbsolutePath());
          notfile=true;
        }



        if (! choise[i][1]) {
          fill(255, 255, 255);
        } else {
          fill(255, 0, 0);
        }
        if (vedo) {
          rect(960, 650, 630, 130);
          fill(0, 0, 0);
          text(img2[i]+" "+(float)f.length()/1048576+"Mb "+wid+"X"+hei, 960, 650, 630, 130);
        }

        fill(255, 255, 255);
        rect(650, 700, 300, 80);
        fill(0, 0, 0);
        text(type[i]+" "+i+"/"+str(file-2), 650, 700, 300, 80);
        first=false;
      }
    }

    if (notfile) {
      if (avanti&i<file-2) {
        try {
          image1.stop();
          image2.stop();
          image1=null;
          image2=null;
        }
        catch(Exception e) {
        }
        i++;
        first=true;
      } else if (!avanti&i>0) {
        try {
          image1.stop();
          image2.stop();
          image1=null;
          image2=null;
        }
        catch(Exception e) {
        }
        i--;
        first=true;
      } else if (i==file-2) {
        app(0);
        setupseed();
        seev=true;
      }
      notfile=false;
    }
  }
}

boolean [][] array(int dim) {
  boolean val [][] =new boolean [dim][2];
  return val;
}

int restore (boolean [][]choise) {
  File append=new File(fappend);
  BufferedReader lettore=null;
  try {
    lettore=new BufferedReader(new FileReader(fappend));
  }
  catch (IOException e) {
    println("An error occurred. bufferd reader restore");
    e.printStackTrace();
  }
  String Int_line="";
  try {
    Int_line= lettore.readLine();
  }
  catch (IOException e) {
    println("An error occurred. line read restore");
    e.printStackTrace();
  }
  int In_Value = Integer.parseInt(Int_line);
  try {
    Int_line= lettore.readLine();
    println(Int_line+" line");
    f=new File(Int_line);
    target=Int_line;
  }
  catch (IOException e) {
    println("An error occurred. file read restore");
    e.printStackTrace();
  }

  do {
    try {
      Int_line= lettore.readLine();
    }
    catch (IOException e) {
      println("An error occurred. file read restore");
      e.printStackTrace();
      Int_line=null;
    }
    if (Int_line!=null) {
      if (Int_line.equals("false false")) {
        choise=joinarrayb(choise, false, false);
      } else if (Int_line.equals("false true")) {
        choise=joinarrayb(choise, false, true);
      } else if (Int_line.equals("true false")) {
        choise=joinarrayb(choise, true, false);
      } else if (Int_line.equals("true true")) {
        choise=joinarrayb(choise, true, true);
      } else {
        println("something happens");
      }
    }
  } while (Int_line!=null);

  try {
    lettore.close();
  }
  catch (IOException e) {
    println("An error occurred. restore reader close");
    e.printStackTrace();
  }
  /*if (append.delete()) {
   println("restored");
   } else {
   println("Failed to delete the file.");
   }*/
  return In_Value;
}
String[] joinarray(String[] array1, String val) {
  String[] result;
  if (array1[0]!=null) {
    result =new String [array1.length + 1];
    System.arraycopy(array1, 0, result, 0, array1.length);
    result[result.length-1]=val;
  } else {
    result =new String [1];
    result[0]=val;
  }
  return result;
}

boolean[][] joinarrayb(boolean[][] array1, boolean val1, boolean val2) {
  boolean[][] result;
  if (array1!=null) {
    result =new boolean [array1.length + 1][2];
    System.arraycopy(array1, 0, result, 0, array1.length);
    result[result.length-1][0]=val1;
    result[result.length-1][1]=val2;
  } else {
    result =new boolean [1][2];
    result[0][0]=val1;
    result[0][1]=val2;
  }
  return result;
}

void mouseClicked() {
  if (mouseX>650&mouseX<950&mouseY>700&mouseY<780) {
    if (mouseButton == LEFT&i>0) {
      if (image1!=null) {
        image1.stop();
      }
      if (image2!=null) {
        image2.stop();
      }
      i--;
      avanti=false;
      first=true;
    } else if (mouseButton == RIGHT&i<file-2) {
      if (image1!=null) {
        image1.stop();
      }
      if (image2!=null) {
        image2.stop();
      }
      i++;
      avanti=true;
      first=true;
    } else if (mouseButton == RIGHT&i==file-2) {
      app(0);
      setupseed();
      seev=true;
    }
  } else if (mouseX>10&mouseX<640&mouseY>700&mouseY<780) {//img1
    if (mouseButton==LEFT) {
      choise[i][0]=true;
    } else {
      choise[i][0]=false;
    }
  } else if (mouseX>960&mouseX<1590&mouseY>700&mouseY<780) {
    if (mouseButton==LEFT) {
      choise[i][1]=true;
    } else {
      choise[i][1]=false;
    }
  } else {
    if (mouseX<width/2) {
      File file = new File(img1[i]);
      Desktop desktop = Desktop.getDesktop();
      if (file.exists()) {
        try {
          desktop.open(file);
        }
        catch(IOException e) {
        }
      }
    } else {
      File file = new File(img2[i]);
      Desktop desktop = Desktop.getDesktop();
      /*if(file.exists()){
       try{
       desktop.open(file);
       }catch(IOException e){
       
       }
       }*/
      try {
        desktop.open(file);
      }
      catch(IOException e) {
      }
    }
  }
}

void keyPressed() {
  if (key=='E') {//end

    app(0);
    setupseed();
    seev=true;
  } else if (key=='S') {//save

    app(i);
    setupseed();
    seev=true;
  } else if (key=='D') {//dump
  } else if (key=='V') {//vedi
    vedo=!vedo;
  } else if (key=='F') {//forward
    i+=10;
  }
}



void app(int val) {
  if (val==0) {
    File t = new File (fappend);
    if (t.isFile()) {
      t.delete();
      println("delete appende");
    }
    if (target!=null) {
      t=new File (target);
      if (t.isFile()&delatend) {
        println("delete target"+target);
        if (t.delete()) {
          println("deleted");
        }
      }
    }
  } else {
    try {
      app = new FileWriter(fappend);
    }
    catch (IOException e) {
      println("An error occurred. app creation");
      e.printStackTrace();
    }
    try {
      app.write(val+"\n"+target+"\n");
      for (int i=0; i<choise.length; i++) {
        app.write(choise[i][0]+" "+choise[i][1]+"\n");
      }
    }
    catch (IOException e) {
      println("An error occurred. app write");
      e.printStackTrace();
    }

    try {
      app.close();
    }
    catch(IOException e) {
      println("An error occurred. app close");
      e.printStackTrace();
    }
  }
}

void folderSelected(File selection) {
  background(255, 0, 0);
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    f=selection;
    target=selection.getAbsolutePath();
  }
}

void movieEvent(Movie m) {
  m.read();
}
