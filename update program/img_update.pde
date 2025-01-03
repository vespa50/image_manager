import java.io.FileWriter;   // Import the FileWriter class
import java.io.FileReader;
import java.io.IOException;
import java.lang.System;
import java.io.FileNotFoundException;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.Charset;
import java.time.*;

final private int dim = 15;
final private boolean debug= false;

boolean safe=false;
boolean prev =false;

String obbiettivo_add = "C:\\Users\\trava\\Desktop\\data\\tool\\general\\var\\hash\\in.txt";
String reject_add="C:\\Users\\trava\\Desktop\\data\\tool\\img_update\\reject.txt";
FileWriter myWriter;
FileWriter reject_writer;
BufferedReader reader;
File target;
String [] img_key=new String[1];
String [] img_path=new String[1];
boolean [] img_use=new boolean [0];
File [] img;
boolean load=true;
String source;
int toHash=0;
int toFind=0;
int toReject=0;
int f=0;
img_generate generator;
private Clock clock;
long time0=0;
long tin=0;
boolean speed=true;


void setup() {
  size(800, 800);
  background(#4DB1ED);
  frameRate(120);
  target =new File(obbiettivo_add);
  try {
    reader=new BufferedReader(new FileReader(target));
  }
  catch(FileNotFoundException e) {
    println("file not found");
    exit();
  }

  String line=null;
  try {
    line=reader.readLine();
  }
  catch(IOException e) {
    println("ioexception line");
  }
  source=line;
  img=new File(source).listFiles();
  for (int s=0; s<img.length; s++) {
    if (img[s].isDirectory()) {
      File [] partial = img[s].listFiles();
      img=joinarray(img, partial);
    }
  }
  img=seev(img);
  do {
    try {
      line=reader.readLine();
    }
    catch(IOException e) {
      println("ioexception file");
      exit();
    }
    if (line!=null) {
      if (line.length()>(dim*dim*2)+1) {
        img_key=joinarrays(img_key, line.substring(0, dim*dim*2));
        img_path=joinarrays(img_path, line.substring((dim*dim*2)+1));
      }
    }
  } while (line!=null);
  try {
    reader.close();
  }
  catch(IOException e) {
    println("ioexception reader close");
    exit();
  }
  println("file found: "+img.length+" hash found"+img_key.length);
  img_use=new boolean [img_key.length];
  for (int j=0; j<img_key.length; j++) {
    img_use[j]=false;
  }

  target=new File(reject_add);
  try {
    reject_writer=new FileWriter(target);
  }
  catch(IOException e) {
    println("ioexception reject writer");
    exit();
  }


  target=new File(obbiettivo_add);
  try {
    if (!(target.exists())) {
      println("need to create file");
      exit();
    }


    myWriter=new FileWriter(target);
    myWriter.write(source+"\n");
  }
  catch(IOException e) {
    println("ioexception open writer");
    e.printStackTrace();
    exit();
  }


  generator = new img_generate();
  generator.safe(false);
  clock = Clock.systemDefaultZone();
  time0=clock.millis();
  tin=time0;
  textSize(25);
  fill(0);
}



void draw() {

  if ((clock.millis()-time0>10000&!speed)|(clock.millis()-time0>1000&speed)||safe!=prev) {
    prev=safe;
    if (safe) {
      background(#4DB1ED);
    } else {
      background(#FC525D);
    }
    time0=clock.millis();
    textAlign(CENTER, CENTER);
    float per = ((float)f/img.length);
    text(f+"/"+img.length+" "+per*100+"% tfine"+time((((clock.millis()-tin)/per)*(1-per))), width/2, height/2);
  }

  boolean find=false;
  int indice=0;
  for (int ff=0; ff<img_path.length&!find; ff++) {
    if (img_path[ff].equals(img[f].getAbsolutePath())) {
      indice=ff;
      find=true;
      if (debug)println("find"+img[f].getAbsolutePath());
    }
  }
  //println(img_path[f]);
  if (!find) {
    if (debug)println(f+"\\"+img.length+" hash"+img[f].getAbsolutePath());
    generator.img_gen(img[f].getAbsolutePath(), myWriter, reject_writer);
    if (!safe) {
      fill(255);
      rect(10, 765, 150, 30);
      float per = ((float)f/img.length);
      fill(0);
      textAlign(LEFT, CENTER);
      text(time((((clock.millis()-tin)/per)*(1-per))), 15, 785);
      fill(0);
    }
    toHash++;
  } else {
    try {
      toFind++;
      myWriter.append(img_key[indice]+" "+img_path[indice]+"\n");
      img_use[indice]=true;
    }
    catch(IOException e) {
      println("ioexception");
    }
  }


  f++;
  if (!(f<img.length)) {
    try {
      myWriter.close();
      reject_writer.close();
    }
    catch(IOException e) {
      println("ioexception");
      exit();
    }
    println("to hash: "+(toHash-toReject));
    println("to find: "+toFind);
    println("to reject: "+toReject);
    if (img.length==toHash+toFind) {
      println("tutto ok");
    }
    exit();
  }
}

static File[] joinarray(File[] array1, File[] array2) {
  File[] result =new File [array1.length + array2.length];
  System.arraycopy(array1, 0, result, 0, array1.length);
  System.arraycopy(array2, 0, result, array1.length, array2.length);
  return result;
}

static File[] pushfile(File[] array1, File in) {
  File[] result;
  if (array1==null) {
    result =new File [1];
    result[0]=in;
  } else {
    result =new File [array1.length + 1];
    System.arraycopy(array1, 0, result, 0, array1.length);
    result[result.length-1]=in;
  }
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

File[] seev(File[] in) {
  File[] out=null;
  for (int i=0; i<in.length; i++) {
    String ext = in[i].getName().substring(in[i].getName().lastIndexOf('.') + 1);
    if (in[i].isFile()&(ext.equals("jpg")||ext.equals("png")||ext.equals("jpeg")||ext.equals("JPG"))&!in[i].isDirectory()) {
      out=pushfile(out, in[i]);
    }
  }
  return out;
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

void keyPressed() {
  if (key=='S') {
    safe=!safe;
    generator.safe(safe);
  } else if (key=='E') {
    exit();
  } else if (key=='V') {
    speed=!speed;
  }
}
