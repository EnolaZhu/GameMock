//
//  WebSocketSimulator.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//

import Foundation
import Combine

actor WebSocketSimulator {
	private var timer: Timer?
	private let dataService: MockDataService
	private var continuation: AsyncStream<Odds>.Continuation?
	
	init(dataService: MockDataService) {
		self.dataService = dataService
	}
	
	func startSimulation() -> AsyncStream<Odds> {
		AsyncStream { continuation in
			self.continuation = continuation
			
			Task {
				while !Task.isCancelled {
					// Simulate 10 updates per second
					for _ in 0..<10 {
						if let odds = await dataService.generateRandomOddsUpdate() {
							continuation.yield(odds)
						}
						try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
					}
				}
			}
		}
	}
	
	func stop() {
		continuation?.finish()
	}
}
