// --- BEGIN SHIM; REMOVE TO RUN ON DESKTOP ---

(function () {
  var __drawCtx = {
  fillColor:
  null,
  strokeColor:
  null,
  backgroundColor:
  null
};
var matricies = [];

// processing.js hurts my brain
globalThis.getGraphics = function () {
  return __drawCtx;
};

globalThis.getSurface = function () {
  Object obj = {};
  obj.setTitle = function (title) {
    document.title = title;
  };
  return obj;
};

globalThis.getMatrix = function () {
  // return a (fake) matrix object
  Object ret = {};
  ret.mult = function (srcVect, destVect) {
    float x = srcVect.x, y = srcVect.y;
    for (int i = 0; i < matricies.length; i++) {
      x += matricies[i].trans.x;
      y += matricies[i].trans.y;

      float rot = matricies[i].rot;
      if (rot != 0) {
        float xTemp = x;
        x = x * cos(rot) - y * sin(rot);
        y = xTemp * sin(rot) + y * cos(rot);
      }
    };
    destVect.x = x;
    destVect.y = y;
  };
  return ret;
};

Function __oldPushMatrix = pushMatrix;
Function __oldPopMatrix = popMatrix;
Function __oldRotate = rotate;
Function __oldTranslate = translate;

$p.pushMatrix = function () {
  __oldPushMatrix();
  Object pushConstruct = {};
  pushConstruct.rot = 0;
  pushConstruct.trans = {};
  pushConstruct.trans.x = 0;
  pushConstruct.trans.y = 0;
  matricies.push(pushConstruct);
};

$p.popMatrix = function () {
  __oldPopMatrix();
  matricies.pop();
};

$p.rotate = function (angle) {
  __oldRotate(angle);
  matricies[matricies.length - 1].rot += angle;
};

$p.translate = function (x, y) {
  __oldTranslate(x, y);
  matricies[matricies.length - 1].trans.x += x;
  matricies[matricies.length - 1].trans.y += y;
};

$p.dist = function (...args) {
  if (args.length == 4) {
    var x1 = (float) args[0], y1 = (float) args[1], x2 = (float) args[2], y2 = (float) args[3];
    return Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2);
  } else if (args.length == 6) {
    var x1 = (float) args[0], y1 = (float) args[1], z1 = (float) args[2], x2 = (float) args[3], y2 = (float) args[4], z2 = (float) args[5];
    return Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2);
  }
}

var __oldStroke = stroke;
var __oldNoStroke = noStroke;
var __oldFill = fill;
var __oldNoFill = noFill;

var __background = background;
$p.background = function (c) {
  if (c == null) c = color(255);
  __background(c);
  __drawCtx.backgroundColor = c;
};

$p.stroke = function (c) {
  if (c == null) c = color(255);
  __drawCtx.strokeColor = c;
  __oldStroke(c);
};

$p.noStroke = function () {
  __drawCtx.strokeColor = color(255);
  __oldNoStroke();
};

$p.fill = function (c) {
  if (c == null) c = color(255);
  __drawCtx.fillColor = c;
  __oldFill(c);
};

$p.noFill = function () {
  __drawCtx.fillColor = color(255);
  __oldNoFill();
};
})();

void circle(float x, float y, float extent) {
  ellipse(x, y, extent, extent);
}

void square(float x, float y, float extent) {
  rect(x, y, extent, extent)
}

void clear() {
  background(color(255, 255, 255));
}

void delay(int length) {
  long blockTill = Date.now() + length;
  while (Date.now() <= blockTill) {
  }
}

String __errBuff = "";
String __outBuff = "";

var System = {};
System.out = {};
System.err = {};

System.err.print = function (chars) {
  __errBuff += chars;
  String[] newlines = __errBuff.split("\n");
  if (newlines.length > 0) {
    String[] linesToPrint = newlines.slice(0, newlines.length - 1);
    linesToPrint.forEach(function (line) {
      console.error(line);
    }
    )
    __errBuff = newlines[newlines.length - 1];
  }
};

System.currentTimeMillis = function () {
  return Date.now();
}

System.err.println = function (chars) {
  System.err.print(chars + "\n");
};

System.out.print = function (chars) {
  __outBuff += chars;
  String[] newlines = __outBuff.split("\n");
  if (newlines.length > 0) {
    String[] linesToPrint = newlines.slice(0, newlines.length - 1);
    linesToPrint.forEach(function (line) {
      console.log(line);
    }
    )
    __outBuff = newlines[newlines.length - 1];
  }
};

System.out.println = function (chars) {
  System.out.print(chars + "\n");
};
// --- END SHIM; REMOVE TO RUN ON DEKTOP ---
