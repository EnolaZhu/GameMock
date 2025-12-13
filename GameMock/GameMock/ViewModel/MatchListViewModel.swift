//
//  MatchListViewModel.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//
import Foundation
import Observation
import Combine

@MainActor
@Observable
final class MatchListViewModel {

	enum State {
		case idle
		case loading
		case loaded
		case error(String)
	}

	private(set) var state: State = .idle
	private(set) var matches: [MatchWithOdds] = []

	@ObservationIgnored
	private let repository: MatchRepositoryProtocol

	private var oddsTask: Task<Void, Never>?

	init(repository: MatchRepositoryProtocol) {
		self.repository = repository
	}

	convenience init() {
		self.init(repository: MatchRepository())
	}

	func load() async {
		state = .loading
		do {
			matches = await repository.fetchInitialData()
			state = .loaded
		} catch {
			state = .error(error.localizedDescription)
		}
	}

	func start() {
		oddsTask?.cancel()
		oddsTask = Task {
			for await odds in await repository.startOddsStream() {
				apply(odds)
			}
		}
	}

	func stop() {
		oddsTask?.cancel()
		Task { await repository.stopOddsStream() }
	}

	private func apply(_ odds: Odds) {
		guard let index = matches.firstIndex(where: { $0.match.matchID == odds.matchID }) else { return }
		matches[index].odds = odds
	}
}
