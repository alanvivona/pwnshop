const blockSize = 2000
for (let i = 0; i < 3; i++) {
  const char = String.fromCharCode(0x41 + i) // A B
  process.stdout.write(char.repeat(blockSize))
}