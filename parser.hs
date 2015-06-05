import Text.Parsec (ParseError)
import Text.Parsec.String (Parser)
import Text.Parsec.String.Parsec (try)
import Text.Parsec.String.Char (oneOf, char, digit, string, satisfy, spaces)
import Control.Monad (void)
import Text.Parsec (ParseError)
import Text.Parsec.String (Parser)
import Text.Parsec.String.Parsec (parse)
import Text.Parsec.String.Combinator (many1, eof, manyTill, anyToken, option)
import Control.Applicative ((<|>), (<$>), (<*>), (<*), (*>), many)

regularParse :: Parser a -> String -> Either ParseError a
regularParse p = parse p ""

parseWithEof :: Parser a -> String -> Either ParseError a
parseWithEof p = parse (p <* eof) ""

parseWithLeftOver :: Parser a -> String -> Either ParseError (a,String)
parseWithLeftOver p = parse ((,) <$> p <*> leftOver) ""
    where leftOver = manyTill anyToken eof

parseWithWSEof :: Parser a -> String -> Either ParseError a
parseWithWSEof p = parseWithEof (spaces *> p)


lexeme :: Parser a -> Parser a
lexeme p = do
           x <- p
           spaces
           return x

relatif :: Parser String
relatif = do
          sign <- option "" (string "-")
          spaces
          natural <- many1 digit
          return (sign ++ natural)

decimal :: Parser String
decimal = do
          dot <- char '.'
          natural <- many1 digit
          return (dot:natural)

real :: Parser String
real = do
       x1 <- relatif
       x2 <- option "" decimal
       return (x1 ++ x2)

power :: Parser String
power = do
        char '^'
        spaces
        natural <- many1 digit
        return (natural)
