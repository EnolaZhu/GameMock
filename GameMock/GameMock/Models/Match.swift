//
//  Match.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import Foundation
import Combine

// MARK: - Models
struct Match: Identifiable, Codable {
	let matchID: Int
	let teamA: String
	let teamB: String
	let startTime: String
	
	var id: Int { matchID }
	
	var startDate: Date {
		let formatter = ISO8601DateFormatter()
		return formatter.date(from: startTime) ?? Date()
	}
}

struct Odds: Codable {
	let matchID: Int
	let teamAOdds: Double
	let teamBOdds: Double
}

struct MatchWithOdds: Identifiable {
	let match: Match
	var odds: Odds
	
	var id: Int { match.matchID }
}
