//
//  Double+Extension.swift
//  GameMock
//
//  Created by Enola Zhu on 2025/12/13.
//
import Foundation

extension Double {
	nonisolated func rounded(toPlaces places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}
