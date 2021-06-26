#include once "ega4.bi"

dim p1 as any ptr
screenRes 640,480,32
p1=loadBMP("cube.bmp")
line (0,0)-(640,480),rgb(255,64,255),bf
put (0,0),p1
converts ("cube.bmp",p1)
sleep 10000
