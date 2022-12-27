EMULATOR_EXE = x64sc.gtk
TARGET = program.prg
TARGET_TMP = program.tmp

$(TARGET): main.asm
	64tass -C -a -B -i main.asm -o $(TARGET)

.PHONY: clean run

clean:
	-$(RM) $(TARGET) $(TARGET_TMP)

run: $(TARGET)
	$(EMULATOR_EXE) $(TARGET)
