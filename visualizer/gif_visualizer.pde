import java.io.IOException;
import java.io.FileReader;
import java.io.FileWriter;

String [] img1=new String[1];
String [] img2=new String[1];
String [] type=new String[1];
int dim=0;
String line="";
BufferedReader reader;
Gif image1;
Gif image2;
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
boolean dump=false;
String target;
int k=0;

void setup() {
  size(1600, 800);

  f= new File ("C:\\Users\\trava\\Desktop\\data\\tool\\3-visualizer\\append.txt");
  if (f.isFile()) {
    println("try to restore");
    i=restore();
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
    if (k<file-1) {
      //println(k+" "+choise[k][0]+" "+choise[k][1]+" "+img1[k]+" "+img2[k]);
      drawseed(choise[k][0], choise[k][1], img1[k], img2[k]);
      k++;
    } else {
      if (dump) {
        seev=false;
      } else {
        exit();
      }
    }
  } else {
    if (set) {
      if (f!=null) {
        try {
          reader = new BufferedReader(new FileReader(f));
        }
        catch (IOException e) {
          println("An error occurred.reader");
          e.printStackTrace();
        }
        set=false;
      }
    } else {
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
        background(0, 0, 0);
        textSize(20);
        f = new File(img1[i]);
        if (f.isFile()) {
          image1=new Gif(img1[i]);
          if (image1.width()>800) {
            image1.resize(800, 0);
          }
          if (image1.height()>800) {
            image1.resize(0, 800);
          }
          image1.imagegif(800, 0);
          if (!choise[i][0]) {
            fill(255, 255, 255);
          } else {
            fill(255, 0, 0);
          }
          if (vedo) {
            rect(10, 650, 630, 130);
            fill(0, 0, 0);
            text(img1[i]+" "+(float)f.length()/1048576+"Mb  dim:"+image1.width()+"X"+image1.height(), 10, 650, 630, 130);
          }
        } else {
          println("not file1");
          notfile=true;
        }
        f = new File(img2[i]);
        if (f.isFile()) {
          image2=new Gif(img2[i]);
          if (image2.width()>800) {
            image2.resize(800, 0);
          }
          if (image2.height()>800) {
            image2.resize(0, 800);
          }
          image2.imagegif(800, 0);
          if (! choise[i][1]) {
            fill(255, 255, 255);
          } else {
            fill(255, 0, 0);
          }
          if (vedo) {
            rect(960, 650, 630, 130);
            fill(0, 0, 0);
            text(img2[i]+" "+(float)f.length()/1048576+"Mb dim:"+image2.width()+"X"+image2.height(), 960, 650, 630, 130);
          }
        } else {
          println("not file2");
          notfile=true;
        }
        fill(255, 255, 255);
        rect(650, 700, 300, 80);
        fill(0, 0, 0);
        text(type[i]+" "+i+"/"+str(file-2), 650, 700, 300, 80);
      }
    }

    if (notfile) {
      if (avanti&i<file-2) {
        i++;
      } else if (!avanti&i>0) {
        i--;
      } else if (i==file-2) {
        app(0);
        setupseed();
        seev=true;
        dump=false;
      }
      notfile=false;
    }
  }
}

boolean [][] array(int dim) {
  boolean val [][] =new boolean [dim][2];
  return val;
}
int restore () {
  File append=new File("C:\\Users\\trava\\Desktop\\data\\tool\\3-visualizer\\append.txt");
  BufferedReader lettore=null;
  try {
    lettore=new BufferedReader(new FileReader("C:\\Users\\trava\\Desktop\\data\\tool\\3-visualizer\\append.txt"));
  }
  catch (IOException e) {
    println("An error occurred. bufferd reader restore");
    e.printStackTrace();
  }
  String Int_line=null;
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
  try {
    lettore.close();
  }
  catch (IOException e) {
    println("An error occurred. restore reader close");
    e.printStackTrace();
  }
  if (append.delete()) {
    println("restored");
  } else {
    println("Failed to delete the file.");
  }
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

void mouseClicked() {
  if (mouseX>650&mouseX<950&mouseY>700&mouseY<780) {
    if (mouseButton == LEFT&i>0) {
      i--;
      avanti=false;
    } else if (mouseButton == RIGHT&i<file-2) {
      i++;
      avanti=true;
    } else if (mouseButton == RIGHT&i==file-2) {
      app(0);
      setupseed();
      seev=true;
      k=0;
      dump=false;
    }
  }
  if (mouseX>10&mouseX<640&mouseY>700&mouseY<780) {//img1
    if (mouseButton==LEFT) {
      choise[i][0]=true;
    } else {
      choise[i][0]=false;
    }
  }
  if (mouseX>960&mouseX<1590&mouseY>700&mouseY<780) {
    if (mouseButton==LEFT) {
      choise[i][1]=true;
    } else {
      choise[i][1]=false;
    }
  }
}

void keyPressed() {
  if (key=='E') {//end

    app(0);
    setupseed();
    seev=true;
    k=0;
    dump=false;
  } else if (key=='S') {//save

    app(i);
    setupseed();
    seev=true;
    k=0;
    dump=false;
  } else if (key=='D') {//dump
    app(i);
    setupseed();
    seev=true;
    k=0;
    dump=true;
  } else if (key=='V') {//vedi
    vedo=!vedo;
  } else if (key=='F') {//forward
    i+=10;
  }
}



void app(int val) {
  if (val==0) {
    File t = new File ("C:\\Users\\trava\\Desktop\\data\\tool\\3-visualizer\\append.txt");
    if (t.isFile()) {
      t.delete();
      println("delete appende");
    }
    if (target!=null) {
      t=new File (target);
      if (t.isFile()) {
        println("delete target"+target);
        if (t.delete()) {
          println("deleted");
        }
      }
    }
  } else {
    try {
      app = new FileWriter("C:\\Users\\trava\\Desktop\\data\\tool\\3-visualizer\\append.txt");
    }
    catch (IOException e) {
      println("An error occurred. app creation");
      e.printStackTrace();
    }
    try {
      app.write(val+"\n"+target);
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
    ;
  }
}
/*
void setup() {
 size(1000,500);
 myAnimation = new Gif("C:\\Users\\trava\\Desktop\\data\\tool\\gif_visualizer\\data\\test.gif");
 anim= new Gif("C:\\Users\\trava\\Desktop\\data\\tool\\gif_visualizer\\data\\test.gif");
 }
 
 void draw() {
 anim.imagegif(0,0,width/2,height);
 translate(width/2,0);
 myAnimation.imagegif(0,0,width/2,height);
 
 }

void mousePressed() {
  a=!a;
  if (a) {
    anim.changeTarget( "C:\\Users\\trava\\Desktop\\data\\tool\\gif_visualizer\\data\\test.gif");
    myAnimation.changeTarget( "C:\\Users\\trava\\Desktop\\data\\tool\\gif_visualizer\\data\\test2.gif");
  } else {
    anim.changeTarget( "C:\\Users\\trava\\Desktop\\data\\tool\\gif_visualizer\\data\\test2.gif");
    myAnimation.changeTarget( "C:\\Users\\trava\\Desktop\\data\\tool\\gif_visualizer\\data\\test.gif");
  }
}*/
