//
//  Match.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import Foundation
import Combine

struct Match: Identifiable, Codable {
	let matchID: Int
	let teamA: String
	let teamB: String
	let startTime: String
	
	var id: Int { matchID }
	
	nonisolated var startDate: Date {
		let formatter = ISO8601DateFormatter()
		return formatter.date(from: startTime) ?? Date()
	}
}
