CFLAGS = -g -arcv2em
LFLAGS = -Hcl -Hheap=0 -Hstack=512 
SRC = main.c
BITCODE = main.ll
ELF = a.out
ELF_BITCODE = a2.out
BITCODE_DIR = bitcode

compile:
	ccac $(CFLAGS) $(LFLAGS) $(SRC) -o $(ELF)
	
to_bitcode:
	ccac -BS $(CFLAGS) $(SRC) -o $(BITCODE)
	
from_bitcode:
	ccac -g $(LFLAGS) $(BITCODE) -o $(ELF_BITCODE)
	
rustc:
	rustc --emit=llvm-ir -C panic=abort --target arcv2-none-elf32 src/main.rs; \
	ccac -Hnocrt -Hnolib $(CFLAGS) -Hheap=0 -Hstack=512 rust_main.ll -o rust.out

cargo-bc:
	cargo rustc -- --emit=llvm-bc
	
cargo-ir:
	cargo rustc -- --emit=llvm-ir
	
ccac-bc:
	ccac -Hnocrt -Hnolib $(CFLAGS) -Hheap=0 -Hstack=512 target/arcv2-none-elf32/debug/deps/*.bc -o $(ELF_BITCODE)
	
ccac-ir:
	ccac -Hcl $(CFLAGS) -Hheap=0 -Hstack=512 target/arcv2-none-elf32/debug/deps/*.ll -o $(ELF_BITCODE)
	
clean:
	cargo clean
	rm -rf $(ELF)
	rm -rf $(ELF_BITCODE)
	rm -rf $(BITCODE)

	
	
