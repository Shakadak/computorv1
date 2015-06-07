NAME := computor

PARSEC := Text/Parsec/String/

SRC := Main.hs \
       Math.hs \
       Parser.hs \
       $(PARSEC)Char.hs \
       $(PARSEC)Combinator.hs \
       $(PARSEC)Parsec.hs

OBJ := $(SRC:.hs=.o)

INTERFACE := $(SRC:.hs=.hi)

all: $(NAME)

$(NAME):
	ghc --make $(SRC) -o $@

clean:
	rm -f $(OBJ) $(INTERFACE)

fclean: clean
	rm -f $(NAME)

re: fclean all
