//
//  File.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 23/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import Foundation

class Assertion {
    enum state {
        
        case removable
        case editable
        case creator
        case cutscener
        
    }
    
    enum trigger {
        case howSo
        case proveIt
        case relevance
        case none
        
    }
    
    var id: Int?
    var phrase:String
    var howSo:[String]
    var howCharacter : [Int]
    var proveIt:[String]
    var proveCharacter: [Int]
    var relevance:[String]
    var relevCharacter: [Int]
    var state: state?
    var trigger: trigger?
    var loop: [String]?
    //loop serve tanto pra quando, o Current dialog acabar. Tanto quanto para os cutscenes,
    var loopCharacter: [Int]
    

    //Frase CRIADORA
    init(id: Int,
         phrase: String,
         howSo: [String],
         proveIt: [String],
         relevance: [String],
         state: state?,
         trigger: trigger?,
         howCharacter : [Int],
         proveCharacter: [Int],
         relevCharacter: [Int],
         Loop: [String]?,
         loopCharacter: [Int]) {
        
        self.id = id
        self.phrase = phrase
        self.howSo = howSo
        self.proveIt = proveIt
        self.relevance = relevance
        self.state = state
        self.trigger = trigger
        self.howCharacter = howCharacter
        self.proveCharacter = proveCharacter
        self.relevCharacter = relevCharacter
        self.loop = Loop
        self.loopCharacter = loopCharacter
        
    }
}
