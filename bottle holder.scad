$fa = 5;
$fs = 1;

bottleDiameter = 70;
topBottleDiameter = 80;
depth = 20;
layers = 3;
bottomBottleCount = 3;
openTop = true;
stack = false;
wallThickness = 1.6;
connector = true;
connectorBothSides = false;

eps = 0.01;

connectorDiameter = 3.2;
connectorDepth = 5;

// Y offsets for uniform layers and top layer
layerYOffset = sqrt(3 / 4 * bottleDiameter ^ 2) + wallThickness;
topLayerExtraYOffset = sqrt(1 / 4 * (bottleDiameter + topBottleDiameter) ^ 2 - 1 / 4 * bottleDiameter ^ 2) + wallThickness - layerYOffset;

topLayerIndex = layers - 1;

// Y offset for the difference cube, if top layer is open
openTopCubeYOffset = topBottleDiameter > bottleDiameter ? topBottleDiameter / 2 + wallThickness - sqrt((topBottleDiameter / 2 + wallThickness) ^ 2 - (bottleDiameter / 2 + wallThickness / 2) ^ 2) + wallThickness : topBottleDiameter / 2;

fullHolderDiameter = bottleDiameter + 2 * wallThickness;

function isTopLayer(index) = index == topLayerIndex;

module connectorHole(lower = false, bottom = false) {
  translate([(bottleDiameter + wallThickness) / 2, (lower ? -1 : 1) * layerYOffset / 3, bottom ? -eps : depth + eps - connectorDepth]) cylinder(connectorDepth + eps, d = connectorDiameter);
}

module translateLocation(row, index) {
  // x: simple x offset times index on layer + offset half a holder for odd layers
  // y: simple y offset times layers + extra offset for top layer
  translate([index * (bottleDiameter + wallThickness) + (row % 2) * (bottleDiameter / 2 + wallThickness / 2), row * layerYOffset + (isTopLayer(row) ? topLayerExtraYOffset : 0), 0]) children();
}

difference() {
  union() {
    for(i = [0:layers - 1]) {
      layerSize = stack ? bottomBottleCount - 1 : bottomBottleCount - 1 - i % 2;
      for(j = [0:layerSize]) {
        translateLocation(i, j) cylinder(depth, r = (isTopLayer(i) ? topBottleDiameter : bottleDiameter) / 2 + wallThickness);
      }
    }
    translate([- wallThickness / 2, - (bottleDiameter / 2 + wallThickness), 0]) cube([(bottomBottleCount - 1) * bottleDiameter + bottomBottleCount * wallThickness, (layers - 1) * layerYOffset + bottleDiameter / 2 + wallThickness + topLayerExtraYOffset, depth]);
    if (stack) translate([(bottomBottleCount - 1) * (bottleDiameter + wallThickness), 0, 0]) cube ([bottleDiameter / 2 + wallThickness, (layers - 1) * layerYOffset, depth]);
  };
  
  union() {
    for(i = [0:layers - 1]) {
      layerSize = stack ? bottomBottleCount - 1 : bottomBottleCount - 1 - i % 2;
      for(j = [0:layerSize]) {
        translateLocation(i, j) union() {
          translate([0, 0, -eps]) cylinder(depth + 2 * eps, r = (isTopLayer(i) ? topBottleDiameter : bottleDiameter) / 2);
          if (isTopLayer(i) && openTop) translate([0, openTopCubeYOffset, depth / 2]) cube([topBottleDiameter + wallThickness * 2 + eps * 2, topBottleDiameter + wallThickness * 2, depth + eps * 2], true);
          if (!isTopLayer(i) && connector && j < layerSize) {
            connectorHole();
            connectorHole(true);
            if (connectorBothSides) {
              connectorHole(false, true);
              connectorHole(true, true);
            }
          }
        };
      }
    }
  };
}
