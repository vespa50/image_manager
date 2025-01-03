import java.io.IOException;  // Import the IOException class to handle errors
import java.io.FileWriter;   // Import the FileWriter class
import java.io.FileReader;
import java.io.File;  // Import the File class
import java.time.*;
import java.lang.System;
import java.io.*;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.Charset;

boolean off=false;        //ATTENZIONE CONTROLLARE PRIMA DI ESEGUIRE

boolean go= false;
boolean end=false;

File source =new File("C:\\Users\\trava\\Desktop\\data\\tool\\img_generate\\in_data.txt");
File reject = new File("C:\\Users\\trava\\Desktop\\data\\reject.txt");
FileWriter myWriter;
FileWriter outval;
String line;
BufferedReader reader;
int not_found=0;
File [] files;
int i=0;
String ext="";
PImage scale;
String result = "";
String val="";
int j=0;
Clock clock;
long time0;
float percento=0;

int k=0;
String [] destination=new String[1];
String [] cartelle=new String[1];
File f;
boolean safe=false;
boolean prev=false;
boolean square=false;
long acc=0;
void setup() {
  size(800, 800);
  background(255, 0, 0);


  if (source!=null) {
    try {
      reader = new BufferedReader(new FileReader(source));
    }
    catch (IOException e) {
      println("An error occurred. reader open");
      e.printStackTrace();
    }
  } else {
    println("no source found");
    exit();
  }
  do {
    try {
      line=reader.readLine();
      println(line);
    }
    catch (IOException e) {
      println("An error occurred. reader read title");
      e.printStackTrace();
    }
    if (line!=null) {
      cartelle=joinarrays(cartelle, line);
    }

    try {
      line=reader.readLine();
      println(line);
    }
    catch (IOException e) {
      println("An error occurred.reader read line");
      e.printStackTrace();
    }
    if (line!=null) {
      destination=joinarrays(destination, line);
    }
  } while (line!=null);
  try {
    outval=new FileWriter(reject);
  }
  catch(IOException e) {
  }
  clock = Clock.systemDefaultZone();
}

void draw() {
  if (go&!end) {
    background(0, 0, 0);
    ext = files[i].getName().substring(files[i].getName().lastIndexOf('.') + 1);
    if (files[i].isFile()&&(ext.equals("jpg")||ext.equals("png")||ext.equals("jpeg")||ext.equals("JPG"))) {
      scale = loadImage(files[i].getAbsolutePath());
      if (!safe) {
        image(scale, 0, 0, width, height);
      }
      percento=i/(float)files.length;
      result = "";
      if (scale.width>0&&scale.height>0) {
        scale.filter(GRAY);
        scale.resize(8, 8);
        if (prev) {
          image(scale, 0, 0, width, height);
        }
        fill(255, 255, 255);
        rect(10, 670, 780, 90);
        fill(0, 0, 0);
        if (!safe) {
          text((k+1)+"\\"+(destination.length+1)+destination[k]+" "+files[i].getName()+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 675, 780, 780);
        } else {
          text((k+1)+"\\"+(destination.length+1)+" file \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 675, 780, 780);
        }
        for (j=0; j<64; j++) {
          val=String.format("%h", scale.pixels[j]&0x000000ff);
          if (square) {
            int a;
            if (val.length()==1) {
              a=Character.getNumericValue(val.charAt(0));
            } else {
              a=Character.getNumericValue(val.charAt(1))*16+Character.getNumericValue(val.charAt(0));
            }
            fill(a, a, a);
            rect((j%8)*(width/8), ((int)(j/8))*(height/8), ((j%8)+1)*(width/8), ((int)(j/8)+1)*(height/8));
          }
          if (val.length()==1) {
            result=result+"0"+val;
          } else {
            result=result+val;
          }
        }
        //println(result);
        //println(files[i].getName().charAt('?'));
        if (isAlphanumeric(files[i].getName())) {
          try {
            myWriter.write(result+" "+files[i].getAbsolutePath()+"\n");
          }
          catch (IOException e) {
            println("An error occurred.writer write result");
            e.printStackTrace();
          }
        } else {
          println("carattere "+files[i].getAbsolutePath()+"\n");
          try {
            outval.write("carattere "+files[i].getAbsolutePath()+"\n");
          }
          catch (IOException e) {
            println("An error occurred. outval write");
            e.printStackTrace();
          }
        }
      } else {
        try {
          outval.write("impossibile leggere "+files[i].getAbsolutePath()+"\n");
        }
        catch (IOException e) {
          println("An error occurred. outval write");
          e.printStackTrace();
        }
        println("not an image");
        not_found++;
      }
    } else {
      //println("not right image ext:",ext);
      fill(0, 0, 255);
      rect(10, 670, 780, 90);
      fill(0, 0, 0);
      percento=i/(float)files.length;
      if(!safe){ 
        text((k+1)+"\\"+(destination.length+1)+" "+files[i].getName()+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 675, 780, 780);
      }else{
        text((k+1)+"\\"+(destination.length+1)+" file \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 675, 780, 780);
      }
    }
    i++;
    if (i>=files.length) {
      end=true;
      go=false;
    }
  } else if (!go&!end) { //attesa iniziale
    if (k<destination.length) {
      f=new File(cartelle[k]);
      if (!f.isDirectory()) {
        end=true;
        go=false;
        println("%s not found", cartelle[k]);
      } else {
        files=f.listFiles();
        for (int s=0; s<files.length; s++) {
          if (files[s].isDirectory()) {
            File [] partial = files[s].listFiles();
            files=joinarray(files, partial);
          }
        }
        try {
          myWriter = new FileWriter(String.format("C:\\Users\\trava\\Desktop\\data\\var\\hash\\%s.txt", destination[k]));
          myWriter.write(cartelle[k]+"\n");
        }
        catch (IOException e) {
          println("An error occurred. open Writer");
          e.printStackTrace();
        }
        go=true;
        i=0;
        textSize(20);
        time0=clock.millis();
      }
    } else {
      go=true;
      end=true;
    }
  } else if (go&end) {
    try {
      outval.close();
    }
    catch(IOException e) {
      println("An error occurred. outval close");
      e.printStackTrace();
    }
    println("tempo totale:"+time(acc));
    delay(5000);
    if (off) {
      turnoff();
    }
    exit();
  } else {//terminazione
    println("THE END "+destination[k]);
    println("not found:"+not_found);
    try {
      myWriter.close();
    }
    catch(IOException e) {
      println("An error occurred. writer close");
      e.printStackTrace();
    }

    background(0, 255, 0);
    fill(255, 255, 255);
    rect(10, 670, 780, 90);
    fill(0, 0, 0);
    text("eseguito in "+time(clock.millis()-time0)+"\n not found:"+not_found, 15, 675, 780, 780);
    acc+=clock.millis()-time0;
    go=false;
    end=false;
    k++;
  }
}

String time(float val) {
  int min = (int)val/60000;
  float sec= (val-(min*60000))/1000;
  if (min>=60) {
    int hour=min/60;
    min=min-(hour*60);
    return(hour+"h"+min+"min "+sec+"s");
  } else {
    return (min+"min "+sec+"s");
  }
}

static File[] joinarray(File[] array1, File[] array2) {
  File[] result =new File [array1.length + array2.length];
  System.arraycopy(array1, 0, result, 0, array1.length);
  System.arraycopy(array2, 0, result, array1.length, array2.length);
  return result;
}

String[] joinarrays(String[] array1, String val) {
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

void keyPressed() {
  if (key=='E') {//end
    exit();
  }
  if (key=='S') {
    safe= !safe;
  }
  if (key=='P') {
    prev= !prev;
  }
  if (key=='Q') {
    square= !square;
  }
}


private static boolean isAlphanumeric(String text) {
  CharsetEncoder asciiEncoder = Charset.forName("US-ASCII").newEncoder();
  CharsetEncoder isoEncoder = Charset.forName("ISO-8859-1").newEncoder();
  return  asciiEncoder.canEncode(text) || isoEncoder.canEncode(text);
}


void turnoff() {
  String fn="term.bat";
  launch(sketchPath("")+fn);
}
