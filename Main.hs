import Parser
import Text.Parsec (ParseError)
import Data.Function ((&), on)
import Data.Ord (comparing)
import Data.List (sortBy, groupBy, find)
import Data.Maybe (fromMaybe)
import Math (abs, discriminant)

solve_equation :: [(Double, Int)] -> String
solve_equation xs = "Reduced form: " ++ show_polynomial xs ++ polynomial_degree xs ++ polynomial_solutions xs

polynomial_solutions :: [(Double, Int)] -> String
polynomial_solutions xs = case xs of
                         [] -> "Infinity of solution, can't display all that.\n"
                         ((_, 0):ys) -> "No solution for you, nothing to solve anyway.\n"
                         ((_, 1):ys) -> "The solution is:\n" ++ degree1 xs
                         ((_, 2):ys) -> degree2 xs
                         _ -> "The polynomial degree is strictly greater than 2. I can't solve this. Can you ?\n"

degree1 :: [(Double, Int)] -> String
degree1 (x:[]) = "0\n"
degree1 ((x, _):(c, _):[]) = show ((-c) / x) ++ "\n"

degree2 :: [(Double, Int)] -> String
degree2 ((x2, _):xs) = do
                       let x1 = fst $ fromMaybe (0.0, 1) $ find (((==) `on` snd) (0, 1)) xs
                       let x0 = fst $ fromMaybe (0.0, 1) $ find (((==) `on` snd) (0, 0)) xs
                       solve_quadratic x2 x1 x0

solve_quadratic :: Double -> Double -> Double -> String
solve_quadratic a b c
                | delta == 0 = "One real solutions:\n" ++ show (-b / 2 * a) ++ "\n"
                | delta > 0 = "Two real solutions:\n" ++ show (1) ++ "\n" ++ show (-1) ++ "\n"
                | delta < 0 = "Two complex solutions:\n" ++ show (1) ++ "\n" ++ show (-1) ++ "\n"
                where delta = discriminant a b c

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
show_atom (1, pow) = 'X':(show_pow pow)
show_atom (-1, pow) = "-X" ++ show_pow pow
show_atom (coeff, pow) = show coeff ++ "X^" ++ show pow

show_pow :: Int -> String
show_pow 1 = ""
show_pow p = '^':(show p)

polynomial_degree :: [(Double, Int)] -> String
polynomial_degree [] = "Polynomial degree left undefined, although we could set it at -1 or negative infinity if you really wish so.\n"
polynomial_degree ((_, x):_) = "Polynomial degree: " ++ show x ++ "\n"

get :: a -> Int -> [a] -> a
get def _ [] = def
get def 0 (x:xs) = x
get def n (x:xs) = get def (n - 1) xs
