//
//  ContentView.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import SwiftUI

struct ContentView: View {
	@State private var viewModel: MatchListViewModel

	init(viewModel: MatchListViewModel) {
		_viewModel = State(initialValue: viewModel)
	}
	
	var body: some View {
		NavigationView {
			Group {
				switch viewModel.state {
				case .idle:
					Color.clear
						.onAppear {
							Task {
								await viewModel.load()
								viewModel.start()
							}
						}
					
				case .loading:
					VStack(spacing: 16) {
						ProgressView()
							.scaleEffect(1.5)
						Text("Loading matches...")
							.font(.headline)
							.foregroundColor(.secondary)
					}
					
				case .loaded:
					ScrollView {
						LazyVStack(spacing: 12) {
							ForEach(viewModel.matches) { matchWithOdds in
								MatchRowView(matchWithOdds: matchWithOdds)
									.id(MatchCellIdentity(
										matchID: matchWithOdds.match.matchID,
										teamAOdds: matchWithOdds.odds.teamAOdds,
										teamBOdds: matchWithOdds.odds.teamBOdds
									))
							}
						}
						.padding()
					}
					.refreshable {
						await viewModel.load()
					}
					
				case .error(let message):
					VStack(spacing: 20) {
						Image(systemName: "exclamationmark.triangle.fill")
							.font(.system(size: 60))
							.foregroundColor(.red)
						
						Text("Error")
							.font(.title2)
							.fontWeight(.bold)
						
						Text(message)
							.font(.body)
							.foregroundColor(.secondary)
							.multilineTextAlignment(.center)
							.padding(.horizontal)
						
						Button {
							Task {
								await viewModel.load()
								viewModel.start()
							}
						} label: {
							Label("Retry", systemImage: "arrow.clockwise")
								.font(.headline)
						}
						.buttonStyle(.borderedProminent)
						.controlSize(.large)
					}
					.padding()
				}
			}
			.navigationTitle("Live Match Odds")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					HStack(spacing: 6) {
						if case .loaded = viewModel.state {
							Circle()
								.fill(Color.green)
								.frame(width: 8, height: 8)
							Text("Live")
								.font(.caption)
								.foregroundColor(.secondary)
						}
					}
				}
			}
		}
		.onDisappear {
			viewModel.stop()
		}
	}
}
