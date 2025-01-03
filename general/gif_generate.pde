import java.io.File;
import java.io.IOException;
import java.io.FileInputStream;   // Import the FileWriter class
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.time.*;
import java.io.*;
import java.io.FileReader;
import java.io.FileWriter;

class gif_generate {
  private final int dim=15;
  File [] files;
  BufferedImage [] frames=null;
  int fcount=0;
  boolean load=true;
  int index=0;
  int im=0;
  GifDecoder d;
  FileInputStream file;
  FileWriter myWriter;
  PImage scale;
  Clock clock;
  long time0;
  float percento=0;
  boolean app=false;
  String name;
  boolean safe=false;
  int tprec=0;
  String[] hashes;
  boolean ext=false;
  private int [] gray_val;

  boolean setup_gif_gen(File dir) {
    File f= new File(sketchPath("")+"var");
    if (!f.exists()) {
      f.mkdir();
    }

    f= new File(path+"var\\hash_gif");
    if (!f.exists()) {
      f.mkdir();
    }
    if (!restore()) {
      return false;
    }
    files=dir.listFiles();
    name=dir.getName().substring(dir.getName().lastIndexOf('\\') + 1);
    for (int s=0; s<files.length; s++) {
      if (files[s].isDirectory()) {
        File [] partial = files[s].listFiles();
        files=joinarray(files, partial);
      }
    }
    files=seev(files);
    d = new GifDecoder();
    try {
      myWriter = new FileWriter(path+"\\var\\hash_gif\\"+name+".txt", app);
    }
    catch (IOException e) {
      println("An error occurred.");
      e.printStackTrace();
      return false;
    }
    clock = Clock.systemDefaultZone();
    time0=clock.millis();
    textSize(13);
    gray_val=new int[dim*dim];
    return true;
  }

  boolean draw_gif_gen() {
    if (load) {
      if (!isAlphanumeric(files[im].getAbsolutePath())) {
        File reject = new File(path+"\\data\\reject.txt");
        try {
          FileWriter outval=new FileWriter(reject, true);
          outval.append("GIF carattere "+files[im].getAbsolutePath()+"\n");
          outval.close();
        }
        catch(IOException e) {
          println("An error occurred.writer reject");
          e.printStackTrace();
        }
      }
      try {
        file = new FileInputStream(files[im].getAbsolutePath());
      }
      catch(FileNotFoundException e) {
      }

      d.read(file);
      fcount=d.getFrameCount();
      for (int i=0; i<fcount; i++) {
        BufferedImage img = d.getFrame(i);
        if (img!=null) {
          //iprint(img,"C:\\Users\\Fabio\\Desktop\\fsc_hologram\\image\\"+i+".png");
          frames=pushimg(frames, img);
        }
      }
      load=false;
    } else {
      if (fcount>0) {
        if (safe) {
          image(buf_to_img(frames[index]), 0, 0, 800, 800);
        }
        percento=(im/(float)files.length)+(index/(float)frames.length)*(1/(float)files.length);
        scale=buf_to_img(frames[index]);
        String result = "";
        String val="";
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
          for (int j=0; j<dim*dim; j++) {
            val=String.format("%h", gray_val[j]);
            if (val.length()==1) {
              result=result+"0"+val;
            } else {
              result=result+val;
            }
          }
          if (ext) {
            fill(255);
            rect(0, 720, width, 70);
            fill(0);
            textAlign(CENTER, TOP);
            text(files[im].getAbsolutePath()+" \n"+nf((float)files[im].length()/1048576, 0, 3)+"Mb  "+nf(percento*100, 0, 3)+"%  "+index+" of "+(frames.length-1)+" "+im+"of"+files.length+"\nt fine:"+time((((clock.millis()-time0+tprec)/percento)*(1-percento))), width*0.5, 730);
          } else {
            if (safe) {
              float wid =textWidth(files[im].getName());
              if (wid<width/2) {
                fill(255);
                rect(width/4, 720, width/2, 70);
                fill(0);
                textAlign(CENTER, TOP);
                text(files[im].getName()+" \n"+nf((float)files[im].length()/1048576, 0, 3)+"Mb  "+nf(percento*100, 0, 3)+"%  "+index+" of "+(frames.length-1)+" "+im+"of"+files.length+"\nt fine:"+time((((clock.millis()-time0+tprec)/percento)*(1-percento))), width*0.5, 730);
              } else {
                fill(255);
                rect((width-wid)/2, 720, wid, 70);
                fill(0);
                textAlign(CENTER, TOP);
                text(files[im].getName()+" \n"+nf((float)files[im].length()/1048576, 0, 3)+"Mb  "+nf(percento*100, 0, 3)+"%  "+index+" of "+(frames.length-1)+" "+im+"of"+files.length+"\nt fine:"+time((((clock.millis()-time0+tprec)/percento)*(1-percento))), width*0.5, 730);
              }
            } else {
              fill(255);
              rect(width/3, 720, width/3, 70);
              fill(0);
              textAlign(CENTER, TOP);
              text("file \n"+nf((float)files[im].length()/1048576, 0, 3)+"Mb  "+nf(percento*100, 0, 3)+"%  "+index+" of "+frames.length+" "+im+"of"+(files.length-1)+"\nt fine:"+time((((clock.millis()-time0+tprec)/percento)*(1-percento))), width*0.5, 730);
            }
          }
          hashes=pushstring(hashes, result+" "+files[im].getAbsolutePath()+"\n");
        }
        index++;
        if (index>=fcount) {
          for (int i=0; i<hashes.length; i++) {
            try {
              myWriter.write(hashes[i]);
            }
            catch (IOException e) {
              println("An error occurred.");
              e.printStackTrace();
            }
          }
          hashes=null;
          index=0;
          im++;
          save();
          load=true;
          frames=null;
        }
      } else {
        index=0;
        im++;
        save();
        load=true;
        frames=null;
      }
      if (im>=files.length) {
        try {
          String fileName = dataPath("saved.png");
          File f = new File(fileName);
          if (f.exists()) {
            f.delete();
          }
          myWriter.close();
          file.close();
        }
        catch (IOException e) {
          println("An error occurred.");
          e.printStackTrace();
          return false;
        }
        index=-1;
        im=-1;
        save();
        println("eseguito in "+time(clock.millis()-time0+tprec));
        return true;
      }
    }
    return false;
  }

  PImage buf_to_img(BufferedImage val) {
    try {
      File outputfile = new File("saved.png");
      ImageIO.write(val, "png", outputfile);
      PImage image  = loadImage("saved.png");
      return image;
    }
    catch (IOException e) {
      println("exception reaised");
      exit();
    }
    return null;
  }

  BufferedImage [] pushimg(BufferedImage [] array, BufferedImage val) {
    BufferedImage [] result=null;
    if (array!=null) {
      result = new BufferedImage[array.length+1];
      System.arraycopy(array, 0, result, 0, array.length);
      result[result.length-1]=val;
    } else {
      result = new BufferedImage[1];
      result[0]=val;
    }
    return result;
  }

  File [] pushfile(File [] array, File val) {
    File [] result=null;
    if (array!=null) {
      result = new File[array.length+1];
      System.arraycopy(array, 0, result, 0, array.length);
      result[result.length-1]=val;
    } else {
      result = new File[1];
      result[0]=val;
    }
    return result;
  }

  String [] pushstring(String [] array, String val) {
    String [] result=null;
    if (array!=null) {
      result = new String[array.length+1];
      System.arraycopy(array, 0, result, 0, array.length);
      result[result.length-1]=val;
    } else {
      result = new String[1];
      result[0]=val;
    }
    return result;
  }

  File[] joinarray(File[] array1, File[] array2) {
    File[] result =new File [array1.length + array2.length];
    System.arraycopy(array1, 0, result, 0, array1.length);
    System.arraycopy(array2, 0, result, array1.length, array2.length);
    return result;
  }

  File [] seev(File[] in) {
    File[] result=null;
    for (int i=0; i<in.length; i++) {
      if (((String)in[i].getName().substring(in[i].getName().lastIndexOf('.') + 1)).equals("gif")&in[i].isFile()) {
        result=pushfile(result, in[i]);
      }
    }
    return result;
  }

  String time(float val) {
    int min = (int)val/60000;
    float sec= (val-(min*60000))/1000;
    if (min>=60) {
      int hour=min/60;
      min=min-(hour*60);
      return(hour+"h"+min+"min "+nf(sec, 2, 3)+"s");
    } else {
      return (min+"min "+nf(sec, 2, 3)+"s");
    }
  }

  void save() {
    File out= new File(path+"\\data\\app.txt");
    FileWriter wrt=null;
    if (index!=-1&im!=-1) {
      try {
        wrt= new FileWriter(out);
        wrt.write(im+"\n"+(clock.millis()-time0+tprec));
        wrt.close();
      }
      catch(IOException e) {
      }
    } else {
      if (out.delete()) {
        println("completed");
      } else {
        println("Failed to delete the file.");
      }
    }
  }

  boolean restore() {
    File in= new File(path+"\\data\\app.txt");
    if (in.isFile()) {
      BufferedReader rdt=null ;
      try {
        rdt= new BufferedReader(new FileReader(in));
        String Int_line= rdt.readLine();
        int In_Value = Integer.parseInt(Int_line);
        im=In_Value;
        Int_line= rdt.readLine();
        In_Value = Integer.parseInt(Int_line);
        tprec=In_Value;
        rdt.close();
        if (in.delete()) {
          println("restored");
        } else {
          println("Failed to delete the file.");
          return false;
        }
      }
      catch (IOException e) {
        println("An error occurred. line read restore");
        e.printStackTrace();
        return false;
      }
      app=true;
    } else {
      app=false;
    }
    return true;
  }

  void iprint(BufferedImage a, String out) {
    File outputfile = new File(out);
    try {
      ImageIO.write(a, "png", outputfile);
    }
    catch(IOException e) {
    }
  }

  void safe() {
    safe=!safe;
  }

  void fsafe() {
    safe=false;
  }

  void extend() {
    ext=!ext;
  }

  private boolean isAlphanumeric(String text) {
    CharsetEncoder asciiEncoder = Charset.forName("US-ASCII").newEncoder();
    CharsetEncoder isoEncoder = Charset.forName("ISO-8859-1").newEncoder();
    return  asciiEncoder.canEncode(text) || isoEncoder.canEncode(text);
  }
}
