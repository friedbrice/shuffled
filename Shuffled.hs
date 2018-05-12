module Shuffled (isShuffled) where

import Control.Concurrent.Async (race)
import Control.Monad (guard)
import Data.Function (fix)
import Data.Array (Array, (!), listArray)
import Debug.Trace (trace)

isShuffled (x,y) w = fmap (either id id) (race dynamic naive) where
    dynamic = return (isShuffledDynamic x y w)
    naive = return (isShuffledNaive x y w)

step f x'@(x:xs) y'@(y:ys) (w:ws) | x == w && y == w = f xs y' ws || f x' ys ws
step f    (x:xs)        ys (w:ws) | x == w           = f xs ys ws
step f        xs    (y:ys) (w:ws) |           y == w = f xs ys ws
step _        []        []     []                    = True
step _         _         _      _                    = False

run f x y w = length x + length y == length w && f x y w

isShuffledNaive x y w = run (fix step) x y w

isShuffledDynamic x y w = run get x y w where
    n = length x
    m = length y
    arr = listArray (0,n) [ listArray (0,m) [ ans i j | j <- [0..m] ] | i <- [0..n] ]
    ans i j = step get (drop (n - i) x) (drop (m - j) y) (drop (n + m - i - j) w)
    get x' y' _ = arr ! length x' ! length y'
