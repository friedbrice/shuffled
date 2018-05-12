module Shuffled (isShuffled) where

import Control.Concurrent.Async (race)
import Control.Monad (guard)
import Data.Function (fix)
import Data.Array (Array, (!), listArray)
import Debug.Trace (trace)

isShuffled :: (Eq a, Ord a) => ([a],[a]) -> [a] -> IO Bool
isShuffled (x,y) w =
    fmap (either id id) (race dynamic naive) where
      dynamic = return (isShuffledDynamic x y w)
      naive = return (isShuffledNaive x y w)

step :: Eq a => ([a] -> [a] -> [a] -> Bool) -> [a] -> [a] -> [a] -> Bool
step f (x:xs) (y:ys) (w:ws) | x == w && y == w = f xs (y:ys) ws || f (x:xs) ys ws
step f (x:xs)     ys (w:ws) | x == w           = f xs ys ws
step f     xs (y:ys) (w:ws) |           y == w = f xs ys ws
step _     []     []     []                    = True
step _      _      _      _                    = False

run :: ([a] -> [a] -> [a] -> Bool) -> [a] -> [a] -> [a] -> Bool
run f x y w = if length x + length y /= length w then False else f x y w

isShuffledNaive :: Eq a => [a] -> [a] -> [a] -> Bool
isShuffledNaive x y w = run (fix step) x y w

isShuffledDynamic :: (Eq a, Ord a) => [a] -> [a] -> [a] -> Bool
isShuffledDynamic x y w = run get x y w where
    n = length x
    m = length y

    get :: [a] -> [a] -> [a] -> Bool
    get x' y' _ = mem ! length x' ! length y'

    mem :: Array Int (Array Int Bool)
    mem = listArray (0,n) [ listArray (0,m) [ ans i j | j <- [0..m] ] | i <- [0..n] ]

    ans :: Int -> Int -> Bool
    ans i j = step get (drop (n - i) x) (drop (m - j) y) (drop (n + m - i - j) w)
