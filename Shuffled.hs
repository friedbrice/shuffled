module Shuffled (isShuffledNaive, isShuffledDynamic, isShuffledConcurrent) where

import Control.Concurrent.Async (race)
import Control.Monad (guard)
import Data.List (tails, find)

isShuffledConcurrent :: Eq a => ([a],[a]) -> [a] -> IO Bool
isShuffledConcurrent (left,right) combined =
  fmap (either id id) (race naive dynamic) where
    naive = return (isShuffledNaive (left,right) combined)
    dynamic = return (isShuffledDynamic (left,right) combined)

isShuffledNaive :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffledNaive (left,right) combined =
  or (go (left,right,combined)) where
    go (l:ls,r:rs,c:cs) | l == c && r == c = go (ls,r:rs,cs) ++ go (l:ls,rs,cs)
    go (l:ls,  rs,c:cs) | l == c           = go (ls,rs,cs)
    go (  ls,r:rs,c:cs) |           r == c = go (ls,rs,cs)
    go (  [],  [],  [])                    = [True]
    go                _                    = [False]

isShuffledDynamic :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffledDynamic (left,right) combined =
  if length left + length right /= length combined then False else
  or (go (left,right,combined)) where
    go (l:ls,r:rs,c:cs) | l == c && r == c = go' ! (ls,r:rs,cs) ++ go' ! (l:ls,rs,cs)
    go (l:ls,  rs,c:cs) | l == c           = go' ! (ls,rs,cs)
    go (  ls,r:rs,c:cs) | r == c           = go' ! (ls,rs,cs)
    go (  [],  [],  [])                    = [True]
    go                _                    = [False]
    go' = [(x,go x) | x <- subproblems]
    subproblems = do
      ls <- tails left
      rs <- tails right
      cs <- tails combined
      guard (length ls + length rs == length cs)
      return (ls,rs,cs)
    xys ! x = case find (\(x',_) -> x' == x) xys of
      Just (_,y) -> y
      _ -> error "lookup failed"
