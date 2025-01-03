import java.io.IOException;  // Import the IOException class to handle errors
import java.io.FileWriter;   // Import the FileWriter class
import java.io.File;  // Import the File class
import java.time.*;
import java.lang.System;

static String target= "C:\\Users\\trava\\Desktop\\data";
static String output="C:\\Users\\trava\\Desktop\\data\\tool\\extension.txt";

class extension {
  extension(String ext, int q, String first) {
    form=ext;
    num=q;
    val=pushS(val, first);
  }

  String []val;
  String form;
  int num=0;
}

extension[] q;
File choise= new File(target);
File [] files;
FileWriter myWriter;
String ext="";
boolean found=false;


void setup() {
  println("running");
  files=choise.listFiles();
  for (int s=0; s<files.length; s++) {
    if (files[s].isDirectory()) {
      File [] partial = files[s].listFiles();
      files=joinarray(files, partial);
    }
  }
  q=push(q, new extension("dir", 0, ""));

  for (int i=0; i<files.length; i++) {
    if (detectEmojis(files[i].getAbsolutePath())!=0) {
      println(files[i].getAbsolutePath());
    }
    ext = files[i].getName().substring(files[i].getName().lastIndexOf('.') + 1);
    if (ext.equals("jfif")) {
      println(files[i].getAbsolutePath());
      rename(files[i],"jpg");
    }else if (ext.equals("JPG")) {
      println(files[i].getAbsolutePath());
      rename(files[i],"jpg");
    }else if (ext.equals("jpg_large")) {
      println(files[i].getAbsolutePath());
      rename(files[i],"jpg");
    }
    
    
    for (int j=1; j<q.length; j++) {
      if (ext.equals(q[j].form)) {
        q[j].num++;
        if (q[j].num<=10) {
          q[j].val=pushS(q[j].val, files[i].getAbsolutePath());
        }
        found=true;
      }
    }
    if (!found&&!files[i].isDirectory()) {
      q=push(q, new extension(ext, 1, files[i].getAbsolutePath()));
    } else if (!found&&files[i].isDirectory()) {
      q[0].num++;
    }
    found=false;
  }

  try {
    myWriter = new FileWriter(output);
    for (int i=0; i<q.length; i++) {
      if (q[i].num<=10) {
        println("\n\n"+q[i].form+" "+q[i].num+"\n");
        for (int j=0; j<q[i].val.length; j++) {
          println( q[i].val[j]);
        }
      }
      myWriter.write(q[i].form+" "+q[i].num+"\n");
    }
    myWriter.close();
  }
  catch (IOException e) {
    println("An error occurred.");
    e.printStackTrace();
  }
  exit();
}

static extension[] push(extension[] array1, extension val) {
  extension[] result;
  if (array1!=null) {
    result =new extension [array1.length + 1];
    System.arraycopy(array1, 0, result, 0, array1.length);
    result[result.length-1]=val;
  } else {
    result = new extension [1];
    result[0]=val;
  }
  return result;
}



static File[] joinarray(File[] array1, File[] array2) {
  File[] result =new File [array1.length + array2.length];
  System.arraycopy(array1, 0, result, 0, array1.length);
  System.arraycopy(array2, 0, result, array1.length, array2.length);
  return result;
}

static String[] pushS(String[] array1, String val) {
  String[] result;
  if (array1==null) {
    result =new String [1];
    result[0]=val;
  } else {
    result =new String [array1.length + 1];
    System.arraycopy(array1, 0, result, 0, array1.length);
    result[array1.length]=val;
  }
  return result;
}

void keyPressed() {
  if (key=='E') {//end
    exit();
  }
}

private static boolean isEmoji(String message) {
  return message.matches("(?:[\uD83C\uDF00-\uD83D\uDDFF]|[\uD83E\uDD00-\uD83E\uDDFF]|" +
    "[\uD83D\uDE00-\uD83D\uDE4F]|[\uD83D\uDE80-\uD83D\uDEFF]|" +
    "[\u2600-\u26FF]\uFE0F?|[\u2700-\u27BF]\uFE0F?|\u24C2\uFE0F?|" +
    "[\uD83C\uDDE6-\uD83C\uDDFF]{1,2}|" +
    "[\uD83C\uDD70\uD83C\uDD71\uD83C\uDD7E\uD83C\uDD7F\uD83C\uDD8E\uD83C\uDD91-\uD83C\uDD9A]\uFE0F?|" +
    "[\u0023\u002A\u0030-\u0039]\uFE0F?\u20E3|[\u2194-\u2199\u21A9-\u21AA]\uFE0F?|[\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55]\uFE0F?|" +
    "[\u2934\u2935]\uFE0F?|[\u3030\u303D]\uFE0F?|[\u3297\u3299]\uFE0F?|" +
    "[\uD83C\uDE01\uD83C\uDE02\uD83C\uDE1A\uD83C\uDE2F\uD83C\uDE32-\uD83C\uDE3A\uD83C\uDE50\uD83C\uDE51]\uFE0F?|" +
    "[\u203C\u2049]\uFE0F?|[\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE]\uFE0F?|" +
    "[\u00A9\u00AE]\uFE0F?|[\u2122\u2139]\uFE0F?|\uD83C\uDC04\uFE0F?|\uD83C\uDCCF\uFE0F?|" +
    "[\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA]\uFE0F?)+");
}

public static int detectEmojis(String message) {
  int len = message.length(), NumEmoji = 0;
  // if the the given String is only emojis.
  if (isEmoji(message)) {
    for (int i = 0; i < len; i++) {
      // if the charAt(i) is an emoji by it self -> ++NumEmoji
      if (isEmoji(message.charAt(i)+"")) {
        NumEmoji++;
      } else {
        // maybe the emoji is of size 2 - so lets check.
        if (i < (len - 1)) { // some Emojis are two characters long in java, e.g. a rocket emoji is "\uD83D\uDE80";
          if (Character.isSurrogatePair(message.charAt(i), message.charAt(i + 1))) {
            i += 1; //also skip the second character of the emoji
            NumEmoji++;
          }
        }
      }
    }
    return NumEmoji;
  }
  return 0;
}

void rename(File file, String ext) {
  File file2 = new File(file.getAbsolutePath().substring(0,file.getAbsolutePath().lastIndexOf('.')+1)+ext);
  boolean success= file.renameTo(file2);
  if (!success) {
    println("fail to rename: "+file.getAbsolutePath()+" -> "+file2.getAbsolutePath());
  }
}
