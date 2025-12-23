hello: hello.asm
	nasm -f elf64 -o hello.o hello.asm
	ld -o hello hello.o

run: hello
	./hello

clean:
	rm -f hello hello.o
