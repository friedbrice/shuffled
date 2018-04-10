import Shuffled (isShuffled)

assert msg p = if p then putStrLn ("\tPassed: " ++ msg) else fail msg

testCase (msg,(left,right),combined,expected) =
  assert msg (isShuffled (left,right) combined == expected)

main = do
  putStrLn "\nShuffledTest"
  contents <- readFile "test-cases.txt"
  let cases = read contents :: [(String,([Int],[Int]),[Int],Bool)]
  mapM_ testCase cases
  putStrLn "All tests pass\n"
