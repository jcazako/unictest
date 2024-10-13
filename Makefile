CC = gcc
CFLAG = -Wall -Wextra -Werror -g
SRC = main.c
SRC_DIR = ./src
SRC_C = $(patsubst %, $(SRC_DIR)/%, $(SRC))
OBJ = $(patsubst %.c, %.o, $(SRC))
OBJ_DIR = ./obj
OBJ_O = $(patsubst %, $(OBJ_DIR)/%, $(OBJ))
DEP = $(patsubst %.o, %.d, $(OBJ_O))
TARGET = unictest
HDIR = include
.PHONY: re run rr clean fclean all

# The 'all' target, the default target that builds everything
all: $(TARGET)

$(TARGET): $(OBJ_O)
	@$(CC) -o $@ -I $(HDIR) $(OBJ_O) $(CFLAG)
	@echo "\033[32munictest done\033[0m"

##
#	. -MMD tells the compiler to generate a .d file for each .o file, which lists the dependencies (like included header files).
# . -c 
# . -o
# . $<
# . $@
# . -I
##
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(OBJ_DIR)
	$(CC) -MMD -c $< -o $@ -I $(HDIR) $(CFLAG) 

# ensures that make includes the .d files and tracks changes in the header files.
-include $(DEP)

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

clean:
	@rm -rf $(OBJ_O) $(DEP) $(OBJ_DIR)
	@echo "\033[31mobject files removed\033[0m"

fclean: clean
	@rm -rf $(TARGET)
	@echo "\033[31munictest removed\033[0m"

re: fclean fclean_lib all

run:
	@./$(TARGET)

rr: re run