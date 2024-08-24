// --- Day 1: Trebuchet?! ---
//
// Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.
//
// You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.
//
// Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
//
// You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").
//
// As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.
//
// The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.
//
// For example:
//
// 1abc2
// pqr3stu8vwx
// a1b2c3d4e5f
// treb7uchet
//
// In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.
//
// Consider your entire calibration document. What is the sum of all of the calibration values?
//
// from: https://adventofcode.com/2023/day/1

import Foundation

let inputFileName = #filePath.replacingOccurrences(of: ".swift", with: "_input.txt")

let input = try! String(contentsOfFile: inputFileName)

// Part One

let calibrationDocument: [String] = input.split(separator: "\n").map(String.init)

let calibrationNumbers: [[Int]] = calibrationDocument.map { $0.lazy.compactMap(\.wholeNumberValue) }

let calibrationValues: [Int] = calibrationNumbers.lazy.compactMap { lineNumbers -> Int? in
	guard
		let firstNumber: Int = lineNumbers.lazy.first,
		let lastNumber: Int = lineNumbers.lazy.last
	else { return nil }

	return Int("\(firstNumber)\(lastNumber)")
}

let calibrationValuesSum: Int = calibrationValues.reduce(0, +)

print("Answer Part One - Sum of all calibration values:", calibrationValuesSum)

// --- Part Two ---
//
// Your calculation isn't quite right. It looks like some of the digits are actually spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".
//
// Equipped with this new information, you now need to find the real first and last digit on each line. For example:
//
// two1nine
// eightwothree
// abcone2threexyz
// xtwone3four
// 4nineeightseven2
// zoneight234
// 7pqrstsixteen
//
// In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.
//
// What is the sum of all of the calibration values?

let numberFormatter: NumberFormatter = {
	let formatter = NumberFormatter()
	formatter.locale = .init(identifier: "en-US")
	formatter.numberStyle = .spellOut
	return formatter
}()

let numberDigits: [Int] = Array(0...9)

let numberStrings: [String] = numberDigits.map(NSNumber.init).compactMap(numberFormatter.string)

let numberStringsToDigits: [String: Int] = Dictionary(uniqueKeysWithValues: zip(numberStrings, numberDigits))

let captureRegex: String = (numberDigits.compactMap(String.init) + numberStrings).joined(separator: "|")

let numberRegex: Regex = #/(1|2|3|4|5|6|7|8|9|zero|one|two|three|four|five|six|seven|eight|nine)/#

let tests: [String] = [
"two1nine",
"eightwothree",
"abcone2threexyz",
"xtwone3four",
"4nineeightseven2",
"zoneight234",
"7pqrstsixteen",
]

let calibrationValuesPartTwo: [Int] = calibrationDocument.compactMap { calibrationLine -> Int? in
	let ranges = calibrationLine.ranges(of: numberRegex)

	guard
		let firstMatchRange = ranges.first,
		let lastMatchRange = ranges.last
	else { return nil }

	let firstMatch: String = String(calibrationLine[firstMatchRange])
	let lastMatch: String = String(calibrationLine[lastMatchRange])

	let firstNumber: String = numberStrings.contains(firstMatch) ? String(numberStringsToDigits[firstMatch]!) : firstMatch

	let secondNumber: String = numberStrings.contains(lastMatch) ? String(numberStringsToDigits[lastMatch]!) : lastMatch

	return Int(firstNumber + secondNumber)
}

let calibrationValuesPartTwoSum = calibrationValuesPartTwo.reduce(0, +)

print("Answer Part Two - Sum of all calibration values:", calibrationValuesPartTwoSum)

