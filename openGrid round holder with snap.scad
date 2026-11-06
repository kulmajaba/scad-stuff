$fs = 1;
$fa = 6;

eps = 0.01;

hObj = 50;
dObj = 25;
wallThickness = 1.6;
bottom = true;

hCyl = bottom ? hObj + wallThickness : hObj;
dCyl = dObj + wallThickness;
rCyl = dCyl / 2;
chamferY = dObj >= 5 ? 5 : dObj;
chamferX = sqrt(rCyl ^ 2 - (rCyl - chamferY) ^ 2);
bottomChamfer = sqrt(2 * (sqrt(2 * wallThickness ^ 2) - wallThickness) ^ 2);

module prism(w, d, h) {
  polyhedron(
    points=[
      [0,0,0],
      [0,d,h],
      [w,d,h],
      [w,0,0],
      [0,d,0],
      [w,d,0]
    ],
    faces=[
      [0,1,2,3],
      [2,1,4,5],
      [0,3,5,4],
      [0,4,1],
      [3,2,5]
    ]
  );
}

module chamfer() {
  chamferLPoints = [
    [0 - eps,  0 - eps,  -0.8       ],
    [9.1375,   0 - eps,  -0.8       ],
    [12.4,     0 - eps,  -4.0625    ],
    [chamferX, chamferY, -0.8       ],
    [0 - eps,  chamferY, -0.8       ],
    [12.4,     0 - eps,  -13.2 - eps],
    [chamferX, chamferY, -13.2 - eps],
    [0 - eps,  0 - eps,  -13.2 - eps],
    [0 - eps,  chamferY, -13.2 - eps]
  ];
  chamferLFaces = [
    [0,4,3,1],
    [1,3,2],
    [2,3,6,5],
    [7,5,6,8],
    [4,8,6,3],
    [0,7,8,4],
    [0,1,2,5,7]
  ];
  polyhedron(chamferLPoints, chamferLFaces);
}

module chamferFull() {
  chamferToTopPoints = [
    [0 - eps,     0 - eps,  -0.8 - eps],
    [9.1375,      0 - eps,  -0.8 - eps],
    [chamferX,    chamferY, -0.8 - eps],
    [0 - eps,     chamferY, -0.8 - eps],
    [chamferX - chamferY,    chamferY, chamferY         ],
    [0 - eps,     chamferY, chamferY         ] 
  ];
  chamferToTopFaces = [
    [0,1,2,3],
    [1,4,2],
    [3,5,0],
    [5,4,1,0],
    [4,5,3,2]
  ];

  union() {
    chamfer();
    mirror([1,0,0]) chamfer();
    mirror([0,0,1]) translate([0, 0, 13.2*2]) chamfer();
    mirror([1,0,0]) mirror([0,0,1]) translate([0, 0, 13.2*2]) chamfer();
    mirror([0,0,1]) translate([0, 0, 13.2*2]) polyhedron(chamferToTopPoints, chamferToTopFaces);
    mirror([1,0,0]) mirror([0,0,1]) translate([0, 0, 13.2*2]) polyhedron(chamferToTopPoints, chamferToTopFaces);
  }
}

difference() {
  union() {
    rotate([90, 0, 180]) translate([0, -13.2, -6.8]) import("opengrid-bare-directional-snap-v21.3mf");
    chamferFull();
    translate([0, dCyl / 2, -hCyl]) cylinder(hCyl, d = dCyl);
  }
  
  union() {
    translate([-14, -6.8 - eps, -25.6 + 6.8 - eps]) rotate([-90, 0, 0]) prism(28, 6.8 + eps, 6.8 + eps);
    translate([-14, -6.8 - eps, -25.6 - 6.8 + eps]) cube([28, 6.8 + eps, 6.8]);
  }

  translate([0, dCyl / 2, -hObj - eps]) cylinder(hObj + 2 * eps, d1=dObj, d2=dObj);
  
  if (bottom) {
    difference() {
      translate([0, dCyl / 2, -hCyl -eps]) cylinder(wallThickness, d = dCyl + eps * 2);
      translate([0, dCyl / 2, -hCyl + eps]) cylinder(wallThickness + eps, d1 = dCyl - 2 * bottomChamfer, d2 = dCyl + eps);
    }
  }
}
