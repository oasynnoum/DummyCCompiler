CC = g++
RE2C = re2c
PROJECT_DIR = .
SRC_DIR = $(PROJECT_DIR)/src
INC_DIR = $(PROJECT_DIR)/inc
OBJ_DIR = $(PROJECT_DIR)/obj
BIN_DIR = $(PROJECT_DIR)/bin

SAMPLE_DIR = $(PROJECT_DIR)/sample

MAIN_SRC = dcc.cpp
TOKEN_SRC = token.cpp
LEXER_LEX = lexer.l
LEXER_SRC = lexer.cpp
AST_SRC = AST.cpp
PARSER_SRC = parser.cpp
CODEGEN_SRC = codegen.cpp


MAIN_SRC_PATH = $(SRC_DIR)/$(MAIN_SRC)
TOKEN_SRC_PATH = $(SRC_DIR)/$(TOKEN_SRC)
LEXER_LEX_PATH = $(SRC_DIR)/$(LEXER_LEX)
LEXER_SRC_PATH = $(SRC_DIR)/$(LEXER_SRC)
AST_SRC_PATH = $(SRC_DIR)/$(AST_SRC)
PARSER_SRC_PATH = $(SRC_DIR)/$(PARSER_SRC)
CODEGEN_SRC_PATH = $(SRC_DIR)/$(CODEGEN_SRC)

MAIN_OBJ = $(OBJ_DIR)/$(MAIN_SRC:.cpp=.o)
TOKEN_OBJ = $(OBJ_DIR)/$(TOKEN_SRC:.cpp=.o)
LEXER_OBJ = $(OBJ_DIR)/$(LEXER_SRC:.cpp=.o)
AST_OBJ = $(OBJ_DIR)/$(AST_SRC:.cpp=.o)
PARSER_OBJ = $(OBJ_DIR)/$(PARSER_SRC:.cpp=.o)
CODEGEN_OBJ = $(OBJ_DIR)/$(CODEGEN_SRC:.cpp=.o)
FRONT_OBJ = $(MAIN_OBJ) $(TOKEN_OBJ) $(LEXER_OBJ) $(AST_OBJ) $(PARSER_OBJ) $(CODEGEN_OBJ)

TOOL = $(BIN_DIR)/dcc
CONFIG = llvm-config
LLVM_FLAGS = --cxxflags --ldflags --libs
INC_FLAGS = -I$(INC_DIR)


all:$(FRONT_OBJ) 
	mkdir -p $(BIN_DIR)
	$(CC) -g $(FRONT_OBJ) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -ldl -o $(TOOL)

$(MAIN_OBJ):$(MAIN_SRC_PATH)
	mkdir -p $(OBJ_DIR)
	$(CC) -g $(MAIN_SRC_PATH) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -c -o $(MAIN_OBJ) 

$(TOKEN_OBJ):$(TOKEN_SRC_PATH)
	$(CC) -g $(TOKEN_SRC_PATH) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -c -o $(TOKEN_OBJ) 

$(LEXER_SRC):$(LEXER_LEX_PATH)
	$(RE2C) -i -o $(LEXER_SRC_PATH) $(LEXER_LEX_PATH)

$(LEXER_OBJ):$(LEXER_SRC)
	$(CC) -g $(LEXER_SRC_PATH) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -c -o $(LEXER_OBJ) 

$(AST_OBJ):$(AST_SRC_PATH)
	$(CC) -g $(AST_SRC_PATH) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -c -o $(AST_OBJ) 

$(PARSER_OBJ):$(PARSER_SRC_PATH)
	$(CC) -g $(PARSER_SRC_PATH) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -c -o $(PARSER_OBJ) 

$(CODEGEN_OBJ):$(CODEGEN_SRC_PATH)
	$(CC) -g $(CODEGEN_SRC_PATH) $(INC_FLAGS) `$(CONFIG) $(LLVM_FLAGS)` -c -o $(CODEGEN_OBJ) 

clean:
	rm -rf $(FRONT_OBJ) $(TOOL)

run:
	$(TOOL) -o $(SAMPLE_DIR)/test.ll -l ./lib/printnum.ll $(SAMPLE_DIR)/test.dc -jit

link:
	llvm-link $(SAMPLE_DIR)/test.ll ./lib/printnum.ll -S -o  $(SAMPLE_DIR)/link_test.ll

do:
	lli $(SAMPLE_DIR)/link_test.ll
