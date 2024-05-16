PVector a1, a2, a3, a4, b1, b2, b3, b4;


a1 = new PVector (0,0,0);
a2 = new PVector (10,0,0);
a3 = new PVector (0,10,0);
a4 = new PVector (10,10,0);

b1 = new PVector (0,0,10);
b2 = new PVector (10,0,10);
b3 = new PVector (0,10,10);
b4 = new PVector (10,10,10);

//top
beginShape ();
vertex (a1.x, a1.y);
vertex (a2.x, a2.y);
vertex (a3.x, a3.y);
vertex (a4.x, a4.y);
endShape (CLOSE);

//top
beginShape ();
vertex (a1.x, a1.y);
vertex (a2.x, a2.y);
vertex (a3.x, a3.y);
vertex (a4.x, a4.y);
endShape (CLOSE);
