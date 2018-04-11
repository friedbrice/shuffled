module DynamicShuffled (isShuffled) where

import Control.Monad (guard)
import Data.List (tails)
import Data.Map.Lazier (Map)
import qualified Data.Map.Lazier as Map

isShuffled :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffled (left,right) combined = undefined

type X a = ([a],[a],[a])

go' :: Eq a => (X a -> [Bool]) -> X a -> [Bool]
go' f (l:ls,r:rs,c:cs) | l == c && r == c = f (ls,r:rs,cs) ++ f (l:ls,rs,cs)
go' f (l:ls,  rs,c:cs) | l == c           = f (ls,rs,cs)
go' f (  ls,r:rs,c:cs) |           r == c = f (ls,rs,cs)
go' _ (  [],  [],  [])                    = [True]
go' _                _                    = [False]

domain :: X a -> [X a]
domain (left,right,combined) = do
  ls <- tails left
  rs <- tails right
  cs <- tails combined
  guard $ length ls + length rs == length cs
  return (ls,rs,cs)

memoize :: Ord x => [x] -> (x -> y) -> x -> y
memoize xs f = (fromMap f . toMap xs) f

toMap :: Ord a => [a] -> (a -> b) -> Map a b
toMap xs f = Map.fromList [(x, f x) | x <- xs]

fromMap :: Ord a => (a -> b) -> Map a b -> a -> b
fromMap f repr x = case Map.lookup x repr of Just y -> y; Nothing -> f x
