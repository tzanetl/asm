name := sum

$(name): $(name).asm
	nasm -f elf64 -o $(name).o $(name).asm
	ld -o $(name) $(name).o

args = 10 32
run: $(name)
	./$(name) $(args)

clean:
	rm -f $(name) $(name).o
