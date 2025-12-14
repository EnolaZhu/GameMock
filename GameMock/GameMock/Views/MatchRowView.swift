//
//  MatchRowView.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import SwiftUI
import Combine

struct MatchRowView: View {
	@State private var isFlashing = false
	@State private var currentTime = Date()

	let matchWithOdds: MatchWithOdds
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	init(matchWithOdds: MatchWithOdds) {
		self.matchWithOdds = matchWithOdds
		print("Enola Row init: \(matchWithOdds.match.matchID)")
	}
	
	var body: some View {
		let _ = print("Enola redraw row \(matchWithOdds.match.matchID)")

		VStack(spacing: 12) {
			// Match Header
			HStack {
				VStack(alignment: .leading, spacing: 4) {
					Text("Match #\(matchWithOdds.match.matchID)")
						.font(.caption)
						.foregroundColor(.secondary)
					
					HStack(spacing: 8) {
						// 比賽開始時間
						HStack(spacing: 4) {
							Image(systemName: "calendar")
								.font(.caption2)
							Text(formattedMatchDate)
								.font(.caption2)
						}
						
						Text("•")
							.font(.caption2)
						
						// 賠率更新時間
						HStack(spacing: 4) {
							Image(systemName: "arrow.clockwise")
								.font(.caption2)
							Text(formattedUpdateTime)
								.font(.caption2)
						}
						.foregroundColor(.green)
					}
					.foregroundColor(.secondary)
				}
				Spacer()
			}
			
			// Teams and Odds
			HStack(spacing: 16) {
				// Team A
				VStack(alignment: .leading, spacing: 8) {
					Text(matchWithOdds.match.teamA)
						.font(.headline)
						.lineLimit(1)
					
					HStack {
						Text("Odds:")
							.font(.caption)
							.foregroundColor(.secondary)
						Text(String(format: "%.2f", matchWithOdds.odds.teamAOdds))
							.font(.title3)
							.fontWeight(.bold)
							.foregroundColor(.blue)
					}
					.padding(.horizontal, 12)
					.padding(.vertical, 6)
					.background(Color.blue.opacity(0.1))
					.cornerRadius(8)
				}
				
				Spacer()
				
				Text("VS")
					.font(.caption)
					.foregroundColor(.secondary)
					.padding(.horizontal, 8)
				
				Spacer()
				
				// Team B
				VStack(alignment: .trailing, spacing: 8) {
					Text(matchWithOdds.match.teamB)
						.font(.headline)
						.lineLimit(1)
					
					HStack {
						Text(String(format: "%.2f", matchWithOdds.odds.teamBOdds))
							.font(.title3)
							.fontWeight(.bold)
							.foregroundColor(.green)
						Text("Odds:")
							.font(.caption)
							.foregroundColor(.secondary)
					}
					.padding(.horizontal, 12)
					.padding(.vertical, 6)
					.background(Color.green.opacity(0.1))
					.cornerRadius(8)
				}
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(Color(uiColor: .secondarySystemBackground))
				.overlay(
					RoundedRectangle(cornerRadius: 12)
						.stroke(isFlashing ? Color.orange : Color.clear, lineWidth: 2)
				)
		)
		.onReceive(timer) { time in
			currentTime = time
		}
		.onChange(of: matchWithOdds.odds.teamAOdds) { _, _ in
			flashAnimation()
		}
		.onChange(of: matchWithOdds.odds.teamBOdds) { _, _ in
			flashAnimation()
		}
	}
	
	private var formattedMatchDate: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, HH:mm"
		return formatter.string(from: matchWithOdds.match.startDate)
	}
	
	private var formattedUpdateTime: String {
		let interval = currentTime.timeIntervalSince(matchWithOdds.lastUpdateTime)
		
		if interval < 60 {
			return "\(Int(interval))s ago"
		} else if interval < 3600 {
			return "\(Int(interval / 60))m ago"
		} else {
			return "\(Int(interval / 3600))h ago"
		}
	}
	
	private func flashAnimation() {
		isFlashing = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			isFlashing = false
		}
	}
}
