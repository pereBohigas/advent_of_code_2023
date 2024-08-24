// --- Day 3: Gear Ratios ---
//
// You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.
//
// It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.
//
// "Aaah!"
//
// You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.
//
// The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.
//
// The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)
//
// Here is an example engine schematic:
//
// 467..114..
// ...*......
// ..35..633.
// ......#...
// 617*......
// .....+.58.
// ..592.....
// ......755.
// ...$.*....
// .664.598..
//
// In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.
//
// Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
//
//
// from: https://adventofcode.com/2023/day/3

import Foundation

print("Hello")

let inputFileName = #filePath.replacingOccurrences(of: ".swift", with: "_input.txt")

let input = try! String(contentsOfFile: inputFileName)

// Part One

let testData = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

let schematicStrings: [String] = testData.split(separator: "\n").map(String.init)

print(schematicStrings)

let partNumbers = schematicStrings.enumerated().map { lineNumber, schematicLine in
    let candidates = schematicLine.split(separator: ".")
    let symbolsSet = CharacterSet.symbols

    (UInt32.min ... UInt32.max).compactMap(UnicodeScalar.init).filter(symbolsSet.contains).map(String.init).forEach { print($0) }

    //print("symbols", symbolsSet.forEach(String.init))
    //print(schematicLine)

    let partNumbers = candidates
        .compactMap { candidate -> Substring? in
            //print("candidate ", candidate)
            //print("range ", candidate.rangeOfCharacter(from: symbolsSet))
            if let rangeOfSymbol = candidate.rangeOfCharacter(from: symbolsSet) {
                //print("Bingo")
                //print(candidate)
                //print(rangeOfSymbol)
                var mutableCandidate = candidate
                mutableCandidate.removeSubrange(rangeOfSymbol)
                return mutableCandidate
            } else if let rangeOfNumber = candidate.rangeOfCharacter(from: symbolsSet.inverted) {
                // let rangeOfSymbolsInOtherLineLowerBound = max(rangeOfNumber.lowerBound.distance(in: candidate) - 1, 0)
                // let rangeOfSymbolsInOtherLineUpperBound = min(rangeOfNumber.lowerBound.distance(in: candidate) + 1, schematicLine.count)
                // let rangeOfSymbolsInOtherLine = rangeOfSymbolsInOtherLineLowerBound...rangeOfSymbolsInOtherLineUpperBound
                //let lowerIndex = max(rangeOfNumber.lowerBound - 1, 0)
                //let higherIndex = min(schematicLine.lastIndex(of: String(candidate)) + 1, schematicLine.count - 1)

                if lineNumber - 1 >= 0 {
                    let lowerLine = schematicStrings[lineNumber - 1]
                    let lowerCharacters = lowerLine[rangeOfNumber]

                    if lowerCharacters.rangeOfCharacter(from: symbolsSet) != nil {
                        return candidate
                    }
                }

                if lineNumber + 1 < schematicStrings.count {
                    let higherLine = schematicStrings[lineNumber + 1]
                    let higherCharacters = higherLine[rangeOfNumber]

                    if higherCharacters.rangeOfCharacter(from: symbolsSet) != nil {
                        return candidate
                    }
                }
            }

            return nil
        }

    return partNumbers
}

//print(partNumbers)

// typealias Number = (value: Int, indexRange: Range<String.Index>)
//
// let numbers: [Int: [Number]] = .init(
//     uniqueKeysWithValues: schematicStrings.enumerated().map { lineNumber, schematicLine -> (Int, [Number]) in
//         let partNumberRegex: Regex<(Substring, Substring)> = #/(\d+)/#
//         let partNumberMatches = schematicLine.ranges(of: partNumberRegex)
//         let partNumbers = partNumberMatches.compactMap { Int(schematicLine[$0]) }
//
//         return (lineNumber, zip(partNumbers, partNumberMatches).map { ($0.0, $0.1) })
//     }
// )
//
// //print(numbers)
//
// let symbols: [Int: [Range<String.Index>]] = .init(
//     uniqueKeysWithValues: schematicStrings.enumerated().map { lineNumber, schematicLine in
//         let symbolsRegex: Regex<Substring> = #/[-!$%^&#*()_+|~=`{}\[\]:";'<>?,\/]/#
//         let symbolMatches = schematicLine.ranges(of: symbolsRegex)
//
//         return (lineNumber, symbolMatches)
//     }
// )
//
// //print(symbols)
//
// let partNumbers = numbers.compactMap { numbersInLine -> [Number]? in
//     guard
//         //let minimumSymbolsLine = symbols.keys.min(),
//         //let maximumSymbolsLine = symbols.keys.max(),
//         let symbolsInLine = symbols[numbersInLine.key]
//     else { return nil }
//
//     let schematicLine = schematicStrings[numbersInLine.key]
//
//     let partNumbersInLine = numbersInLine.value.filter { number in
//         print("Number range - ", schematicLine[number.indexRange])
//
//         return symbolsInLine.contains { symbolRange in
//             print("Symbol range - ", schematicLine[symbolRange])
//
//             return symbolRange.clamped(to: number.indexRange) == symbolRange
//         }
//     }
//
//     return partNumbersInLine
// }
//
// print(partNumbers)

// let partNumbers = numbers.filter {
//
// }

//print("Answer Part One - Sum of IDs of all possible games:", possibleGamesSum)

// --- Part Two ---
//
// The Elf says they've stopped producing snow because they aren't getting any water! He isn't sure why the water stopped; however, he can show you how to get to the water source to check it out for yourself. It's just up ahead!
//
// As you continue your walk, the Elf poses a second question: in each game you played, what is the fewest number of cubes of each color that could have been in the bag to make the game possible?
//
// Again consider the example games from earlier:
//
// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
// Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
// Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
// Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
//
//     In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
//     Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
//     Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
//     Game 4 required at least 14 red, 3 green, and 15 blue cubes.
//     Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
//
// The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together. The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these five powers produces the sum 2286.
//
// For each game, find the minimum set of cubes that must have been present. What is the sum of the power of these sets?

// let gamesMinimumSetOfCubes = games
//     .map {
//         ($0.id, $0.blueCubes.max() ?? 0, $0.greenCubes.max() ?? 0, $0.redCubes.max() ?? 0)
//     }
//
// let gamesSetOfCubesPower = gamesMinimumSetOfCubes
//     .map {
//         [$0.1, $0.2, $0.3].reduce(1, *)
//     }
//
// let gamesSetOfCubesPowerSum = gamesSetOfCubesPower.reduce(0, +)
//
// print("Answer Part Two - Sum of power of all minimum set of cubes:", gamesSetOfCubesPowerSum)

