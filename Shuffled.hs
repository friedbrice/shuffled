module Shuffled (isShuffled) where

isShuffled (left,right) combined = or (go (left,right,combined)) where
  go (l:ls,r:rs,c:cs) | l == c && r == c = go (ls,r:rs,cs) ++ go (l:ls,rs,cs)
  go (l:ls,  rs,c:cs) | l == c           = go (ls,rs,cs)
  go (  ls,r:rs,c:cs) |           r == c = go (ls,rs,cs)
  go (  [],  [],  [])                    = [True]
  go                _                    = [False]
