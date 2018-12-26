set filename $argv[1]
echo "compiling $filename..."
nasm -f elf64 $filename -o $filename.o; and ld $filename.o -o $filename.elf64; and rm $filename.o
echo -n "done!"
