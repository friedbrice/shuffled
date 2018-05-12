import Shuffled (isShuffled)

assert :: String -> Bool -> IO ()
assert msg p = if p then putStrLn ("\tPassed: " ++ msg) else fail msg

runTestCase :: (String,([Int],[Int]),[Int],Bool) -> IO ()
runTestCase (msg,(x,y),w,expected) = do
    actual <- isShuffled (x,y) w
    assert msg (actual == expected)

main :: IO ()
main = do
    putStrLn "\nShuffledTest"
    contents <- readFile "test-cases.txt"
    let cases = read contents :: [(String,([Int],[Int]),[Int],Bool)]
    mapM_ runTestCase cases
    putStrLn "All tests pass\n"
