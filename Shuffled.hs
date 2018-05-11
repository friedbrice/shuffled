module Shuffled (isShuffledNaive, isShuffledDynamic, isShuffledConcurrent) where

import Control.Concurrent.Async (race)
import Control.Monad (guard)
import Data.List (tails, find)

isShuffledConcurrent :: Eq a => ([a],[a]) -> [a] -> IO Bool
isShuffledConcurrent (left,right) combined =
  fmap (either id id) (race naive dynamic) where
    naive = return (isShuffledNaive (left,right) combined)
    dynamic = return (isShuffledDynamic (left,right) combined)

go :: (([a],[a],[a]) -> [Bool]) -> ([a],[a],[a]) -> [Bool]
go f (l:ls,r:rs,c:cs) | l == c && r == c = f (ls,r:rs,cs) ++ f (l:ls,rs,cs)
go f (l:ls,  rs,c:cs) | l == c           = f (ls,rs,cs)
go f (  ls,r:rs,c:cs) |           r == c = f (ls,rs,cs)
go _ (  [],  [],  [])                    = [True]
go _                _                    = [False]

isShuffledNaive :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffledNaive (left,right) combined = or (go (fix go) (left,right,combined))

isShuffledDynamic :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffledDynamic (left,right) combined =
  if length left + length right /= length combined then False else
  or (go (go' !) (left,right,combined)) where
    go' :: [(a,[Bool])]
    go' = [(x,go x) | x <- subproblems]
    subproblems :: [([a],[a],[a])]
    subproblems = do
      ls <- tails left
      rs <- tails right
      cs <- tails combined
      guard (length ls + length rs == length cs)
      return (ls,rs,cs)
    (!) :: [(a,[Bool])] -> a -> [Bool]
    xys ! x = case find (\(x',_) -> x' == x) xys of Just (_,y) -> y
