import Parser
import Text.Parsec (ParseError)
import Data.Function ((&), on)
import Data.Ord (comparing)
import Data.List (sortBy, groupBy)

interpret_equation :: Either ParseError [(String, String)] -> String
interpret_equation (Left err) = show err
interpret_equation (Right xs) = show $ map convert xs & simplify

convert :: (String, String) -> (Double, Int)
convert (coeff, var) = (read coeff, read var)

simplify :: [(Double, Int)] -> [(Double, Int)]
simplify x = x & sortBy (flip $ comparing snd) & groupBy ((==) `on` snd) & map (foldl1 add_atom)

add_atom :: (Double, Int) -> (Double, Int) -> (Double, Int)
add_atom (x, z) (y, _) = (x + y, z)
