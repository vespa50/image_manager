import java.io.IOException;  // Import the IOException class to handle errors
import java.io.FileWriter;   // Import the FileWriter class
import java.io.FileReader;
import java.io.File;  // Import the File class
import java.time.*;
import java.lang.System;
import java.io.*;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.Charset;

class img_generate {
  private final int dim=15;
  private boolean go= false;
  private boolean end=false;

  private FileWriter myWriter;
  private FileWriter outval;
  private int not_found=0;
  private File [] files;
  private int i=0;
  private String ext="";
  private PImage scale;
  private String result = "";
  private String val="";
  private int j=0;
  private Clock clock;
  private long time0;
  private float percento=0;


  private String  destination;
  private String  cartelle;
  private File f;
  private boolean safe=true;
  private boolean prev=false;
  private boolean square=false;
  private boolean extnd =false;
  private boolean hide=false;
  private long acc=0;

  private int [] gray_val;

  img_generate() {
  }

  img_generate(File target) {
    cartelle=target.getAbsolutePath();
    destination=target.getName();
    gray_val=new int[dim*dim];
  }

  public boolean setup_img_gen() {
    background(255, 0, 0);
    File f= new File(sketchPath("")+"var");
    if (!f.exists()) {
      f.mkdir();
    }

    f= new File(path+"var\\hash");
    if (!f.exists()) {
      f.mkdir();
    }
    File reject = new File(path+"\\data\\reject.txt");
    try {
      outval=new FileWriter(reject, true);
    }
    catch(IOException e) {
      println("An error occurred.writer reject");
      e.printStackTrace();
      return false;
    }
    clock = Clock.systemDefaultZone();
    return true;
  }

  public boolean draw_img_gen() {
    if (go&!end) {
      //background(0, 0, 0);
      ext = files[i].getName().substring(files[i].getName().lastIndexOf('.') + 1);
      if (files[i].isFile()&&(ext.equals("jpg")||ext.equals("png")||ext.equals("jpeg")||ext.equals("JPG"))) {
        scale = loadImage(files[i].getAbsolutePath());
        if (!safe) {
          image(scale, 0, 0, 800, 800);
        }
        percento=i/(float)files.length;
        result = "";
        if (scale.width>0&&scale.height>0) {
          scale.filter(GRAY);

          for (int x=0; x<dim; x++) {
            for (int y=0; y<dim; y++) {
              int mean=0;
              int dim_w=floor(scale.width/dim);
              int dim_h=floor(scale.height/dim);
              for (int in_x=0; in_x<dim_w; in_x++) {
                for (int in_y=0; in_y<dim_h; in_y++) {
                  mean=mean+(scale.get(in_x+(x*dim_w), in_y+(y*dim_h))&0x000000ff);
                }
              }
              mean=mean/(dim_w*dim_h);
              gray_val[x+(y*dim)]=mean;
            }
          }
          if (prev) {
            image(scale, 0, 0, 800, 800);
          }
          if (!hide) {
            fill(255, 255, 255);
            rect(10, 670, 780, 90);
            fill(0, 0, 0);
            textAlign(TOP, LEFT);
            textSize(20);
            if (!safe) {
              if (extnd) {
                text(files[i].getAbsolutePath().substring(cartelle.lastIndexOf('\\'))+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
              } else {
                text(files[i].getName()+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
              }
            } else {
              if (extnd) {
                text(files[i].getAbsolutePath().substring(cartelle.lastIndexOf('\\'))+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
              } else {
                text(" file \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
              }
            }
          }
          for (j=0; j<dim*dim; j++) {
            val=String.format("%h", gray_val[j]);
            if (square) {
              fill(gray_val[j], gray_val[j], gray_val[j]);
              rect((j%dim)*((float)800/dim), ((int)(j/dim))*((float)800/dim), ((j%dim)+1)*((float)800/dim), ((int)(j/dim)+1)*((float)800/dim));
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
              outval.append("carattere "+files[i].getAbsolutePath()+"\n");
            }
            catch (IOException e) {
              println("An error occurred. outval write");
              e.printStackTrace();
            }
          }
        } else {
          try {
            outval.append("impossibile leggere "+files[i].getAbsolutePath()+"\n");
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
        textAlign(TOP, LEFT);
        textSize(20);
        percento=i/(float)files.length;
        if (!safe) {
          if (extnd) {
            text(files[i].getAbsolutePath().substring(cartelle.lastIndexOf('\\'))+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
          } else {
            text(files[i].getName()+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
          }
        } else {
          if (extnd) {
            text(files[i].getAbsolutePath().substring(cartelle.lastIndexOf('\\'))+" \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
          } else {
            text(" file \n"+(float)files[i].length()/1048576+"Mb  "+percento*100+" % "+i+" of "+files.length+"\nt fine:"+time((((clock.millis()-time0)/percento)*(1-percento))), 15, 700);
          }
        }
      }
      i++;
      if (i>=files.length) {
        end=true;
        go=false;
      }
    } else if (!go&!end) { //attesa iniziale
      f=new File(cartelle);
      if (!f.isDirectory()) {
        end=true;
        go=false;
        println("%s not found", cartelle);
      } else {
        files=f.listFiles();
        for (int s=0; s<files.length; s++) {
          if (files[s].isDirectory()) {
            File [] partial = files[s].listFiles();
            files=joinarray(files, partial);
          }
        }
        try {
          myWriter = new FileWriter(String.format(sketchPath("")+"\\var\\hash\\%s.txt", destination));
          myWriter.write(cartelle+"\n");
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
      return true;
    } else {//terminazione
      println("THE END "+destination);
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
      go=true;
      end=true;
    }
    return false;
  }

  private String time(float val) {
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

  private File[] joinarray(File[] array1, File[] array2) {
    File[] result =new File [array1.length + array2.length];
    System.arraycopy(array1, 0, result, 0, array1.length);
    System.arraycopy(array2, 0, result, array1.length, array2.length);
    return result;
  }

  void safe() {
    safe=!safe;
    if (safe==false) {
      prev=false;
      square=false;
    }
  }

  void fsafe() {
    safe=false;
    prev=false;
    square=false;
  }

  void prev() {
    prev=!prev;
  }
  void square() {
    square=!square;
  }
  void extend() {
    extnd=!extnd;
  }

  void hide() {
    hide=!hide;
  }


  private boolean isAlphanumeric(String text) {
    CharsetEncoder asciiEncoder = Charset.forName("US-ASCII").newEncoder();
    CharsetEncoder isoEncoder = Charset.forName("ISO-8859-1").newEncoder();
    return  asciiEncoder.canEncode(text) || isoEncoder.canEncode(text);
  }
}
