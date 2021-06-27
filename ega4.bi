

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
	img=allocate(www+8)
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
						img[byten+(hh*0)]=nbyteb
						img[byten+(hh*1)]=nbyteg
						img[byten+(hh*2)]=nbyter
						img[byten+(hh*3)]=nbytebb
						nbyteb=0
						nbyteg=0
						nbyter=0
						nbytebb=0
						bitn=7
						byten=byten+1
					end if
			next
		next 
	ff=freeFile()
	open names for binary access write as ff
		put #ff,1,head1.signature,4
		put #ff,,head1.w,4
		put #ff,,head1.h,4
		put #ff,,*img,www
	close #ff
	deallocate(img)
	return 0
end function

public function loadsega(names as string)as any ptr
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
	dim p1 as any ptr
	ff=freeFile()
	open names for binary access read as #ff
		get #ff,1,head1.signature,4
		get #ff,,head1.w,4
		get #ff,,head1.h,4
	if head1.signature<>cvi("EGA4") then 
		p1=imagecreate(16,16,0)
		close #ff
		return p1
	end if
	w=head1.w
	h=head1.h
	ww=w/8
	if ww*8<>w then ww=ww+1
	p1=imagecreate(w,h,0)
	hh=ww*h
	www=(ww*h)*4
	bitn=7
	img=allocate(www+8)
	get #ff,,*img,www
	close #ff
		for y=0 to h-1
			for x= 0 to w-1
					colors=0
					nbyteb=bit(img[byten+(hh*0)],bitn)
					nbyteg=bit(img[byten+(hh*1)],bitn)
					nbyter=bit(img[byten+(hh*2)],bitn)
					nbytebb=bit(img[byten+(hh*3)],bitn)
					if nbyteb=0 then
						colors=bitreset(colors,0)
					else
						colors=bitset(colors,0)
					end if

					if nbyteg=0 then
						colors=bitreset(colors,1)
					else
						colors=bitset(colors,1)
					end if

					if nbyter=0 then
						colors=bitreset(colors,2)
					else
						colors=bitset(colors,2)
					end if

					if nbytebb=0 then
						colors=bitreset(colors,3)
					else
						colors=bitset(colors,3)
					end if
					pset p1,(x,y),colors
					bitn=bitn-1
					if bitn < 0 then
						bitn=7
						byten=byten+1
					end if
			next
		next 
	deallocate(img)
	return p1
end function



