//
//  Untitled.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import Foundation
import Combine

actor MatchRepository {
	private let dataService: MockDataService
	private let webSocketSimulator: WebSocketSimulator
	
	init() {
		self.dataService = MockDataService()
		self.webSocketSimulator = WebSocketSimulator(dataService: dataService)
	}
	
	func fetchInitialData() async -> [MatchWithOdds] {
		let (matches, odds) = await dataService.generateMockData()
		let oddsMap = Dictionary(uniqueKeysWithValues: odds.map { ($0.matchID, $0) })
		
		return matches.compactMap { match in
			guard let odd = oddsMap[match.matchID] else { return nil }
			return MatchWithOdds(match: match, odds: odd)
		}.sorted { $0.match.startDate < $1.match.startDate }
	}
	
	func startOddsStream() async -> AsyncStream<Odds> {
		await webSocketSimulator.startSimulation()
	}
	
	func stopOddsStream() async {
		await webSocketSimulator.stop()
	}
}
