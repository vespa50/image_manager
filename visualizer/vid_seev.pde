import java.io.IOException;
import java.io.FileReader;
import static java.nio.file.StandardCopyOption.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.*;
 
final String outpath="C:\\Users\\trava\\Desktop\\data\\tool\\5-result\\";
String name="";
File fs;
File fd;

void setupseed(){
  textAlign(CENTER,CENTER);
  textSize(30);
  background(0,0,0);
}

void drawseed(boolean im1, boolean im2, String name1, String name2) {
  background(0,0,255);
  text(name1+"\n"+name2,width/2,height/2);
  if (im1) {
    if(name1.charAt(name1.length()-1)==' '){
       name1=name1.substring(0,name1.length()-1); 
    }
    fs=new File(name1);
    name=name1.substring(name1.lastIndexOf('\\')+1);
    fd=new File(outpath+name);
    try {
      Path temp= Files.move(fs.toPath(), fd.toPath(), REPLACE_EXISTING);
      if (temp.toFile().exists()&!(fs.exists())) {
        background(0, 255, 0);
      } else {
        background(255, 0, 0);
        println(name1);
      }
    }
    catch (IOException e) {
      print(e);
    }


    text(name1, width/2, height/2);
  }
  if (im2) {
    if(name2.charAt(name2.length()-1)==' '){
       name2=name2.substring(0,name2.length()-1); 
    }
    fs=new File(name2);
    name=name2.substring(name2.lastIndexOf('\\')+1);
    fd=new File(outpath+name);
    try {
      Path temp = Files.move(fs.toPath(), fd.toPath(), REPLACE_EXISTING);
      if (temp.toFile().exists()&!(fs.exists())) {
        background(0, 255, 0);
      } else {
        background(255, 0, 0);
        println(name2);
      }
    }
    catch (IOException e) {
      print(e);
    }
    text(name2, width/2, height/2);
  }
}
