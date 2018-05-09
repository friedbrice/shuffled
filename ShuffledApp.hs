import Shuffled (isShuffledConcurrent)

main :: IO ()
main = do
  input <- getContents
  let l:r:c:_ = fmap words (lines input)
  shuffled <- isShuffledConcurrent (l,r) c
  print shuffled
