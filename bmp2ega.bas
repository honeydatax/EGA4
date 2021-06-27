#include once "ega4.bi"

dim p1 as any ptr
screenRes 320,200,32
p1=loadBMP(command(1))
line (0,0)-(640,480),rgb(255,64,255),bf
put (0,0),p1,pset
converts (command(2),command(1),p1)
sleep 10000
