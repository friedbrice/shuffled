import Shuffled (isShuffled)

main = do
    input <- getContents
    let x:y:w:_ = fmap words (lines input)
    shuffled <- isShuffled (x,y) w
    print shuffled
