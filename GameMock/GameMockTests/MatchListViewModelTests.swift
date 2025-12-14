//
//  GameMockTests.swift
//  GameMockTests
//
//  Created by Enola Zhu on 2025/12/13.
//

import Testing
@testable import GameMock

@MainActor
struct MatchListViewModelTests {

	@Test
	func loadSuccess() async {
		let repository = MockMatchRepository()
		repository.initialData = [
			.mock(id: 1),
			.mock(id: 2)
		]

		let viewModel = MatchListViewModel(repository: repository)

		await viewModel.load()

		#expect(viewModel.state == .loaded)
		#expect(viewModel.matches.count == 2)
		#expect(viewModel.matches.first?.match.matchID == 1)
	}
	
	@Test
	func oddsUpdate() async {
		let repository = MockMatchRepository()
		repository.initialData = [.mock(id: 1)]

		let viewModel = MatchListViewModel(repository: repository)
		await viewModel.load()
		viewModel.start()

		let newOdds = Odds(
			matchID: 1,
			teamAOdds: 2.5,
			teamBOdds: 1.6
		)

		repository.sendOdds(newOdds)

		try? await Task.sleep(nanoseconds: 60_000_000)

		#expect(viewModel.matches.first?.odds.teamAOdds == 2.5)
		#expect(viewModel.matches.first?.lastUpdateTime != nil)
	}

	@Test
	func stopStopsReceivingOdds() async {
		let repository = MockMatchRepository()
		repository.initialData = [.mock(id: 1)]

		let viewModel = MatchListViewModel(repository: repository)
		await viewModel.load()
		viewModel.start()

		viewModel.stop()

		repository.sendOdds(
			Odds(matchID: 1, teamAOdds: 9.9, teamBOdds: 9.9)
		)

		try? await Task.sleep(nanoseconds: 60_000_000)

		#expect(viewModel.matches.first?.odds.teamAOdds != 9.9)
	}

}

