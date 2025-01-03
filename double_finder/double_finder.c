#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <malloc.h>
#include <string.h>
#include <inttypes.h>

#include <errno.h>
#include <windows.h>

#define hashes 47367

#define max_length 256


typedef enum {false, true} bool;

typedef struct list_elements {
    char val[129];
    struct list_elements* next;
}key;

typedef key* keys;

typedef struct list_element {
    char val[257];
    struct list_element* next;
}name;

typedef name* names;

int getntptimeofday (struct timespec *, struct timezone *);
int span(char key[]);
int tipo(char val);
void init_millis();
unsigned long int millis();
int compare(char key1[], char key2[]);
int esa(char val);
keys consk(char n[], keys L);
keys cons_tailk(char n[], keys L);
names consn(char n[], names L);
names cons_tailn(char n[], names L);
const char* orario(float val);
int absolute (int val);

//char path1[] = "/media/sf_ubuntu/in.txt";
//char path2[] = "/media/sf_ubuntu/in.txt";
//char pathout[] = "/media/sf_ubuntu/out.txt";
FILE* fp;

keys key1 = NULL;
keys key2 = NULL;
names name1 = NULL;
names name2 = NULL;
char line[130+max_length];
char hash[129];
char abspath[max_length];
int len1=0;
int len2=0;

int match = 0;
int simile = 0;
int cicli;
int run = 0;
long time0;
long time1;
struct timespec* start;
struct timespec* end;
float percento;
char s[40];

int main(int argc, char** argv) {
     if(argc!=6){
     	printf("wrong arguments number");
        return(-1);
     }

    printf("argc %d",argc);

    fp = fopen(argv[1], "r");
    if (fp == NULL)
    {
        printf("Error: could not open file %s", argv[1]);
        return -1;
    }

    fgets(line, 129 + max_length, fp);

    while (fgets(line, 129 + max_length, fp)) {
   	memset(hash,0,strlen(hash));
        for (int i = 0; i < 128; i++) {
            hash[i] = line[i];
        }
        key1=cons_tailk(hash,key1);
        memset(abspath,0,strlen(abspath));
        for (int i = 0; (line[i + 129]!='\n')&(i<256); i++) {
            abspath[i] = line[i + 129];
        }
        name1 = cons_tailn(abspath,name1);
        printf("reading 1: key:%s name:%s\n",hash,abspath);
        len1++;
    }
    fp = fopen(argv[2], "r");
    if (fp == NULL){
        printf("Error: could not open file %s", argv[2]);
        return -1;
    }

    fgets(line, 129 + max_length, fp);

    while (fgets(line, 129 + max_length, fp)) {
    	memset(hash,0,strlen(hash));
        for (int i = 0; i < 128; i++) {
            hash[i] = line[i];
        }
        key2 = cons_tailk(hash,key2);
        memset(abspath,0,strlen(abspath));
        for (int i = 0; (line[i + 129] != '\n') & (i < 256); i++) {
            abspath[i] = line[i + 129];
        }
        name2 = cons_tailn(abspath,name2);
        printf("reading2: key: %s name:%s\n", hash, abspath);
        len2++;
    }

    fp = fopen(argv[3], "w");
    if (fp == NULL){
        printf("Error: could not open file %s", argv[3]);
        return -1;
    }

    if(tipo(argv[4][0])==0){
    	cicli = (len1 * (len2 - 1)) / 2;
    }else{
    	cicli=len1*len2;
    }

    time0 = millis();
    time1=millis();    

    for (int i = 0; i < len1; i++) {
        keys k2 = key2;
        names n2 = name2;
        int j;
        if(tipo(argv[4][0])==0){
		for(int k=0;k<i+1;k++){
			//printf("j %d k %d len %d\n",i+1,k,len2);
			k2 = k2->next;
			n2 = n2->next;
        	}
        	j = i + 1;
        }else{
        	j=0;
        }
        //fprintf(fp,"%s %d\n",name1->val,span(key1->val));
        for (; j < len2; j++) {
            int comp = compare(key1->val,k2->val);
        //fprintf(fp,"key1 %s \nkey2 %s \n\n",key1->val,k2->val);
            if (comp < 100) {
                fprintf(fp, "match %d\n%s\n%s\n", comp, name1->val, n2->val);
                match++;
            }

            else if ((comp < 400)&(span(key1->val)>35)&(span(k2->val)>35)) {
                fprintf(fp,"close %d\n%s\n%s\n",comp,name1->val,n2->val);
                simile++;
            }
            
            k2 = k2->next;
            n2 = n2->next;
            run++;
            if(millis()-time1>15000){
                percento = ((float)run / (float)cicli);
                printf("%s progress: %f %s \n",argv[5],percento * 100, orario(((millis() - time0) / percento) * (1 - percento)));
                time1=millis();
            }
        }
        key1 = key1->next;
        name1 = name1->next;
    }
    printf("totale %d match %d simili %d\n",run,match,simile);
    return(0);
}

int span(char key[]){
	int min=255;
	int max=0;
	int val;
	for(int i=0;i<128;i+=2){
		val=esa(key[i]) * 16 + esa(key[i + 1]);
		if(val<min){
			min=val;
		}
		if(val>max){
			max=val;
		}
	}
	return max-min;
}



int tipo(char val){
	switch(val){
	case 'S':
		return 0;
	case 'D':
		return 1;
	default:
		return -1;
	}
}


void init_millis() {
   

   getntptimeofday(start, NULL);
};


unsigned long int millis() {
    long mtime=(1000*clock())/CLOCKS_PER_SEC;
    return mtime;
};



int compare(char key1[], char key2[]) {
    int result = 0;
    for (int i = 0; (i < 128) & (result < 450); i += 2) {
    	//fprintf(fp,"%d-%d result %d \n",(esa(key1[i]) * 16 + esa(key1[i + 1])),((esa(key2[i]) * 16 + esa(key2[i+1]))),result);
        result += absolute((esa(key1[i]) * 16 + esa(key1[i + 1])) - ((esa(key2[i]) * 16 + esa(key2[i+1]))));
    }
    return result;

}



int absolute (int val){
	if(val<0){
		return val*-1;
	}else{
		return val;
	}

}

int esa(char val) {
    switch (val) {
    case '0':
        return 0;
    case '1':
        return 1;
    case '2':
        return 2;
    case '3':
        return 3;
    case '4':
        return 4;
    case '5':
        return 5;
    case '6':
        return 6;
    case '7':
        return 7;
    case '8':
        return 8;
    case '9':
        return 9;
    case 'a':
        return 10;
    case 'b':
        return 11;
    case 'c':
        return 12;
    case 'd':
        return 13;
    case 'e':
        return 14;
    case 'f':
        return 15;
    default:
        return -1;
    }
}

keys consk(char n[], keys L) {
    keys l;
    l = malloc(sizeof(key));
    strcpy(l->val,n);
    l->val[128]='\0';
    l->next = L;
    return l;
}

keys cons_tailk(char n[], keys L) {
    if (L == NULL) {
        L = consk(n, L);
        return L;
    }else {
        keys aux = L;
        while (aux->next != NULL) {
            aux = aux->next;
        }
        aux->next = consk(n, NULL);
        return L;
    }
}



names consn(char n[], names L) {
    names l;
    l = malloc(sizeof(name));
    strcpy(l->val, n);
    l->next = L;
    return l;
}

names cons_tailn(char n[], names L) {
    if (L == NULL) {
        L = consn(n, L);
        return L;
    }else {
        names aux = L;
        while (aux->next != NULL) {
            aux = aux->next;
        }
        aux->next = consn(n, NULL);
        return L;
    }
}

const char* orario(float val) {
    int min = (int)(val / 60000);
    float sec = (val - (min * 60000)) / 1000;
    if (min >= 60) {
        int hour = min / 60;
        min = min - (hour * 60);
        sprintf(s,"%d h %d min %f s",hour,min,sec);
    }else {
        sprintf(s,"%d min %f sec",min,sec);
    }
    return s;
}