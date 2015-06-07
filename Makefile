NAME := computor

PARSEC := Text/Parsec/String/

SRC := Main.hs \
       Math.hs \
       Parser.hs \
       $(PARSEC)Char.hs \
       $(PARSEC)Combinator.hs \
       $(PARSEC)Parsec.hs


$(NAME): $(SRC)
	ghc --make $(SRC) -o $@ -outputdir trash

clean:
	rm -rf trash

fclean: clean
	rm -f $(NAME)

re: fclean all
