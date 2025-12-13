//
//  MockDataService.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//
import Foundation
import Combine

//MARK: Actor is for data race
actor MockDataService {
	private var matches: [Match] = []
	private var oddsMap: [Int: Odds] = [:]
	
	func generateMockData() -> ([Match], [Odds]) {
		let teams = [
			("Eagles", "Tigers"), ("Dragons", "Lions"), ("Wolves", "Bears"),
			("Hawks", "Falcons"), ("Panthers", "Jaguars"), ("Sharks", "Dolphins"),
			("Bulls", "Rams"), ("Knights", "Warriors"), ("Giants", "Titans"),
			("Phoenix", "Ravens"), ("Cobras", "Vipers"), ("Thunder", "Lightning")
		]

		var matches: [Match] = []
		var odds: [Odds] = []
		let baseDate = Date()
		
		for i in 0..<100 {
			let teamPair = teams[i % teams.count]
			let timeOffset = TimeInterval((i / 10) * 3600) // Spread matches over hours
			let matchDate = baseDate.addingTimeInterval(timeOffset)
			
			let formatter = ISO8601DateFormatter()
			let match = Match(
				matchID: 1001 + i,
				teamA: "\(teamPair.0) \(i/12 + 1)",
				teamB: "\(teamPair.1) \(i/12 + 1)",
				startTime: formatter.string(from: matchDate)
			)
			matches.append(match)
			
			let odd = Odds(
				matchID: match.matchID,
				teamAOdds: Double.random(in: 1.5...3.0).rounded(toPlaces: 2),
				teamBOdds: Double.random(in: 1.5...3.0).rounded(toPlaces: 2)
			)
			odds.append(odd)
		}
		
		self.matches = matches
		for odd in odds {
			self.oddsMap[odd.matchID] = odd
		}
		
		return (matches, odds)
	}
	
	func generateRandomOddsUpdate() -> Odds? {
		guard !matches.isEmpty else { return nil }
		let randomMatch = matches.randomElement()!
		
		return Odds(
			matchID: randomMatch.matchID,
			teamAOdds: Double.random(in: 1.5...3.0).rounded(toPlaces: 2),
			teamBOdds: Double.random(in: 1.5...3.0).rounded(toPlaces: 2)
		)
	}
}
