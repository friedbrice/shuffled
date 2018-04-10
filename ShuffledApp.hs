import Shuffled (isShuffled)

main = do
  input <- getContents
  let l:r:c:_ = fmap words (lines input)
  print (isShuffled (l,r) c)
