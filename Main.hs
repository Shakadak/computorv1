import Parser
import Text.Parsec (ParseError)
import Data.Function ((&), on)
import Data.Ord (comparing)
import Data.List (sortBy, groupBy)
import Math (abs)

solve_equation :: [(Double, Int)] -> String
solve_equation xs = "Reduced form: " ++ show_polynomial xs ++ polynomial_degree xs

interpret_equation :: Either ParseError [(String, String)] -> String
interpret_equation (Left err) = show err
interpret_equation (Right xs) = map convert xs & simplify & solve_equation

convert :: (String, String) -> (Double, Int)
convert (coeff, var) = (read coeff, read var)

simplify :: [(Double, Int)] -> [(Double, Int)]
simplify x = x & sortBy (flip $ comparing snd) & groupBy ((==) `on` snd) & map (foldl1 add_atom) & filter (((/=) `on` fst) (0.0, 1))

add_atom :: (Double, Int) -> (Double, Int) -> (Double, Int)
add_atom (x, z) (y, _) = (x + y, z)

show_polynomial :: [(Double, Int)] -> String
show_polynomial [] = "zero polynomial\n"
show_polynomial (x:[]) = show_atom x ++ " = 0\n"
show_polynomial (x:(coeff, pow):xs) = show_atom x ++ show_sign coeff ++ show_polynomial ((Math.abs coeff, pow):xs)

show_sign :: Double -> String
show_sign n
          | n < 0 = " - "
          | otherwise = " + "

show_atom :: (Double, Int) -> String
show_atom (coeff, 0) = show coeff
show_atom (1, pow) = "X^" ++ show pow
show_atom (-1, pow) = "-X^" ++ show pow
show_atom (coeff, pow) = show coeff ++ "X^" ++ show pow

polynomial_degree :: [(Double, Int)] -> String
polynomial_degree [] = "Polynomial degree left undefined, although we could set it at -1 or negative infinity if you really wish so.\n"
polynomial_degree ((_, x):_) = "Polynomial degree: " ++ show x ++ "\n"
