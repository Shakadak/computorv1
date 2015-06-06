import Parser
import Text.Parsec (ParseError)

interpret_equation :: Either ParseError [(String, String)] -> IO ()
interpret_equation (Left err) = print err
--interpret_equation
