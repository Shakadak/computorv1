NAME := computor

PARSEC := Text/Parsec/String/

SRC := Main.hs \
       Parser.hs \
       $(PARSEC)Char.hs \
       $(PARSEC)Combinator.hs \
       $(PARSEC)Parsec.hs

OBJ := $(SRC:.hs=.o)

INTERFACE := $(SRC:.hs=.hi)

$(NAME):
    ghc --make $(SRC)
