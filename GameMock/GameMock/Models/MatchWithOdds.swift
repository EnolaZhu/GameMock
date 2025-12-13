//
//  MatchWithOdds.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import Foundation
import Combine

struct MatchWithOdds: Identifiable {
	let match: Match
	var odds: Odds
	
	var id: Int { match.matchID }
}
