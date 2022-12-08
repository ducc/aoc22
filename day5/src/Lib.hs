module Lib
    ( day5
    ) where

import Data.List (elemIndex, transpose, intercalate)
import Data.List.Split
import Control.Lens

day5 :: IO ()
day5 = do
    contents <- readFile "input.txt"
    let inputLines = lines contents
    
    let dividingLineIndex = findEmptyLine inputLines
    let drawing = take (dividingLineIndex) inputLines
    let instructions = drop (dividingLineIndex + 1) inputLines

    let temp = filter (\c -> c /= '±') $ map (\c -> if (c==' ' || c=='[' || c==']') then '±'; else c) $ intercalate "\n" $ transpose $ reverse drawing
    let temp2 = filter (\c -> (length c) /= 0) $ lines $ intercalate "" $ splitOn "" $ temp
    let temp3 = map (\c -> ([head c], tail c)) temp2

    -- [(1,"ZN"),(2,"MCD"),(3,"P")]
    let stacks = map parseThing temp3

    -- (3, 1, 3)
    let parsedInstructions = map (parseInstruction) instructions

    putStrLn $ topOfStacks $ processAllInstructions stacks parsedInstructions

findEmptyLine :: [String] -> Int
findEmptyLine input = case "" `elemIndex` input of 
    Just n -> n
    Nothing -> error "invalid input, could not find dividing line"

parseThing :: (String, String) -> (Int, String)
parseThing (number, crates) = (read number, crates)

-- move 3 from 1 to 3 -> (3, 1, 3)
parseInstruction :: String -> (Int, Int, Int)
parseInstruction instruction = do 
    let trimmed = drop 1 $ splitOn " " instruction
    let quantity = read (head $ trimmed) :: Int
    let from = read (head $ drop 2 $ trimmed) :: Int
    let to = read (head $ drop 4 $ trimmed) :: Int
    (quantity, from, to)

processAllInstructions :: [(Int, String)] -> [(Int, Int, Int)] -> [(Int, String)]
processAllInstructions stacks instructions = do
    if length instructions == 0
        then stacks
        else do
            let nextInstruction = head instructions
            let remainingInstructions = tail instructions

            let output = processInstruction stacks nextInstruction
            processAllInstructions output remainingInstructions



processInstruction :: [(Int, String)] -> (Int, Int, Int) -> [(Int, String)]
processInstruction stacks (quantity, from, to) = do
    let fromStack = getStackByIndex stacks from
    let toStack = getStackByIndex stacks to

    let taken = reverse $ drop quantity $ reverse fromStack
    
    let itemsToMove = take quantity $ reverse fromStack
    let appended = toStack ++ itemsToMove

    let updatedStacks = stacks & element (from-1) .~ (from, taken)
    let updatedStacks2 = updatedStacks & element (to-1) .~ (to, appended)

    updatedStacks2

getStackByIndex :: [(Int, String)] -> Int -> String
getStackByIndex stacks idx = do
    let (_, stack) = stacks!!(idx-1)
    stack

secondElementInTuple :: (a, b) -> b
secondElementInTuple (_, b) = b

topOfStacks :: [(Int, String)] -> String
topOfStacks stacks = do 
    map (\x -> head $ reverse $ secondElementInTuple x) stacks
