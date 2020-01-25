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
        
    }
    
    enum trigger {
        case howSo
        case proveIt
        case relevance
        case none
        
    }
    
    var id: Int?
    var phrase:String
    var uptadedPhrase: String?
    var howSo:[String]
    var proveIt:[String]
    var relevance:[String]
    var state: state?
    var trigger: trigger?
    var seed: Int?
    
    init(
        //Construtor para frase simples
        phrase: String,
        howSo: [String],
        proveIt: [String],
        relevance: [String]) {
        
        self.id = nil
        self.phrase = phrase
        self.howSo = howSo
        self.proveIt = proveIt
        self.relevance = relevance
        self.state = .removable
        self.trigger = Assertion.trigger.none
        
    }
    //Frase CRIADORA
    init(id: Int,
         phrase: String,
         uptadedPhrase: String?,
         howSo: [String],
         proveIt: [String],
         relevance: [String],
         state: state?,
         trigger: trigger?) {
        
        self.id = id
        self.phrase = phrase
        self.uptadedPhrase = uptadedPhrase
        self.howSo = howSo
        self.proveIt = proveIt
        self.relevance = relevance
        self.state = state
        self.trigger = trigger
        
    }
    //Frase Dinamica
    init(phrase: String,
         uptadedPhrase: String?,
         howSo: [String],
         proveIt: [String],
         relevance: [String],
         state: state?,
         trigger: trigger?) {
        
        self.id = nil
        self.phrase = phrase
        self.uptadedPhrase = uptadedPhrase
        self.howSo = howSo
        self.proveIt = proveIt
        self.relevance = relevance
        self.state = state
        self.trigger = trigger
        
    }
}
