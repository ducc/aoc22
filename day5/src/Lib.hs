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
    
    -- Find where the empty line is after the drawing but before instructions
    let dividingLineIndex = findEmptyLine inputLines

    -- Split the lines into arrays for the drawing and the instructions
    let drawing = take (dividingLineIndex) inputLines
    let instructions = drop (dividingLineIndex + 1) inputLines

    -- ["1ZN", "2MCD", "3P"]
    let temp = drawingToArrays drawing

    -- [(1,"ZN"),(2,"MCD"),(3,"P")]
    let stacks = map (\c -> (read [head c], tail c)) temp

    -- (3, 1, 3)
    let parsedInstructions = map (parseInstruction) instructions

    -- [(1, "M"), (2, "C"), (3, "PZND")]
    let ranInstructions = processAllInstructions stacks parsedInstructions

    -- MCD
    let output = topOfStacks ranInstructions

    putStrLn $ output

drawingToArrays :: [[Char]] -> [[Char]]
drawingToArrays drawing = 
    filter (\c -> (length c) /= 0) 
    $ lines 
    $ filter (\c -> c /= ' ' && c /= '[' && c /= ']') 
    $ intercalate "\n" 
    $ transpose 
    $ reverse 
    $ drawing

findEmptyLine :: [String] -> Int
findEmptyLine input = case "" `elemIndex` input of 
    Just n -> n
    Nothing -> error "invalid input, could not find dividing line"

parseThing :: (String, String) -> (Int, String)
parseThing (number, crates) = (read number, crates)

-- move 3 from 1 to 3 -> (3, 1, 3)
parseInstruction :: String -> (Int, Int, Int)
parseInstruction instruction = extractInstructionParts $ splitOn " " instruction

-- ["move", "3", "from", "1", "to", "3"] -> (3, 1, 3)
extractInstructionParts :: [String] -> (Int, Int, Int)
extractInstructionParts [_, quantity, _, from, _, to] = (read quantity, read from, read to)
extractInstructionParts e = error $ "invalid input: " ++ show e

processAllInstructions :: [(Int, String)] -> [(Int, Int, Int)] -> [(Int, String)]
processAllInstructions stacks [] = stacks
processAllInstructions stacks instructions = do
    let nextInstruction = head instructions
    let remainingInstructions = tail instructions

    let output = processInstruction stacks nextInstruction
    processAllInstructions output remainingInstructions

processInstruction :: [(Int, String)] -> (Int, Int, Int) -> [(Int, String)]
processInstruction stacks (quantity, from, to) = do
    let (_, fromStack) = stacks !! (from-1)
    let (_, toStack) = stacks !! (to-1)

    let taken = reverse $ drop quantity $ reverse fromStack
    
    let itemsToMove = take quantity $ reverse fromStack
    let appended = toStack ++ itemsToMove

    let updatedStacks = stacks & element (from-1) .~ (from, taken)
    let updatedStacks2 = updatedStacks & element (to-1) .~ (to, appended)

    updatedStacks2

topOfStacks :: [(Int, String)] -> String
topOfStacks stacks = map (\x -> head $ reverse $ snd x) stacks
