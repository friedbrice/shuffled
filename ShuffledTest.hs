import Shuffled (isShuffledConcurrent)

assert :: String -> Bool -> IO ()
assert msg p = if p then putStrLn ("\tPassed: " ++ msg) else fail msg

runTestCase :: (String,([Int],[Int]),[Int],Bool) -> IO ()
runTestCase (msg,(l,r),c,expected) = do
  actual <- isShuffledConcurrent (l,r) c
  assert msg (actual == expected)

main :: IO ()
main = do
  putStrLn "\nShuffledTest"
  contents <- readFile "test-cases.txt"
  let cases = read contents :: [(String,([Int],[Int]),[Int],Bool)]
  mapM_ runTestCase cases
  putStrLn "All tests pass\n"
