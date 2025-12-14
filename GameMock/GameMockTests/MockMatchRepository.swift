//
//  MockMatchRepository.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/14.
//

import Foundation

final class MockMatchRepository: MatchRepositoryProtocol {

var initialData: [MatchWithOdds] = []
   private var continuation: AsyncStream<Odds>.Continuation?

   func fetchInitialData() async -> [MatchWithOdds] {
	   initialData
   }

   func startOddsStream() async -> AsyncStream<Odds> {
	   AsyncStream { continuation in
		   self.continuation = continuation
	   }
   }

   func stopOddsStream() async {
	   continuation?.finish()
   }

   func sendOdds(_ odds: Odds) {
	   continuation?.yield(odds)
   }
}

extension MatchWithOdds {
	static func mock(
		id: Int,
		startDate: Date = Date()
	) -> MatchWithOdds {
		MatchWithOdds(
			match: Match(
				matchID: id,
				teamA: "A",
				teamB: "B",
				startTime: ISO8601DateFormatter().string(from: startDate)
			),
			odds: Odds(
				matchID: id,
				teamAOdds: 1.5,
				teamBOdds: 2.0
			)
		)
	}
}
