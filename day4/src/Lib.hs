module Lib
    ( day4
    ) where

import Data.List.Split

day4 :: IO ()
day4 = do
    contents <- readFile "input.txt"

    -- Parse each line into 2 arrays, e.g. [[1, 2], [3, 4]]
    let elfPairs = map parseLine $ lines contents

    -- Find pairs which overlap
    let together = map workingTogether elfPairs

    -- Convert booleans to ints, then sum them to get a count of overlapping pairs
    let count = sum $ map (fromEnum) together
    
    putStrLn $ show count

parseLine :: String -> [[Int]]
parseLine line = map splitAssignments $ splitOn "," line

splitAssignments :: String -> [Int]
splitAssignments assignments = map read $ splitOn "-" assignments

workingTogether :: [[Int]] -> Bool
workingTogether [[first, second], [third, fourth]] = 
    first >= third && second <= fourth || 
    third >= first && fourth <= second
workingTogether a = error $ "invalid input " ++ show a