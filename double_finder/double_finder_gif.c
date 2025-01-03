#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <malloc.h>
#include <string.h>
#include <inttypes.h>

#define max_length 256
#define mat 100
#define sim 400

typedef enum
{
    false,
    true
} bool;

typedef struct list_elements
{
    char val[129];
    struct list_elements *next;
} frame;

typedef frame *frames;

typedef struct list_element
{
    char val[257];
    int dim;
    struct list_element *next;
    frames first;
} name;

typedef name *names;

int getntptimeofday(struct timespec *, struct timezone *);
int span(char key[]);
int tipo(char val);
void init_millis();
unsigned long int millis();
int compare(char key1[], char key2[]);
int esa(char val);
names head(char n[], char h[]);
frames branch(char h[], frames f);
names cons_tail(char n[], char h[], names L, int *dim);
const char *orario(float val);
int absolute(int val);
void printleaf(frames f, FILE *fp);
void printtree(names n, FILE *fp);

FILE *fp;

names name1;
names name2;
char line[130 + max_length];
char hash[129];
char abspath[max_length];
int len1 = 0;
int len2 = 0;

int match = 0;
int simile = 0;
int cicli;
int run = 0;
long int time0 = 0;
long int last = 0;
float percento;
char s[40];

int main(int argc, char **argv)
{

    if (argc != 6)
    {
        printf("wrong arguments number");
        return 0;
    }

    fp = fopen(argv[1], "r");
    if (fp == NULL)
    {
        printf("Error: could not open file %s", argv[1]);
        return -1;
    }
    fgets(line, 129 + max_length, fp);
    while (fgets(line, 129 + max_length, fp))
    {
        memset(hash, 0, sizeof(hash) / sizeof(hash[0]));
        for (int i = 0; i < 128; i++)
        {
            hash[i] = line[i];
        }
        memset(abspath, 0, sizeof(abspath) / sizeof(abspath[0]));
        for (int i = 0; (line[i + 129] != '\n') & (i < 256); i++)
        {
            abspath[i] = line[i + 129];
        }
        name1 = cons_tail(abspath, hash, name1, &len1);
        printf("reading 1: key:%s name:%s\n", hash, abspath);
    }
    fp = fopen(argv[2], "r");
    if (fp == NULL)
    {
        printf("Error: could not open file %s", argv[2]);
        return -1;
    }
    fgets(line, 129 + max_length, fp);
    while (fgets(line, 129 + max_length, fp))
    {
        memset(hash, 0, strlen(hash));
        for (int i = 0; i < 128; i++)
        {
            hash[i] = line[i];
        }
        memset(abspath, 0, strlen(abspath));
        for (int i = 0; (line[i + 129] != '\n') & (i < 256); i++)
        {
            abspath[i] = line[i + 129];
        }
        name2 = cons_tail(abspath, hash, name2, &len2);
        printf("reading2: key: %s name:%s\n", hash, abspath);
    }

    fp = fopen(argv[3], "w");
    if (fp == NULL)
    {
        printf("Error: could not open file %s", argv[3]);
        return -1;
    }
    // printtree(name2,fp);

    if (tipo(argv[4][0]) == 0)
    {
        cicli = (len1 * (len2 - 1)) / 2;
    }
    else
    {
        cicli = len1 * len2;
    }

    time0 = millis();

    for (int i = 0; i < len1; i++)
    {
        names n2 = name2;
        int j;

        if (tipo(argv[4][0]) == 0)
        {
            for (int k = 0; k < i + 1; k++)
            {
                //printf("j %d k %d len %d\n",i+1,k,len2);
                n2 = n2->next;
            }
            j = i + 1;
        }
        else
        {
            j = 0;
        }

        for (; j < len2; j++)
        {
            //printf("i:%d j%d a %s b %s\n",i,j,name1->val,n2->val);
            frames img1;
            frames img2;
            bool out = false;
            // printf("\ni%d j%d %s %s dim1 %d < dim2 %d\n",i,j,name1->val,n2->val,name1->dim,n2->dim);
            if (name1->dim < n2->dim)
            {
               // printf("name1->dim < n2->dim\n");
                frames ref = n2->first;
                // fprintf(fp,"name1 dim %d name2 dim %d\n",name1->dim,n2->dim);
                for (int im2 = 0; (im2 < (n2->dim) - (name1->dim)+1) & !out; im2++)
                {
                    int comp = 0;
                    int ncomp = 0;
                    img2 = ref;
                    img1 = name1->first;
                    bool skip=false;
                    for (int im1 = 0; (im1 < (name1->dim))&!skip; im1++)
                    {
                        /*if(img1->val==NULL){
                            fprintf(fp,"null img1 %s im2 %d\n",name1->val,im2);

                        }
                        if(img2->val==NULL){
                            fprintf(fp,"null img2 %s im2 %d\n",n2->val,im2);

                        }*/
                        //fprintf(fp,"%s %s\n%s %s\n%d\n",img1->val,name1->val,img2->val,n2->val,compare(img1->val, img2->val));
                        comp += compare(img1->val, img2->val);
                        ncomp++;
                        img1 = img1->next;
                        img2 = img2->next;
                        skip = (comp / name1->dim > sim+60);
                    }
                    comp = comp / ncomp;
                    if (comp < mat)
                    {
                        fprintf(fp, "match %d\n%s \n%s \n", comp, name1->val, n2->val);
                        match++;
                        out = true;
                    }
                    else if (comp < sim)
                    {
                        fprintf(fp, "close %d\n%s\n%s\n", comp, name1->val, n2->val);
                        simile++; 
                        out = true;
                    }
                    ref = ref->next;
                }
            }
            else
            {
                //printf("name1->dim > n2->dim\n");
                frames ref = name1->first;
                // fprintf(fp,"err name1 dim %d name2 dim %d\n",name1->dim,n2->dim);
                for (int im1 = 0; (im1 < (name1->dim) - (n2->dim)+1) & !out; im1++)
                {
                    int comp = 0;
                    int ncomp = 0;
                    img1 = ref;
                    img2 = n2->first;
                    /*if(img1->val==NULL){
                        fprintf(fp,"null img1 %s im1 %d\n",name1->val,im1);

                    }
                    if(img2->val==NULL){
                        fprintf(fp,"null img2 %s im1 %d\n",n2->val,im1);

                    }*/
                    bool skip=false;
                    for (int im2 = 0; (im2 < (n2->dim)) & !skip; im2++)
                    {
                        //fprintf(fp,"%s %s\n%s %s\n%d\n",img1->val,name1->val,img2->val,n2->val,compare(img1->val, img2->val));
                        comp += compare(img1->val, img2->val);
                        ncomp++;
                        img1 = img1->next;
                        img2 = img2->next;
                        skip = (comp / n2->dim > sim+60);
                        
                    }

                    comp = comp / ncomp;
                    if (comp < mat)
                    {
                        fprintf(fp, "match %d\n%s\n%s \n", comp, name1->val, n2->val);
                        match++;
                        out = true;
                    }
                    else if (comp < sim)
                    {
                        fprintf(fp, "close %d\n%s\n%s\n", comp, name1->val, n2->val);
                        simile++;
                        out = true;
                    }

                    
                    
                    ref = ref->next;
                }
            }

            // img1 >> img2

            n2 = n2->next;
            run++;
            if (millis() - last > 1000)
            {
                percento = ((float)run / (float)cicli);
                printf("%s progress: %f %s \n", argv[5], percento * 100, orario(((millis() - time0) / percento) * (1 - percento)));
                last = millis();
            }
        }
        name1 = name1->next;
    }
    printf("totale %d match %d simili %d\n", run, match, simile);
}

void printtree(names n, FILE *fp)
{
    if (n->next == NULL)
    {
        return;
    }
    else
    {
        if (fp != NULL)
        {
            fprintf(fp, "%sdim %d\n ", n->val, n->dim);
        }
        else
        {
            printf("%sdim %d\n ", n->val, n->dim);
        }
        printleaf(n->first, fp);
        printtree(n->next, fp);
    }
}

void printleaf(frames f, FILE *fp)
{
    if (f->next == NULL)
    {
        return;
    }
    else
    {
        if (fp != NULL)
        {
            if (f->val != NULL)
            {
                fprintf(fp, "->%s\n", f->val);
            }
            else
            {
                fprintf(fp, "->NULL\n");
            }
        }
        else
        {
            if (f->val != NULL)
            {
                printf("->%s\n", f->val);
            }
            else
            {
                printf("->NULL\n");
            }
        }
        printleaf(f->next, fp);
    }
}

int span(char key[])
{
    int min = 255;
    int max = 0;
    int val;
    for (int i = 0; i < 128; i += 2)
    {
        val = esa(key[i]) * 16 + esa(key[i + 1]);
        if (val < min)
        {
            min = val;
        }
        if (val > max)
        {
            max = val;
        }
    }
    return max - min;
}

int tipo(char val)
{
    switch (val)
    {
    case 'S':
        return 0;
    case 'D':
        return 1;
    default:
        return -1;
    }
}

unsigned long int millis()
{
    long int mil = 0;

    mil = (clock() * 1000) / CLOCKS_PER_SEC;

    return mil;
}

int compare(char key1[], char key2[])
{
    int result = 0;
    for (int i = 0; (i < 128) & (result < sim+60); i += 2)
    {
        // fprintf(fp,"%d-%d result %d \n",(esa(key1[i]) * 16 + esa(key1[i + 1])),((esa(key2[i]) * 16 + esa(key2[i+1]))),result);
        result += absolute((esa(key1[i]) * 16 + esa(key1[i + 1])) - ((esa(key2[i]) * 16 + esa(key2[i + 1]))));
    }
    return result;
}

int absolute(int val)
{
    if (val < 0)
    {
        return val * -1;
    }
    else
    {
        return val;
    }
}

int esa(char val)
{
    switch (val)
    {
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

names cons_tail(char n[], char h[], names L, int *dim)
{
    names aux = L;

    if (aux == NULL)
    {
        aux = head(n, h);
        (*dim)++;
    }
    else if (strcmp((aux->val), n) == 0)
    {
        aux->first = branch(h, aux->first);
        aux->dim++;
    }
    else
    {
        aux->next = cons_tail(n, h, aux->next, dim);
    }
    return aux;
}

names head(char n[], char h[])
{
    names l = calloc(1, sizeof(name));
    strcpy(l->val, n);
    l->next = NULL;
    l->first = NULL;
    l->first = branch(h, l->first);
    l->dim = 1;
    return l;
}

frames branch(char h[], frames f)
{
    if (f == NULL)
    {
        frames fr = calloc(1, sizeof(frame));
        strcpy(fr->val, h);
        fr->next = NULL;
        return fr;
    }
    else
    {
        frames fr = f;
        fr->next = branch(h, fr->next);
        return fr;
    }
}

const char *orario(float val)
{
    int min = (int)(val / 60000);
    float sec = (val - (min * 60000)) / 1000;
    if (min >= 60)
    {
        int hour = min / 60;
        min = min - (hour * 60);
        sprintf(s, "%d h %d min %f s", hour, min, sec);
    }
    else
    {
        sprintf(s, "%d min %f sec", min, sec);
    }
    return s;
}