$fa = 5;
$fs = 1;

bottleDiameter = 70;
topBottleDiameter = 80;
depth = 20;
layers = 2;
bottomBottleCount = 3;
openTop = true;
stack = false;
wallThickness = 1.6;

eps = 0.01;
layerYOffset = sqrt(3 / 4 * bottleDiameter ^ 2) + wallThickness;

union() {
  for(i = [0:layers - 2]) {
    layerSize = stack ? bottomBottleCount - 1 : bottomBottleCount - 1 - i % 2;
    for(j = [0:layerSize]) {
      translate([j * (bottleDiameter + wallThickness) + (i % 2) * (bottleDiameter / 2 + wallThickness / 2), i * layerYOffset, 0]) difference() {
        cylinder(depth, r = bottleDiameter / 2 + wallThickness);
        translate([0, 0, -eps]) cylinder(depth + 2 * eps, r = bottleDiameter / 2);
      };
    }
  }
  
  topLayerIndex = layers - 1;
  topLayerYOffset = sqrt(1 / 4 * (bottleDiameter + topBottleDiameter) ^ 2 - 1 / 4 * bottleDiameter ^ 2) + wallThickness;
  openTopCubeYOffset = topBottleDiameter > bottleDiameter ? topBottleDiameter / 2 + wallThickness - sqrt((topBottleDiameter / 2 + wallThickness) ^ 2 - (bottleDiameter / 2 + wallThickness / 2) ^ 2) + wallThickness : topBottleDiameter / 2;
  topLayerSize = stack ? bottomBottleCount - 1 : bottomBottleCount - 1 - topLayerIndex % 2;
  echo(openTopCubeYOffset);
  for(j = [0:topLayerSize]) {
      translate([j * (bottleDiameter + wallThickness) + (topLayerIndex % 2) * (bottleDiameter / 2 + wallThickness / 2), (layers - 2) * layerYOffset + topLayerYOffset, 0]) difference() {
        cylinder(depth, r = topBottleDiameter / 2 + wallThickness);
        translate([0, 0, -eps]) cylinder(depth + 2 * eps, r = topBottleDiameter / 2);
        if (openTop) translate([0, openTopCubeYOffset, depth / 2]) cube([topBottleDiameter + wallThickness * 2 + eps * 2, topBottleDiameter + wallThickness * 2, depth + eps * 2], true);
      };
    }
}