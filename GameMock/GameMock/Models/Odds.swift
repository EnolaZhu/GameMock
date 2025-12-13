//
//  Odds.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import Foundation
import Combine

struct Odds: Codable {
	let matchID: Int
	let teamAOdds: Double
	let teamBOdds: Double
}
