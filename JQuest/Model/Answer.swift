//
//  Answer.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 27/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import Foundation

public struct Answer {
    var finding: String
    var contradiction: String
    init(_ findings: String,_ contradiction: String) {
        self.contradiction  = contradiction
        self.finding = findings
    }
}
