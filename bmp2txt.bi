

public type head
	signature as integer
	w as integer
	h as integer
end type

public function getw(names as string)as integer
	dim ff as integer
	dim w as integer
	dim h as integer
	dim img as any ptr
	ff=freeFile()
	open names for binary access read as ff
		get #ff,19,w
		get #ff,23,h
	close #ff
	return w
end function

public function geth(names as string)as integer
	dim ff as integer
	dim w as integer
	dim h as integer
	dim img as any ptr
	ff=freeFile()
	open names for binary access read as ff
		get #ff,19,w
		get #ff,23,h
	close #ff
	return h
end function



public function loadBMP(names as string)as any ptr
	dim w as integer
	dim h as integer
	dim img as any ptr
	w=getw(names)
	h=geth(names)
	img = ImageCreate(w,h)
	bload names,img
	return img
end function



public function converts(names as string,src as string,p1 as any ptr)as integer
	dim sred as string
	dim sgreen as string
	dim sblue as string
	dim sbrish as string
	dim ff as integer
	dim nbytebb as integer
	dim nbyteb as integer
	dim nbyteg as integer
	dim nbyter as integer
	dim bitn as integer
	dim byten as integer
	dim brishs as integer
	dim colors as integer
	dim colorss as integer
	dim reds as integer
	dim greens as integer
	dim blues as integer
	dim x as integer
	dim y as integer
	dim w as integer
	dim ww as integer
	dim www as integer
	dim hh as integer
	dim h as integer
	dim img as byte ptr
	dim head1 as head
	w=getw(src)
	h=geth(src)
	ww=w/8
	if ww*8<>w then ww=ww+1
	hh=ww*h
	www=(ww*h)*4
	ff=freeFile()
	head1.signature=cvi("EGA4")
	head1.w=ww*8
	head1.h=h
	bitn=7
	sred="static unsigned char picure_red[] = {"+chr(13)+chr(10)
	sgreen="static unsigned char picure_green[] = {"+chr(13)+chr(10)
	sblue="static unsigned char picure_blue[] = {"+chr(13)+chr(10)
	sbrish="static unsigned char picure_brish[] = {"+chr(13)+chr(10)
		for y=0 to h-1
			for x= 0 to w-1
					colors=point(x,y,p1)
					reds=lobyte(hiword(colors))/128
					greens=hibyte(loword(colors))/128
					blues=lobyte(loword(colors))/128   
					if reds=0 and greens=0 and blues=0 then
						brishs=0
					else
						brishs=1
					end if
					
					if blues=0 then
						nbyteb=bitReset(nbyteb,bitn)
					else
						nbyteb=bitSet(nbyteb,bitn)
					end if
					
					if greens=0 then
						nbyteg=bitreset(nbyteg,bitn)
					else
						nbyteg=bitset(nbyteg,bitn)
					end if
					
					if reds=0 then
						nbyter=bitreset(nbyter,bitn)
					else
						nbyter=bitset(nbyter,bitn)
					end if
					
					if brishs=0 then
						nbytebb=bitreset(nbytebb,bitn)
					else
						nbytebb=bitset(nbytebb,bitn)
					end if
					
					bitn=bitn-1
					if bitn < 0 then
						sblue=sblue+" "+str(nbyteb)+" ,"
						sgreen=sgreen+" "+str(nbyteg)+" ,"
						sred=sred+" "+str(nbyter)+" ,"
						sbrish=sbrish+" "+str(nbytebb)+" ,"
						nbyteb=0
						nbyteg=0
						nbyter=0
						nbytebb=0
						bitn=7
						byten=byten+1
					end if
			next
						sblue=sblue+" "+chr(13)+chr(10)
						sgreen=sgreen+" "+chr(13)+chr(10)
						sred=sred+" "+chr(13)+chr(10)
						sbrish=sbrish+" "+chr(13)+chr(10)
		next 
						sblue=sblue+" 0 }"+chr(13)+chr(10)
						sgreen=sgreen+" 0 }"+chr(13)+chr(10)
						sred=sred+" 0 }"+chr(13)+chr(10)
						sbrish=sbrish+" 0 }"+chr(13)+chr(10)

	ff=freeFile()
	open names for output as ff
		put #ff,1,sblue
		put #ff,,sgreen
		put #ff,,sred
		put #ff,,sbrish
	close #ff

	return 0
end function
