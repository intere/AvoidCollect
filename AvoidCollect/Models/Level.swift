//
//  Level.swift
//  AvoidCollect
//
//  Created by Internicola, Eric on 2/25/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import Foundation

class Level {
    var number: Int = 1
    var squaresToCollect: Int?
    var circlesToDodge: Int = 30
    var circleSpeed = 4.0
    var squareSpeed = 3.0
    var circleTimer = 1.0
    var squareTimer = 1.5

    // TODO: Color Scheme
    let baseCircleSpeed = 3.0
    let baseSquareSpeed = 2.0

}


// MARK: - Factory Methods
extension Level {
    // TODO: make the levels work a bit differently - perhaps stepwise (steps 1-3 are an increase in the number of avoid circles, and step 4 is a speed increase?
    class func createLevel(levelNumber: Int = 1) -> Level {
        let level = Level()
        level.number = levelNumber
        level.circlesToDodge = 3 * levelNumber * 10 / 2
        level.squareSpeed = max(1.0, 3.0 - (0.1 * Double(levelNumber)))
        level.circleSpeed = max(1.0, 4.0 - (0.1 * Double(levelNumber)))
        level.circleTimer = max(0.1, 1.0 - (0.03 * Double(levelNumber)))
        level.squareTimer = max(0.1, 1.5 - (0.03 * Double(levelNumber)))

        return level
    }
}

