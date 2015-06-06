module Math where

abs :: (Num a, Ord a) => a -> a
abs n
    | n < 0 = -n
    | otherwise = n

discriminant :: (Num a, Ord a) => a -> a -> a -> a
discriminant a b c = b * b - 4 * a * c
