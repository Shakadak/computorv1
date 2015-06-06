import Text.Parsec (ParseError)
import Text.Parsec.String (Parser)
import Text.Parsec.String.Parsec (try)
import Text.Parsec.String.Char (oneOf, char, digit, string, satisfy, spaces)
import Control.Monad (void)
import Text.Parsec (ParseError)
import Text.Parsec.String (Parser)
import Text.Parsec.String.Parsec (parse)
import Text.Parsec.String.Combinator (many1, eof, manyTill, anyToken, option, optional, choice, lookAhead)
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

natural :: Parser String
natural = many1 digit

relatif :: Parser String -> Parser String
relatif p = do
          sign <- lexeme $ option "" (string "-")
          num <- p
          return (sign ++ num)

decimal :: Parser String
decimal = do
          dot <- char '.'
          natural <- natural
          return (dot:natural)

realp :: Parser String
realp = do
       x1 <- natural
       x2 <- option "" decimal
       return (x1 ++ x2)

power :: Parser String
power = do
        lexeme $ char '^'
        natural <- lexeme $ many1 digit
        return (natural)

variable :: Parser String
variable = do
           lexeme $ char 'X'
           pow <- lexeme $ option "1" power
           return pow

atom :: Parser (String, String)
atom = do
       lexeme $ optional (char '+')
       coefficient <- lexeme $ relatif $ option "1" realp
       lexeme $ optional (char '*')
       variable <- lexeme $ option "0" variable
       return (coefficient, variable)

composite :: Parser (String, String)
composite = do
            lexeme $ lookAhead $ choice ((char '+'):(char '-'):[])
            atom <- atom
            return atom

polynomial :: Parser [(String, String)]
polynomial = do
             atom <- atom
             composites <- many $ composite
             return (atom : composites)
