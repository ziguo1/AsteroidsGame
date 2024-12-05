// --- BEGIN SHIM; REMOVE TO RUN ON DESKTOP ---
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
  while (Date.now() <= blockTill) {}
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
    })
    __errBuff = newlines[newlines.length - 1];
  }
};

System.currentTimeMillis = function () { return Date.now(); }

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
    })
    __outBuff = newlines[newlines.length - 1];
  }
};

System.out.println = function (chars) {
  System.out.print(chars + "\n");
};
// --- END SHIM; REMOVE TO RUN ON DEKTOP ---