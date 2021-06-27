#include once "ega4.bi"

dim p1 as any ptr
screenRes 320,200,4
line (0,0)-(320,200),5,bf
p1=loadsega("cubes.ega")
put (0,0),p1,pset

sleep 10000
