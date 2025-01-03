import java.io.File;
import java.io.IOException;
import java.io.FileInputStream;   // Import the FileWriter class
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.time.*;
import java.io.*;
import java.io.FileReader;
import java.io.FileWriter;



File [] files;
File dir=new File("C:\\Users\\trava\\Desktop\\data\\in");
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

void setup(){
  size(800,900);
  restore();
  if(args!=null){
     dir=new File(args[1]); 
  }
  files=dir.listFiles();
  name=dir.getName().substring(dir.getName().lastIndexOf('\\') + 1);
  for(int s=0;s<files.length;s++){
     if(files[s].isDirectory()){
       File [] partial = files[s].listFiles();
       files=joinarray(files,partial);
     }
   }
   files=seev(files);
   d = new GifDecoder();
   try{
       myWriter = new FileWriter(String.join("","C:\\Users\\trava\\Desktop\\data\\",name,".txt"),app);
    }catch (IOException e) {
       println("An error occurred.");
       e.printStackTrace();
    }
    clock = Clock.systemDefaultZone();
    time0=clock.millis();
    textSize(13);
}

void draw(){
   if(load){
     try{
      file = new FileInputStream(files[im].getAbsolutePath());
     }catch(FileNotFoundException e){}
     println(files[im].getAbsolutePath());
      d.read(file);
      fcount=d.getFrameCount();
      for(int i=0;i<fcount;i++){
         BufferedImage img = d.getFrame(i);
         if(img!=null){
           //iprint(img,"C:\\Users\\Fabio\\Desktop\\fsc_hologram\\image\\"+i+".png");
           frames=pushimg(frames,img);
         }
      }
      load=false;
   }else{
     if(fcount>0){
       background(0);
       if(safe){
         image(buf_to_img(frames[index]),0,0,800,800);
       }
       percento=(im/(float)files.length)+(index/(float)frames.length)*(1/(float)files.length);
       scale=buf_to_img(frames[index]);
       String result = "";
       String val="";
       if(scale.width>0&&scale.height>0){ 
         scale.filter(GRAY);
         scale.resize(8,8);
         if(safe){
           image(scale,0,0);
         }
         for(int j=0;j<64;j++){
           val=String.format("%h", scale.pixels[j]&0x000000ff);
           if(val.length()==1){
             result=result+"0"+val;
           }else{
             result=result+val;
           }
         }
         if(safe){
           text(files[im].getName()+" \n"+(float)files[im].length()/1048576+"Mb  "+percento*100+" % "+index+" of "+frames.length+" "+im+"of"+files.length+"\nt fine:"+time((((clock.millis()-time0+tprec)/percento)*(1-percento)))+"\n"+result,10,805,790,890);
         }else{
           text("file \n"+(float)files[im].length()/1048576+"Mb  "+percento*100+" % "+index+" of "+frames.length+" "+im+"of"+files.length+"\nt fine:"+time((((clock.millis()-time0+tprec)/percento)*(1-percento)))+"\n"+result,10,805,790,890); 
         }
         try {
           myWriter.write(result+" "+files[im].getAbsolutePath()+"\n");
         } catch (IOException e) {
           println("An error occurred.");
           e.printStackTrace();
         }
       }
       index++;
       if(index>=fcount){
          index=0;
          im++;
          save();
          load=true;
          frames=null;
          println("nextimage");
       }
     }else{
          index=0;
          im++;
          save();
          load=true;
          frames=null;
          println("nextimage");
     }
     if(im>=files.length){
       index=-1;
       im=-1;
       save();
       println("eseguito in "+time(clock.millis()-time0));
       exit();
     }
   }
}

PImage buf_to_img(BufferedImage val){
  try {
    File outputfile = new File("saved.png");
    ImageIO.write(val, "png", outputfile); 
    PImage image  = loadImage("saved.png"); 
    return image;
  } catch (IOException e) {
    println("exception reaised");
    exit();
  }
    return null;
}

static BufferedImage [] pushimg(BufferedImage [] array, BufferedImage val){
      BufferedImage [] result=null;
      if(array!=null){
        result = new BufferedImage[array.length+1];
        System.arraycopy(array,0,result,0,array.length);
        result[result.length-1]=val;
      }else{
        result = new BufferedImage[1];
        result[0]=val;
      }
      return result;
}

static File [] pushfile(File [] array, File val){
      File [] result=null;
      if(array!=null){
        result = new File[array.length+1];
        System.arraycopy(array,0,result,0,array.length);
        result[result.length-1]=val;
      }else{
        result = new File[1];
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

File [] seev(File[] in){
  File[] result=null;
  for(int i=0;i<in.length;i++){
     if(((String)in[i].getName().substring(in[i].getName().lastIndexOf('.') + 1)).equals("gif")&in[i].isFile()){
       result=pushfile(result,in[i]);
     }
  }
  return result;
}

String time(float val){
    int min = (int)val/60000;
    float sec= (val-(min*60000))/1000;
    if(min>=60){
      int hour=min/60;
      min=min-(hour*60);
      return(hour+"h"+min+"min "+sec+"s");
    }else{
      return (min+"min "+sec+"s");
   }
}

void save(){
  File out= new File("C:\\Users\\trava\\Desktop\\data\\tool\\hash_gif\\app.txt");
  FileWriter wrt=null;
  if(index!=-1&im!=-1){
    try{
      wrt= new FileWriter(out);
      wrt.write(index+"\n"+im+"\n"+(clock.millis()-time0+tprec));
      wrt.close();
    }catch(IOException e){}  
  }else{
    if (out.delete()) { 
        println("completed");
      } else {
        println("Failed to delete the file.");
      } 
  }
}

void restore(){
  File in= new File("C:\\Users\\trava\\Desktop\\data\\tool\\hash_gif\\app.txt");
  if(in.isFile()){
    BufferedReader rdt=null ;
    try{
      rdt= new BufferedReader(new FileReader(in));
      String Int_line=null;
      Int_line= rdt.readLine();
      int In_Value = Integer.parseInt(Int_line);
      index=In_Value;
      Int_line= rdt.readLine();
      In_Value = Integer.parseInt(Int_line);
      im=In_Value;
      Int_line= rdt.readLine();
      In_Value = Integer.parseInt(Int_line);
      tprec=In_Value;
      rdt.close();
      if (in.delete()) { 
        println("restored");
      } else {
        println("Failed to delete the file.");
      } 
    } catch (IOException e) {
      println("An error occurred. line read restore");
      e.printStackTrace();
    }
    app=true;
  }else{
     app=false; 
  }
}

void iprint(BufferedImage a,String out){
  File outputfile = new File(out);
  try{
    ImageIO.write(a, "png", outputfile);
  }catch(IOException e){
  }
}

void keyPressed(){
  if(key=='E'){//end
    exit();
  }else if(key=='S'){
     save();
     exit();
  }
  if(key=='V'){
     safe= !safe; 
  }
}
