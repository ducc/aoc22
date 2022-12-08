module Lib
    ( day3
    ) where

import Data.Char (ord, isLower)

day3 :: IO ()
day3 = do
    contents <- readFile "input.txt"
    let x = map rucksackPriority $ lines contents
    putStrLn $ show $ sum x

rucksackPriority :: String -> Int
rucksackPriority line = do
    -- Get the middle of the line
    let halfIndex = (length line) `div` 2

    -- Split the line into 2 equal parts
    let half1 = take halfIndex line
    let half2 = drop halfIndex line

    -- Find common items
    let commonItems = filter (\x -> x `elem` half1) half2

    -- Pick the first common item
    let item = head commonItems

    -- Calculate the priority of the common item
    toPriority item

toPriority :: Char -> Int
toPriority c = if isLower c then ((ord c) - 96) else ((ord c) - 38)
