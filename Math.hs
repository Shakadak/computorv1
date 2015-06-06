module Math where

abs :: (Num a, Ord a) => a -> a
abs n
    | n < 0 = -n
    | otherwise = n

discriminant :: (Num a, Ord a) => a -> a -> a -> a
discriminant a b c = b * b - 4 * a * c

-- Square root implementation using Newton's method.

sqrt :: Double -> Double
sqrt x = head $ filter (check_root x) (iterate (improve x) 1)

check_root :: Double -> Double -> Bool
check_root target guess = Math.abs (guess * guess - target) < 0.000000001

improve :: Double -> Double -> Double
improve target prev = (prev + target / prev) / 2
