module Shuffled (isShuffledNaive, isShuffledDynamic, isShuffledConcurrent) where

import Control.Concurrent.Async (race)
import Control.Monad (guard)
import Data.Function (fix)
import Data.List (tails, find)

isShuffledConcurrent :: Eq a => ([a],[a]) -> [a] -> IO Bool
isShuffledConcurrent (left,right) combined =
  fmap (either id id) (race naive dynamic) where
    naive = return (isShuffledNaive (left,right) combined)
    dynamic = return (isShuffledDynamic (left,right) combined)

step :: Eq a => (([a],[a],[a]) -> [Bool]) -> ([a],[a],[a]) -> [Bool]
step f (l:ls,r:rs,c:cs) | l == c && r == c = f (ls,r:rs,cs) ++ f (l:ls,rs,cs)
step f (l:ls,  rs,c:cs) | l == c           = f (ls,rs,cs)
step f (  ls,r:rs,c:cs) |           r == c = f (ls,rs,cs)
step _ (  [],  [],  [])                    = [True]
step _                _                    = [False]

run :: (([a],[a],[a]) -> [Bool]) -> ([a],[a],[a]) -> Bool
run f (ls,rs,cs) =
  if length ls + length rs /= length cs then False
  else or (f (ls,rs,cs))

isShuffledNaive :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffledNaive (ls,rs) cs = run (fix step) (ls,rs,cs)

isShuffledDynamic :: Eq a => ([a],[a]) -> [a] -> Bool
isShuffledDynamic (ls,rs) cs = run step' (ls, rs, cs) where
  step' = step (get store)
  store = [ (x,step' x) | x <- subproblems (ls,rs,cs) ]
  get store x0 = head [ y | (x,y) <- store, x == x0 ]

subproblems :: ([a],[a],[a]) -> [([a],[a],[a])]
subproblems (ls,rs,cs) = do
  ls' <- tails ls
  rs' <- tails rs
  cs' <- tails cs
  guard (length ls' + length rs' == length cs')
  return (ls',rs',cs')
