//g++ door.c  -o door -lSDL
#include <SDL/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct headerBMP{
	int w;
	int h;
};
struct pixel{
	char b;
	char g;
	char r;
	char t;
};
void *loadMapArray(char *files,struct headerBMP *hd){
	char bmid[8];
	int n;
	int nn;
	int nnn;
	int nnnn;
	int nnnnn;
	int nnnnnn;
	char c1;
	char *bm;
	char *bmbm;
	int pos;
	struct headerBMP AM;
	FILE *f1;
	char bbbb;
	bm=NULL;
	if(files!=NULL){
		f1=fopen(files,"r");
		if(f1!=NULL){
				fseek(f1,0,SEEK_SET);
				bmid[0]=0;
				bmid[1]=0;
				fread(bmid,4,1,f1);
				bmid[4]=0;
				if(strcmp(bmid,"EGA4")!=0){
					if(f1!=NULL)fclose(f1);
					return NULL;
				}
				fread(&AM,8,1,f1);
				hd->w=AM.w;
				hd->h=AM.h;
				if(AM.w>641 || AM.h>481){
					if(f1!=NULL)fclose(f1);
					return NULL;
				}
				//fseek(f1,48,SEEK_SET);
				bm=malloc((AM.w * 4)* AM.h + 20);
				if(bm==NULL){
					if(f1!=NULL)fclose(f1);
					return NULL;
				}
				pos=0;
				for(n=0;n<4;n++){
					pos=n;
					for(nn=0;nn<AM.h;nn++){
						for(nnn=0;nnn<AM.w/8;nnn++){
							fread(&c1,1,1,f1);
							nnnnn=128;
							for(nnnn=0;nnnn<8;nnnn++){
								nnnnnn=nnnnn & c1;
								if(nnnnnn==0){
									bm[pos]=(char)0;
								}else{
									bm[pos]=(char)1;
								}
								nnnnn=nnnnn>>1;
								pos=pos+4;
							}
						}
					}
				}
				fclose(f1);
				return bm;
		}
	}
	return NULL;
}
void fills(SDL_Surface *sss,struct headerBMP bm,void* bmm){
	struct lines{
		struct pixel px[bm.w];
	};
	struct BM{
		struct lines liness[bm.h];
	};
	struct BM *bmms=bmm;
	int n;
	int nn;
	char *pixels=(char *) sss->pixels;
	for(n=0;n<sss->h;n++){
		for(nn=0;nn<sss->w;nn++){
			pixels[n*sss->w+nn]=(bmms->liness[n].px[nn].b*(bmms->liness[n].px[nn].t+1))|((bmms->liness[n].px[nn].g)*(bmms->liness[n].px[nn].t+1))<<3|((bmms->liness[n].px[nn].r)*(bmms->liness[n].px[nn].t+1))<<5;

		}
	}

}

int main(int argc,char *argv[]){
	int n;
	int nn;
	struct headerBMP bm;
	SDL_Rect rrr[1]={0,0,640,480};
	char *bmm;
	SDL_Surface *sss;
	SDL_Event event;
	if(argc<2)exit(0);
	SDL_Init(SDL_INIT_VIDEO);
	atexit(SDL_Quit);
	bmm=NULL;
	bmm=loadMapArray(argv[1],&bm);
	if(bmm==NULL)exit(0); 
	if(bmm==NULL)exit(0);
	sss=SDL_SetVideoMode(bm.w,bm.h,8,0);
	SDL_FillRect(sss,&rrr[0],SDL_MapRGB(sss->format,0,0,255));
	SDL_UpdateRects(sss,1,rrr);
	fills(sss,bm,bmm);
	SDL_Flip(sss);
	SDL_WM_SetCaption("SDL...",NULL);
	while(1){
		if(SDL_PollEvent(&event)){
			if(event.type==SDL_KEYDOWN){
				if(event.key.keysym.sym==SDLK_ESCAPE)break;

			}
			else if (event.type==SDL_QUIT){
				break;
				
			}
			
		}
	}
		if(bmm!=NULL)free(bmm);
	return 0;
}
