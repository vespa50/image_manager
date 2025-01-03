import java.io.IOException;  // Import the IOException class to handle errors
import java.io.FileWriter;   // Import the FileWriter class
import java.io.FileReader;
import java.io.File;  // Import the File class
import java.lang.System;
import java.io.*;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.Charset;

class img_generate {
  private PImage scale;
  private String result = "";
  private String val="";
  private int j=0;
  private int [] gray_val;


  private boolean safe=false;

  private File target;
  private String ext="";

  img_generate() {
    gray_val=new int[dim*dim];
  }

  public int img_gen(String target_add, FileWriter output, FileWriter reject) {
    target= new File(target_add);
    if (!target.isFile()) {
      return 1;
    }
    if (output==null||reject==null) {
      return 2;
    }
    ext = target_add.substring(target_add.lastIndexOf('.') + 1);
    if (target.isFile()&&(ext.equals("jpg")||ext.equals("png")||ext.equals("jpeg")||ext.equals("JPG"))) {
      scale = loadImage(target.getAbsolutePath());
      if (!safe) {
        image(scale, 0, 0, 800, 800);
      }

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

        if (!safe) {
          fill(255, 255, 255);
          rect(10, 670, 780, 90);
          fill(0, 0, 0);
          textAlign(TOP, LEFT);
          textSize(20);
          text(target.getAbsolutePath()+" "+(float)target.length()/1048576+"Mb", 15, 700, 680, 90);
        }


        //println(result);
        //println(files[i].getName().charAt('?'));
        if (isAlphanumeric(target.getName())) {
          for (j=0; j<dim*dim; j++) {
            val=String.format("%h", gray_val[j]);
            if (val.length()==1) {
              result=result+"0"+val;
            } else {
              result=result+val;
            }
          }
          try {
            output.append(result+" "+target.getAbsolutePath()+"\n");
          }
          catch (IOException e) {
            println("An error occurred.writer write result");
            e.printStackTrace();
          }
          return 0;
        } else {
          println("carattere "+target.getAbsolutePath()+"\n");
          toReject++;
          try {
            reject.append("carattere "+target.getAbsolutePath()+"\n");
          }
          catch (IOException e) {
            println("An error occurred. outval write");
            e.printStackTrace();
          }
        }
      } else {
        try {
          toReject++;
          reject.append("impossibile leggere "+target.getAbsolutePath()+"\n");
        }
        catch (IOException e) {
          println("An error occurred. outval write");
          e.printStackTrace();
        }
        println("not an image");
        return 3;
      }
    } else {
      return 2;
    }

    return 0;
  }

  public void safe(boolean val) {
    safe=val;
  }


  private boolean isAlphanumeric(String text) {
    CharsetEncoder asciiEncoder = Charset.forName("US-ASCII").newEncoder();
    CharsetEncoder isoEncoder = Charset.forName("ISO-8859-1").newEncoder();
    return  asciiEncoder.canEncode(text) || isoEncoder.canEncode(text);
  }
}
