import Shuffled (isShuffled)

assert msg p = if p then putStrLn ("\tPassed: " ++ msg) else fail msg

runTestCase (msg,(x,y),w,expected) = do
    actual <- isShuffled (x,y) w
    assert msg (actual == expected)

main = do
    putStrLn "\nShuffledTest"
    contents <- readFile "test-cases.txt"
    let cases = read contents :: [(String,([Int],[Int]),[Int],Bool)]
    mapM_ runTestCase cases
    putStrLn "All tests pass\n"
