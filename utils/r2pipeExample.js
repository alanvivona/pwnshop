const r2pipe = require ("r2pipe")

const doSomeStuff = (err, r2) => {

  // r2.cmd("iS", function(err, output) {
    // console.log (output)
  // })

  // r2.syscmd("rabin2 -S /bin/ls", (err, o) => {
    // console.log (o)
  // })

  // r2.cmdj("aij entry0+2", (err, o) => {
    // console.log(o)
  // })

  // r2.cmd('af @ entry0', (err, o) => {
      // r2.cmd("pdf @ entry0", (err, o) => {
          // console.log(o)
      // })
  // })

  r2.cmdj('/Rj', (err, gadgets) => {
    console.log(gadgets.filter(g => g.opcodes.length > 0 ))
    r2.quit()
  })
}

// Local debug
// r2pipe.pipe ("/bin/ls", doSomeStuff);
// r2pipe.launch ("/bin/ls", doSomeStuff);

// Remote
// launch r2:
// > r2 /bin/ls
// > =h:           (this launches the web server)
// acces the web server GUI going to http://<host>:9090/
// or connect for scripting with r2pipe using http://<host>:9090/cmd/
r2pipe.connect("http://localhost:9090/cmd/", doSomeStuff);
