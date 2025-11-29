# ==========================
# Project configuration
# ==========================
PROJECT_NAME := MyProject.exe
VERSION      := 1.0
SRC_DIR      := src
BUILD_DIR    := build
INCLUDE_DIR  := include
LIB_DIR      := lib
BIN          := $(BUILD_DIR)/$(PROJECT_NAME)

RUNTIME_DIR  := runtime
SRC_LIB      := sqlite3
PREBUILT_LIB :=   #curl

# ==========================
# Compiler and flags
# ==========================
CXXFLAGS := $(shell tail -n +3 compile_flags.txt | tr '\n' ' ')
LDFLAGS := -L$(LIB_DIR)/prebuilt
LDFLAGS += $(foreach lib,$(PREBUILT_LIB),-l$(lib))

# ==========================
# Source and object files
# ==========================
SRC           := $(wildcard $(SRC_DIR)/*.cpp)
OBJ           := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/$(SRC_DIR)/%.o,$(SRC))

SRC_LIB_FILES := $(foreach lib,$(SRC_LIB),$(wildcard $(LIB_DIR)/$(lib)/*.cpp))
OBJ_LIB_FILES := $(patsubst $(LIB_DIR)/%.cpp,$(BUILD_DIR)/$(LIB_DIR)/%.o,$(SRC_LIB_FILES))

# ==========================
# Build rules
# ==========================
all: $(BIN)

$(BIN): $(OBJ) $(OBJ_LIB_FILES) | $(BUILD_DIR)
	g++ $(OBJ) $(OBJ_LIB_FILES) -o $@ $(LDFLAGS)

$(BUILD_DIR)/$(SRC_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	g++ $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/$(LIB_DIR)/%.o: $(LIB_DIR)/%.cpp | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	g++ $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/$(SRC_DIR)
	@mkdir -p $(BUILD_DIR)/$(LIB_DIR)

# ==========================
# Commands
# ==========================
run: $(BIN)
	cp -r $(RUNTIME_DIR)/. $(BUILD_DIR)/
	./$(BIN)

clean:
	rm -rf $(BUILD_DIR)

-include $(OBJ:.o=.d)
-include $(OBJ_LIB_FILES:.o=.d)

.PHONY: all clean run

