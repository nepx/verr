var child_process = require("child_process");
function exec(n) {
    console.log(n);
    child_process.execSync(n);
}

// Build each file

var tests = {
    "alu": ["alu.asm"]
};

function n(n) {
    if (process.platform === "win32") return n.join("\\"); else return n.join("/");
}

var olddir = process.cwd();
for (var i in tests) {
    var proc = tests[i];
    process.chdir(n(["src", "tests", i]));
    exec("nasm -E " + proc[0] + " -o " + n(["..", "..", "gen.asm"]));
    process.chdir("../..");
    
    // Create the ROM 
    exec("nasm -fbin rom.asm -o rom.bin");
}
