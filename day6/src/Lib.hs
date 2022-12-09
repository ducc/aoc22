module Lib
    ( day6
    ) where

import Data.List (nub)

day6 :: IO ()
day6 = do
    contents <- readFile "input.txt"
    putStrLn $ show $ solve contents 0 []

solve :: String -> Int -> String -> Int
solve input counter buf = 
    if length (nub buf) == 4 
        then counter
        else do
            let val = take 1 input
            let buf2 = buf ++ val

            let buf3 = if length buf2 == 5 
                then tail buf2
                else buf2

            solve (tail input) (counter + 1) buf3

