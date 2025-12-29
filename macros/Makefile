name := macros

$(name): $(name).asm
	nasm -f elf64 -o $(name).o $(name).asm
	ld -o $(name) $(name).o

# Define debug flag
debug: $(name).asm
	nasm -D DEBUG -f elf64 -o $(name).o $(name).asm
	ld -o $(name) $(name).o

run: $(name)
	./$(name)

clean:
	rm -f $(name) $(name).o
