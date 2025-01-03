import javax.swing.*;
import java.io.InputStreamReader;

File[] target=new File[0];
String[] hash_img=new String[0];
String[] hash_gif=new String[0];
String[] hash_vid=new String[0];

boolean mouseReleased=false;
int page=0;
boolean press=false;
boolean process=false;
boolean run=false;
boolean first=true;
boolean add=false;
String path;
String[] console = new String [51];

task[] queue=new task[1];
img_generate img=new img_generate();
gif_generate gif =new gif_generate();
execution ex;
Runtime rt;

String tipo="none";
String action="none";
int trg1=0;
int trg2=0;
float shift;
boolean all_target=false;

PImage trashcan;
void setup() {

  size(801, 600);
  path=sketchPath("");
  trashcan=loadImage("trash.png");
  for (int i=0; i<console.length; i++) {
    console[i]="";
  }

  File f= new File(path+"\\data\\in_data.txt");
  if (f.exists()) {
    try {
      BufferedReader br =new BufferedReader(new FileReader(f));
      String line;
      while ((line=br.readLine())!=null) {
        f=new File(line);
        target=pushfile(target, f);
      }
    }
    catch(Exception e) {
    }
    process=true;
  }

  update_hash("img");
  update_hash("GIF");
  update_hash("vid");

  queue[0]=null;
}



void draw() {
  background(#65656C);
  if (process) {
    textAlign(CENTER, CENTER);
    if (run) {
      fill(255, 0, 0);
    } else {
      fill(0, 255, 0);
    }
    rect(700, 30, 70, 20);
    fill(0);
    textSize(15);
    text("add file", 735, 40);
    if (mouseX>700&mouseX<770&mouseY>30&mouseY<70&mousePressed&mouseButton==LEFT&!press&!run) {
      process=false;
      press=true;
    } else if (press&mousePressed) {
    } else {
      press=false;
    }
    line(width/3, 80, width/3, height);
    line(0, 80, width, 80);
    noFill();
    if (!add) {
      if (queue[0]!=null) {
        for (int i=0; i<queue.length; i++) {
          if (i==0&run) {
            fill(0, 0, 255);
          } else {
            fill(255);
          }
          rect(0, 80+i*30, width/3, 30);
          fill(255, 0, 0);
          rect(width/3-30, 80+i*30, 30, 30);
          image(trashcan, width/3-27.5, 82.5+i*30, 25, 25);
          fill(0);
          textSize(15);
          textAlign(CENTER, CENTER);
          if (queue[i].type().equals("term term")) {
            text("term", width/6, 95+i*30);
          } else if (queue[i].type().equals("exit exit")) {
            text("exit", width/6, 95+i*30);
          } else {
            text(queue[i].type()+" "+queue[i].name(), width/6, 95+i*30);
          }
          if (mouseX>width/3-30&mouseX<width/3&mouseY> 80+i*30&mouseY< 110+i*30&mousePressed&mouseButton==LEFT&!press) {
            queue=canc_task(queue, i);
            press=true;
          } else if (press&mousePressed) {
          } else {
            press=false;
          }
        }
        if (queue[queue.length-1].tipo_f()==4||queue[queue.length-1].tipo_f()==5) {
          fill(255, 0, 0);
        } else {
          fill(0, 255, 0);
        }
        rect(0, 80+queue.length*30, width/3, 30);
        fill(0);
        text("+ add task", width/6, 95+queue.length*30);
        if (mouseX>0&mouseX<width/3&mouseY> 80+queue.length*30&mouseY<110+queue.length*30&mousePressed&mouseButton==LEFT&!press&!(queue[queue.length-1].tipo_f()==4||queue[queue.length-1].tipo_f()==5)) {
          add=true;
          press=true;
        } else if (press&mousePressed) {
        } else {
          press=false;
        }
      } else {
        fill(0, 255, 0);
        rect(0, 80, width/3, 30);
        fill(0);
        text("+ add task", width/6, 95);
        if (mouseX>0&mouseX<width/3&mouseY> 80&mouseY<110&mousePressed&mouseButton==LEFT&!press) {
          add=true;
          press=true;
        } else if (press&mousePressed) {
        } else {
          press=false;
        }
      }
    } else {
      textSize(15);
      if (!(action.equals("term")||action.equals("exit"))) {
        fill(255);
        if (tipo.equals("img")) {
          fill(255, 0, 0);
        }
        rect(10, 100, 83, 20);
        fill(255);
        if (tipo.equals("GIF")) {
          fill(255, 0, 0);
        }
        rect(93, 100, 83, 20);
        fill(255);
        if (tipo.equals("vid")) {
          fill(255, 0, 0);
        }
        rect(176, 100, 83, 20);

        fill(0);
        text("img", 52, 110);
        text("GIF", 135, 110);
        text("vid", 218, 110);


        fill(255);
        if (action.equals("gen")) {
          fill(255, 0, 0);
        }
        rect(10, 150, 83, 20);
        fill(255);
        if (action.equals("rig")) {
          fill(255, 0, 0);
        }
        rect(93, 150, 83, 20);
        fill(255);
        if (action.equals("comp")) {
          fill(255, 0, 0);
        }
        rect(176, 150, 83, 20);
        fill(255);

        fill(0);
        text("gen", 52, 160);
        text("rig", 135, 160);
        text("comp", 218, 160);



        fill(255);
        if (action.equals("gen")||action.equals("rig")||action.equals("comp")) {
          text("target 1 (press for path)", width/6, 300);
          rect(10, 320, 249, 20);

          if ((action.equals("comp"))) {
            text("target 2 (press for path)", width/6, 360);
            rect(10, 380, 249, 20);
          }

          if (mouseX>10&mouseX<259&mouseY> 320&mouseY<340) {
            trg1=(int)shift+trg1;
            shift=0;
          } else if (mouseX>10&mouseX<259&mouseY> 380&mouseY<400&!action.equals("gen")) {
            trg2=(int)shift+trg2;
            shift=0;
          }
          if (trg1<0) {
            trg1=0;
          } else if (trg1>=target.length&action.equals("gen")) {
            trg1=target.length-1;
          } else if (trg1>=hash_img.length&(action.equals("comp")||action.equals("rig"))&tipo.equals("img")) {
            trg1=hash_img.length-1;
          } else if (trg1>=hash_gif.length&(action.equals("comp")||action.equals("rig"))&tipo.equals("GIF")) {
            trg1=hash_gif.length-1;
          } else if (trg1>=hash_vid.length&(action.equals("comp")||action.equals("rig"))&tipo.equals("vid")) {
            trg1=hash_vid.length-1;
          }

          if (trg2<0) {
            trg2=0;
          } else if (trg2>=hash_img.length&&action.equals("comp")&&tipo.equals("img")) {
            trg2=hash_img.length-1;
          } else if (trg2>=hash_gif.length&&action.equals("comp")&&tipo.equals("GIF")) {
            trg2=hash_gif.length-1;
          } else if (trg2>=hash_vid.length&&action.equals("comp")&&tipo.equals("vid")) {
            trg2=hash_vid.length-1;
          }

          if (all_target) {
            fill(0, 255, 0);
          } else {
            fill(255);
          }
          rect(10, 420, 100, 20);
          fill(0);
          text("all", 60, 430);

          fill(0);
          if (all_target) {
            text("-", 135, 330);
            if (!action.equals("gen")) {
              text("-", 135, 390);
            }
          } else {
            if (action.equals("gen")) {
              if (target.length>0) {
                if (mousePressed&mouseX>10&mouseX<259&mouseY> 320&mouseY<340) {
                  text(target[trg1].getPath(), 135, 330);
                } else {
                  text(target[trg1].getName(), 135, 330);
                }
              } else {
                text("-", 135, 330);
                text("-", 135, 390);
              }
            } else if (action.equals("comp")) {
              if (tipo.equals("img")&hash_img.length>0) {
                text(hash_img[trg1], 135, 330);
              } else if (tipo.equals("GIF")&hash_gif.length>0) {
                text(hash_gif[trg1], 135, 330);
              } else if (tipo.equals("vid")&hash_vid.length>0) {
                text(hash_vid[trg1], 135, 330);
              }
              if (tipo.equals("img")&hash_img.length>0) {
                text(hash_img[trg2], 135, 390);
              } else if (tipo.equals("GIF")&hash_gif.length>0) {
                text(hash_gif[trg2], 135, 390);
              } else if (tipo.equals("vid")&hash_vid.length>0) {
                text(hash_vid[trg2], 135, 390);
              }
            } else if (action.equals("rig")) {
              if (tipo.equals("img")&hash_img.length>0) {
                text(hash_img[trg1], 135, 330);
              } else if (tipo.equals("GIF")&hash_gif.length>0) {
                text(hash_gif[trg1], 135, 330);
              } else if (tipo.equals("vid")&hash_vid.length>0) {
                text(hash_vid[trg1], 135, 330);
              }
            }
          }
        }
      }

      if (!action.equals("exit")) {
        if (action.equals("term")) {
          fill(255, 0, 0);
        } else {
          fill(255);
        }
        rect(10, 200, 125, 20);
        if (action.equals("term")) {
          fill(0);
        } else {
          fill(255, 0, 0);
        }
        text("shutdown", 63, 210);
      }

      if (!action.equals("term")) {
        if (action.equals("exit")) {
          fill(255, 0, 0);
        } else {
          fill(255);
        }
        rect(135, 200, 125, 20);
        if (action.equals("exit")) {
          fill(0);
        } else {
          fill(255, 0, 0);
        }
        text("exit", 188, 210);
      }
      fill(0, 255, 0);
      rect(10, 250, 249, 20);
      fill(0);
      text("clear selection", 125, 260);


      fill(255);
      rect(10, 470, 100, 20);
      rect(150, 470, 100, 20);
      fill(0);
      text("discard", 60, 480);
      text("save", 200, 480);

      /*if ((mouseX>10&mouseX<93&mouseY> 100&mouseY<120&(action.equals("comp")||action.equals("rig"))&(hash_gif.length>0))) {
       println("ok");
       } else {
       println(tipo);
       }*/
      if (mousePressed&mouseButton==LEFT&!press) {
        if ((mouseX>10&mouseX<93&mouseY> 100&mouseY<120&(action.equals("gen")||action.equals("none")))||(mouseX>10&mouseX<93&mouseY> 100&mouseY<120&(action.equals("comp")||action.equals("rig"))&(hash_img.length>0))) {
          tipo="img";
        } else if ((mouseX>93&mouseX<176&mouseY> 100&mouseY<120&(action.equals("gen")||action.equals("none")))||(mouseX>93&mouseX<176&mouseY> 100&mouseY<120&(action.equals("comp")||action.equals("rig"))&(hash_gif.length>0))) {
          tipo="GIF";
        } else if ((mouseX>176&mouseX<259&mouseY> 100&mouseY<120&(action.equals("gen")||action.equals("none")))||(mouseX>176&mouseX<259&mouseY> 100&mouseY<120&(action.equals("comp")||action.equals("rig"))&(hash_vid.length>0))) {
          tipo="vid";
        }

        if (mouseX>10&mouseX<93&mouseY> 150&mouseY<170&!(action.equals("term")||action.equals("exit"))) {
          action="gen";
        } else if (mouseX>93&mouseX<176&mouseY> 150&mouseY<170&!(action.equals("term")||action.equals("exit"))) {
          action="rig";
          tipo="none";
        } else if (mouseX>176&mouseX<259&mouseY> 150&mouseY<170&!(action.equals("term")||action.equals("exit"))) {
          action="comp";
          tipo="none";
        }

        if (mouseX>10&mouseX<125&mouseY> 200&mouseY<220) {
          action="term";
          tipo="term";
        }

        if (mouseX>125&mouseX<249&mouseY> 200&mouseY<220) {
          action="exit";
          tipo="exit";
        }

        if (mouseX>10&mouseX<259&mouseY> 250&mouseY<270) {
          action="none";
          tipo="none";
          all_target=false;
          trg1=0;
          trg2=0;
        }

        if (mouseX>10&mouseX<110&mouseY> 420&mouseY<440&!(action.equals("term")||action.equals("exit"))) {
          all_target=(!all_target);
        }


        if (mouseX>10&mouseX<110&mouseY> 470&mouseY<490) {
          action="none";
          tipo="none";
          all_target=false;
          trg1=0;
          trg2=0;
          add=false;
        }

        if (mouseX>150&mouseX<250&mouseY> 470&mouseY<490) {

          if (action.equals("none")||tipo.equals("none")) {
            action="none";
            tipo="none";
            all_target=false;
            trg1=0;
            trg2=0;
            add=false;
          } else {
            if (all_target) {
              if (action.equals("comp")) {
                if (tipo.equals("img")) {
                  for (int j=0; j<hash_img.length; j++) {
                    for (int jj=j; jj<hash_img.length; jj++) {
                      queue=addtask(queue, tipo, action, hash_img[j], hash_img[jj]);
                    }
                  }
                } else if (tipo.equals("GIF")) {
                  for (int j=0; j<hash_gif.length; j++) {
                    for (int jj=j; jj<hash_gif.length; jj++) {
                      queue=addtask(queue, tipo, action, hash_gif[j], hash_gif[jj]);
                    }
                  }
                } else if (tipo.equals("vid")) {
                  for (int j=0; j<hash_vid.length; j++) {
                    for (int jj=j; jj<hash_vid.length; jj++) {
                      queue=addtask(queue, tipo, action, hash_vid[j], hash_vid[jj]);
                    }
                  }
                }
              } else if (action.equals("gen")) {
                for (int ii=0; ii<target.length; ii++) {
                  queue=addtask(queue, tipo, action, target[ii].getAbsolutePath(), "");
                }
              } else if (action.equals("rig")) {
                if (tipo.equals("img")) {
                  for (int ii=0; ii<hash_img.length; ii++) {
                    queue=addtask(queue, tipo, action, hash_img[ii], "");
                  }
                } else if (tipo.equals("GIF")) {
                  for (int ii=0; ii<hash_gif.length; ii++) {
                    queue=addtask(queue, tipo, action, hash_gif[ii], "");
                  }
                } else if (tipo.equals("vid")) {
                  for (int ii=0; ii<hash_vid.length; ii++) {
                    queue=addtask(queue, tipo, action, hash_vid[ii], "");
                  }
                }
              }
            } else {
              if (action.equals("comp")) {
                if (tipo.equals("img")) {
                  queue=addtask(queue, tipo, action, hash_img[trg1], hash_img[trg2]);
                } else if (tipo.equals("GIF")) {
                  queue=addtask(queue, tipo, action, hash_gif[trg1], hash_gif[trg2]);
                } else if (tipo.equals("vid")) {
                  queue=addtask(queue, tipo, action, hash_vid[trg1], hash_vid[trg2]);
                }
              } else if (action.equals("rig")) {
                if (tipo.equals("img")) {
                  queue=addtask(queue, tipo, action, hash_img[trg1], "");
                } else if (tipo.equals("GIF")) {
                  queue=addtask(queue, tipo, action, hash_gif[trg1], "");
                } else if (tipo.equals("vid")) {
                  queue=addtask(queue, tipo, action, hash_vid[trg1], "");
                }
              } else if (action.equals("gen")) {
                queue=addtask(queue, tipo, action, target[trg1].getAbsolutePath(), "");
              } else if ((action.equals("term")||action.equals("exit"))) {
                queue=addtask(queue, tipo, action, "", "");
              }
            }
            action="none";
            tipo="none";
            all_target=false;
            trg1=0;
            trg2=0;
            add=false;
          }


          //add to queue
        }
        press=true;
      } else if (press&mousePressed) {
      } else {
        press=false;
      }
    }

    if (!run&queue[0]==null) {
      fill(255, 0, 0);
    } else if (!run) {
      fill(0, 255, 0);
    } else {
      fill(0, 0, 255);
    }
    rect(30, 30, 50, 20);
    fill(0);
    text("run", 55, 40);
    if (mouseX>30&mouseX<80&mouseY>30&mouseY<50&mousePressed&mouseButton==LEFT&!press) {
      if (run) {
        img=null;
        gif=null;
        if (ex!=null) {
          ex.kill();
        }
      }
      run=!run;
      press=true;
    } else if (press&mousePressed) {
    } else {
      press=false;
    }
    if (run&queue[0]!=null) {
      if (queue[0].tipo_f()==0&queue[0].tipo_a()==0) {//gen img
        if (first) {
          img=new img_generate(new File(queue[0].tg1()));
          run=img.setup_img_gen();
          first=false;
        } else {

          translate(width/3, 80);
          //533.33-
          scale(0.666);
          if (img.draw_img_gen()) {
            update_hash("img");
            next();
            img=null;
            first=true;
          }
          scale(1.5);
          translate(-width/3, -80);
        }
      } else if (queue[0].tipo_f()==0&queue[0].tipo_a()==1) {//rig img
      } else if (queue[0].tipo_f()==0&queue[0].tipo_a()==2) {//comp img
        if (first) {
          ex = runFinder(path+"var\\hash\\"+queue[0].tg1()+".txt", path+"var\\hash\\"+queue[0].tg2()+".txt", queue[0].name());
          first=false;
        } else {
          try {
            String line;
            if ((line=(ex.getOut().readLine()))!=null) {
              for (int i=0; i<console.length-1; i++) {
                console[i+1]=console[i];
              }
              console[0]=line+"\n";
            } else if (!ex.alive()) {
              next();
              first=true;
            }
          }
          catch(IOException e) {
            e.printStackTrace();
          }
          textSize(10);
          textAlign(LEFT, TOP);
          String s="";
          for (int j=0; j<console.length; j++) {
            s+=console[j];
            //text(console[j], width/3+15, 90+j*10,518,510);
          }
          text(s, width/3+15, 90, 518, 510);
        }
      } else if (queue[0].tipo_f()==0&queue[0].tipo_a()==3) {//show img
      } else if (queue[0].tipo_f()==1&queue[0].tipo_a()==0) {//gen gif
        if (first) {
          gif=new gif_generate();
          run=gif.setup_gif_gen(new File(queue[0].tg1()));
          first=false;
        } else {
          translate(width/3, 80);
          //533.33-
          scale(0.666);
          if (gif.draw_gif_gen()) {
            gif=null;
            update_hash("GIF");
            next();
            first=true;
          }
          scale(1.5);
          translate(-width/3, -80);
        }
      } else if (queue[0].tipo_f()==1&queue[0].tipo_a()==1) {//rig gif
      } else if (queue[0].tipo_f()==1&queue[0].tipo_a()==2) {//com gif
        if (first) {
          ex = runFinderGif(path+"var\\hash_gif\\"+queue[0].tg1()+".txt", path+"var\\hash_gif\\"+queue[0].tg2()+".txt", queue[0].name());
          first=false;
        } else {
          try {
            String line;
            if ((line=(ex.getOut().readLine()))!=null) {
              for (int i=0; i<console.length-1; i++) {
                console[i+1]=console[i];
              }
              console[0]=line+"\n";
            } else if (!ex.alive()) {
              next();
              first=true;
            }
          }
          catch(IOException e) {
            e.printStackTrace();
          }
          textSize(10);
          textAlign(LEFT, TOP);
          String s="";
          for (int j=0; j<console.length; j++) {
            s+=console[j];
            //text(console[j], width/3+15, 90+j*10,518,510);
          }
          text(s, width/3+15, 90, 518, 510);
        }
      } else if (queue[0].tipo_f()==1&queue[0].tipo_a()==3) {//show gif
      } else if (queue[0].tipo_f()==2&queue[0].tipo_a()==0) {//gen vid
        if (first) {
          ex = runGenerateVid(queue[0].tg1());
          first=false;
        } else {
          try {
            String line="";
            if ((line=(ex.getOut().readLine()))!=null&&!console[0].equals(line)) {
              for (int i=0; i<console.length-1; i++) {
                console[i+1]=console[i];
              }
              console[0]=line+"\n";
            } else if (!ex.alive()) {
              next();
              first=true;
            }
          }
          catch(IOException e) {
            e.printStackTrace();
          }
          textSize(10);
          textAlign(LEFT, TOP);
          String s="";
          for (int j=0; j<console.length; j++) {
            s+=console[j];
            //text(console[j], width/3+15, 90+j*10,518,510);
          }
          text(s, width/3+15, 90, 518, 510);
        }
      } else if (queue[0].tipo_f()==2&queue[0].tipo_a()==1) {//rig vid
      } else if (queue[0].tipo_f()==2&queue[0].tipo_a()==2) {//comp vid
        if (first) {
          ex = runFinderVid(path+"var\\hash_vid\\"+queue[0].tg1()+".txt", path+"var\\hash_vid\\"+queue[0].tg2()+".txt", queue[0].name());
          first=false;
        } else {
          try {
            String line="";
            if ((line=(ex.getOut().readLine()))!=null) {
              for (int i=0; i<console.length-1; i++) {
                console[i+1]=console[i];
              }
              console[0]=line+"\n";
            } else if (!ex.alive()) {
              next();
              first=true;
            }
          }
          catch(IOException e) {
            e.printStackTrace();
          }
          textSize(10);
          textAlign(LEFT, TOP);
          String s="";
          for (int j=0; j<console.length; j++) {
            s+=console[j];
            //text(console[j], width/3+15, 90+j*10,518,510);
          }
          text(s, width/3+15, 90, 518, 510);
        }
      } else if (queue[0].tipo_f()==2&queue[0].tipo_a()==3) {//show vid
      } else if (queue[0].tipo_a()==4) {//term
        turnoff();
      } else if (queue[0].tipo_a()==5) {//term
        exit();
      } else {
        println("error invalid type"+queue[0].tipo_a()+" "+queue[0].tipo_f());
      }


      if (queue[0]==null) {
        run=false;
      }
    } else {
      run=false;
    }
  } else {
    stroke(0);
    fill(#9F9EA5);
    rect(30, 70, 740, 500);
    fill(0, 255, 0);
    rect(30, 30, 50, 20);
    fill(0);
    textAlign(CENTER, CENTER);
    text("add", 55, 40);
    if (mouseX>30&mouseX<80&mouseY>30&mouseY<70&mousePressed&mouseButton==LEFT&!press) {
      target=removedouble(addfile(target));
      press=true;
    } else if (press&mousePressed) {
    } else {
      press=false;
    }
    fill(255);
    textSize(20);
    text("select the directory to process", 400, 40);
    textSize(15);
    if (target.length>0) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(700, 30, 70, 20);
    fill(0);
    text("process", 735, 40);
    if (mouseX>700&mouseX<770&mouseY>30&mouseY<70&mousePressed&mouseButton==LEFT&!press&target.length>0) {
      process=true;
      press=true;
      try {
        FileWriter wr = new FileWriter(new File(path+"\\data\\in_data.txt"));
        for (int i=0; i<target.length; i++) {
          wr.write(target[i].getAbsolutePath()+"\n");
        }
        wr.close();
      }
      catch(IOException e) {
        e.printStackTrace();
      }
    } else if (press&mousePressed&mouseButton==LEFT) {
    } else {
      press=false;
    }
    for (int i=page*10; i<target.length&i<(page+1)*10; i++) {
      fill(#D1EDFF);
      rect(30, 70+i%10*50, 740, 50);
      fill(255, 0, 0);
      rect(720, 70+i%10*50, 50, 50);
      image(trashcan, 725, 75+i%10*50, 40, 40);
      fill(0);
      text(target[i].getAbsolutePath(), 375, 95+i%10*50);

      if (mouseX>720&mouseX<770&mouseY>70+(i%10)*50&mouseY<120+(i%10)*50&mousePressed&mouseButton==LEFT&!press) {
        target=canc(target, i);
        press=true;
      } else if (press&mousePressed&mouseButton==LEFT) {
      } else {
        press=false;
      }
    }
    if ((target.length-1)/10>0) {
      fill(0, 255, 0);
      noStroke();
      rect(10, 170, 10, 60);
      rect(780, 170, 10, 60);
      stroke(0);
      line(20, 170, 10, 200);
      line(10, 200, 20, 230);
      line(780, 170, 790, 200);
      line(790, 200, 780, 230);
      fill(255);
      text(page+"/"+(target.length-1)/10, 400, 585);
      if (mouseX>10&mouseX<20&mouseY>170&mouseY<230&mousePressed&mouseButton==LEFT&!press) {
        if (page>0) {
          page--;
        }
        press=true;
      } else if (press&mousePressed&mouseButton==LEFT) {
      } else {
        press=false;
      }

      if (mouseX>780&mouseX<790&mouseY>170&mouseY<230&mousePressed&mouseButton==LEFT&!press) {
        if (page<((target.length-1)/10)) {
          page++;
        }
        press=true;
      } else if (press&mousePressed&mouseButton==LEFT) {
      } else {
        press=false;
      }
    }
    if (page>(target.length-1)/10) {
      page--;
    }
  }
  if (mousePressed&mouseButton==RIGHT) {
    img.fsafe();
    gif.fsafe();
  }
}

void update_hash(String tipo) {
  if (tipo.equals("img")) {
    File f = new File(path+"\\var\\hash");
    File[] list= f.listFiles();
    hash_img=new String[list.length];
    for (int i=0; i<list.length; i++) {
      hash_img[i]=list[i].getAbsolutePath().substring(list[i].getAbsolutePath().lastIndexOf('\\')+1, list[i].getAbsolutePath().lastIndexOf('.'));
    }
  } else if (tipo.equals("GIF")) {
    File f = new File(path+"\\var\\hash_gif");
    File[] list= f.listFiles();
    hash_gif=new String[list.length];
    for (int i=0; i<list.length; i++) {
      hash_gif[i]=list[i].getAbsolutePath().substring(list[i].getAbsolutePath().lastIndexOf('\\')+1, list[i].getAbsolutePath().lastIndexOf('.'));
    }
  } else if (tipo.equals("vid")) {
    File f = new File(path+"\\var\\hash_vid");
    File[] list= f.listFiles();
    hash_vid=new String[list.length];
    for (int i=0; i<list.length; i++) {
      hash_vid[i]=list[i].getAbsolutePath().substring(list[i].getAbsolutePath().lastIndexOf('\\')+1, list[i].getAbsolutePath().lastIndexOf('.'));
    }
  }
}

void next() {
  queue=canc_task(queue, 0);
}

File[] canc(File[] in, int index) {
  File[] result=new File[in.length-1];
  for (int i=0; i<in.length-1; i++) {
    if (i<index) {
      result[i]=in[i];
    } else {
      result[i]=in[i+1];
    }
  }
  return result;
}

task[] canc_task(task[] in, int index) {
  task[] result;
  if (in.length==1) {
    result=new task[1];
    result[0]=null;
  } else {
    result=new task[in.length-1];
    for (int i=0; i<in.length-1; i++) {
      if (i<index) {
        result[i]=in[i];
      } else {
        result[i]=in[i+1];
      }
    }
  }
  return result;
}

task[] addtask(task[]in, String tipo, String action, String trg1, String trg2) {
  task[] result;
  if (in[0]==null) {
    result = new task[1];
    result[0]=new task(tipo, action, trg1, trg2);
  } else {
    result = new task[in.length+1];
    for (int i=0; i<in.length; i++) {
      result[i]=in[i];
    }
    result[result.length-1]=new task(tipo, action, trg1, trg2);
  }
  return result;
}

File[] removedouble(File[] in) {
  File[] out=new File[0];
  for (int i=0; i<in.length; i++) {
    boolean find=false;
    for (int ii=0; ii<out.length&!find; ii++) {
      if (in[i].equals(out[ii])) {
        find=true;
      }
    }
    if (!find) {
      out=pushfile(out, in[i]);
    }
  }
  return out;
}

File[] addfile(File[] in) {
  JFileChooser f = new JFileChooser();
  f.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
  f.setMultiSelectionEnabled(true);
  f.setSelectedFiles(in);
  f.showOpenDialog(null);
  return pushfiles(in, f.getSelectedFiles());
}

void turnoff() {
  launch(path+"app\\term.bat");
}



class task {
  private int genere;
  private int activity;
  private String type;
  private String target1;
  private String target2;

  task() {
    genere=-1;
    activity=-1;
  }

  task(String gen, String action, String trg1, String trg2) {
    type=gen+" "+action;
    if (gen.equals("term")||action.equals("term")) {
      genere=4;
      activity=4;
    } else if (gen.equals("exit")) {
      genere=5;
      activity=5;
    } else {
      if (gen.equals("img")) {
        genere=0;
      } else if (gen.equals("GIF")) {
        genere=1;
      } else if (gen.equals("vid")) {
        genere=2;
      } else {
        genere=-1;
      }

      if (action.equals("gen")) {
        activity=0;
      } else if (action.equals("rig")) {
        activity=1;
      } else if (action.equals("comp")) {
        activity=2;
      } else if (action.equals("term")) {
        activity=3;
      } else {
        activity=-1;
      }
    }

    target1=trg1;
    target2=trg2;
  }

  public int tipo_f() {
    return genere;
  }

  public int tipo_a() {
    return activity;
  }

  public String tg1() {
    return target1;
  }

  public String tg2() {
    return target2;
  }

  public String name() {
    if (target1==null||target2==null) {
      return "";
    } else if (target2.equals("")) {
      return (String)target1.substring(target1.lastIndexOf('\\')+1);
    } else if (target1.lastIndexOf('.')==-1&&target2.lastIndexOf('.')==-1) {
      return (String)target1.substring(target1.lastIndexOf('\\')+1)+"_"+target2.substring(target2.lastIndexOf('\\')+1);
    } else if (target1.lastIndexOf('.')!=-1&&target2.lastIndexOf('.')!=-1) {
      return (String)target1.substring(target1.lastIndexOf('\\')+1, target1.lastIndexOf('.'))+"_"+target2.substring(target2.lastIndexOf('\\')+1, target2.lastIndexOf('.'));
    }
    return null;
  }

  public String type() {
    return type;
  }
}

class execution {
  private BufferedReader out;
  private Process id;
  execution() {
    out=null;
    id=null;
  }
  execution(BufferedReader a, Process b) {
    out=a;
    id=b;
  }
  public void setOut(BufferedReader a) {
    out=a;
  }
  public void setPro(Process a) {
    id=a;
  }
  public BufferedReader getOut() {
    return out;
  }
  public Process getPro() {
    return id;
  }
  public boolean alive () {
    return id.isAlive();
  }
  public void kill() {
    id.destroy();
  }
}

execution runFinderGif(String f1, String f2, String name) {
  rt = Runtime.getRuntime();
  char type;
  if (f1.equals(f2)) {
    type='S';
  } else {
    type='D';
  }

  File f= new File(path+"cmp");
  if (!f.exists()) {
    f.mkdir();
  }
  String[] commands = {path+"app\\double_finder_gif.exe", f1, f2, path+"cmp\\gif_"+name+".txt", type+"", name};
  BufferedReader stdInput=null;
  Process son=null;
  try {
    son = rt.exec(commands);
    stdInput = new BufferedReader(new InputStreamReader(son.getInputStream()));
    /*BufferedReader stdError = new BufferedReader(new InputStreamReader(son.getErrorStream()));
     String s=null;
     while ((s = stdError.readLine()) != null) {
     System.out.println(s);
     }*/
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  execution out = new execution(stdInput, son);
  return out;
}

execution runFinderVid(String f1, String f2, String name) {
  rt = Runtime.getRuntime();
  char type;
  if (f1.equals(f2)) {
    type='S';
  } else {
    type='D';
  }

  File f= new File(path+"cmp");
  if (!f.exists()) {
    f.mkdir();
  }
  String[] commands = {path+"app\\double_finder_vid.exe", f1, f2, path+"cmp\\vid_"+name+".txt", type+"", name};
  BufferedReader stdInput=null;
  Process son=null;
  try {
    son = rt.exec(commands);
    stdInput = new BufferedReader(new InputStreamReader(son.getInputStream()));
    /*BufferedReader stdError = new BufferedReader(new InputStreamReader(son.getErrorStream()));
     String s=null;
     while ((s = stdError.readLine()) != null) {
     System.out.println(s);
     }*/
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  execution out = new execution(stdInput, son);
  return out;
}

execution runFinder(String f1, String f2, String name) {
  rt = Runtime.getRuntime();
  char type;
  if (f1.equals(f2)) {
    type='S';
  } else {
    type='D';
  }
  File f= new File(path+"cmp");
  if (!f.exists()) {
    f.mkdir();
  }
  String[] commands = {path+"app\\double_finder.exe", f1, f2, path+"cmp\\img_"+name+".txt", type+"", name};
  BufferedReader stdInput=null;
  Process son=null;
  try {
    son = rt.exec(commands);
    stdInput = new BufferedReader(new InputStreamReader(son.getInputStream()));
    /*BufferedReader stdError = new BufferedReader(new InputStreamReader(son.getErrorStream()));
     String s=null;
     while ((s = stdError.readLine()) != null) {
     System.out.println("err"+s);
     }*/
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  execution out = new execution(stdInput, son);
  return out;
}

execution runGenerateVid(String name) {

  /*
  File f= new File(path+"var");
   if (!f.exists()) {
   f.mkdir();
   }
   f= new File(path+"var\\hash_vid");
   if (!f.exists()) {
   f.mkdir();
   }
   println(path+"app\\hash_video.jar");
   String[] commands = {"java","--enable-preview","-jar",path+"app\\hash_video.jar", name ,path+"var\\hash_vid"+name.substring(name.lastIndexOf('\\'))+".txt"};
   for(int i=0;i<commands.length;i++){
   println(commands[i]);
   }
   BufferedReader stdInput=null;
   Process son=null;
   try {
   son =Runtime.getRuntime().exec(commands);
   stdInput = new BufferedReader(new InputStreamReader(son.getInputStream()));
   BufferedReader stdError = new BufferedReader(new InputStreamReader(son.getErrorStream()));
   String s=null;
   while ((s = stdError.readLine()) != null) {
   System.out.println("err"+s);
   }
   }
   catch(IOException e) {
   e.printStackTrace();
   }*/
  Process son = null;
  BufferedReader stdInput=null;
  File f= new File(path+"var");
  if (!f.exists()) {
    f.mkdir();
  }
  f= new File(path+"var\\hash_vid");
  if (!f.exists()) {
    f.mkdir();
  }

  try {
    f = new File(path+"app\\esec.bat");
    FileWriter wr = new FileWriter(f);
    wr.write("java --enable-preview -jar "+path+"app\\hash_video.jar"+" "+name+" "+path+"var\\hash_vid"+name.substring(name.lastIndexOf('\\'))+".txt 10");
    wr.close();
    son=launch(f.getAbsolutePath());
    stdInput = new BufferedReader(new InputStreamReader(son.getInputStream()));
    //BufferedReader stdError = new BufferedReader(new InputStreamReader(son.getErrorStream()));
    //String s=null;
    /*while ((s = stdError.readLine()) != null) {
     System.out.println("err"+s);
     }*/
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  execution out = new execution(stdInput, son);
  return out;
}

void time (int t, boolean app) {
  File f=new File(path+"time.txt");
  PrintWriter output=createWriter(f);
  if (app&f.exists()) {
    output.append("\n durata: "+orario((float)t));
  } else {
    output.println("durata: "+orario((float)t));
  }
  output.flush();
  output.close();
}

void time (int t, boolean app, String s) {
  File f=new File(path+"time.txt");
  PrintWriter output=createWriter(f);
  if (app&f.exists()) {
    output.append("\n"+s+" durata: "+orario((float)t));
  } else {
    output.println(s+"durata: "+orario((float)t));
  }
  output.flush();
  output.close();
}


String orario(float val)
{
  String s;
  int min = (int)(val / 60000);
  float sec = (val - (min * 60000)) / 1000;
  if (min>=1440) {
    int day=min/1440;
    int hour = (min-day*1440) / 60;
    min = min - (hour * 60)-(day*1440);
    s=day+" d "+hour+" h "+min+" min "+sec+" s";
  } else if (min >= 60&min<1440)
  {
    int hour = min / 60;
    min = min - (hour * 60);
    s=hour+" h "+min+" min "+sec+" s";
  } else
  {
    s=min+" min "+sec+" s";
  }
  return s;
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

static File[] pushfiles(File[] array1, File[] array2) {
  if (array1==null&array2!=null) {
    return array2;
  } else if (array2==null) {
    return array1;
  } else {
    File[] result =new File [array1.length + array2.length];
    System.arraycopy(array1, 0, result, 0, array1.length);
    System.arraycopy(array2, 0, result, array1.length, array2.length);
    return result;
  }
}

void keyPressed() {
  if (queue[0]!=null) {
    if (key=='S') {
      if (queue[0].tipo_f()==0) {
        img.safe();
      } else if (queue[0].tipo_f()==1) {
        gif.safe();
      }
    }
    if (key=='P'&queue[0].tipo_f()==0) {
      img.prev();
    }
    if (key=='Q'&queue[0].tipo_f()==0) {
      img.square();
    }
    if (key=='H'&queue[0].tipo_f()==0) {
      img.hide();
    }
    if (key=='E') {
      if (queue[0].tipo_f()==0) {
        img.extend();
      } else if (queue[0].tipo_f()==1) {
        gif.extend();
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  shift = event.getCount();
}
