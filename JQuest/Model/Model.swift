//
//  Model.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 22/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    static let shared = Model()
    
    var scenes = [Scene]()
    
    private init () {
        
        var myAssertions:[Assertion] = [
            Assertion(
                phrase: "Esta frase deve ser alterada pelo howSo",
                uptadedPhrase: String("Esta frase já foi alterada."),
                howSo: ["dialogo","dialogo"],
                proveIt: ["Dialogo", "Dialogo"],
                relevance: ["Dialogo"],
                state: Assertion.state.editable,
                trigger: Assertion.trigger.howSo),
            
            Assertion(
                id: 1,
                phrase: "Esta frase deve criar uma nova frase pelo proveIt",
                uptadedPhrase: nil ,
                howSo: ["dialogo","dialogo"],
                proveIt: ["Dialogo", "Dialogo"],
                relevance: ["Dialogo"],
                state: Assertion.state.creator,
                trigger: Assertion.trigger.proveIt),
            
            Assertion(
                phrase: "Esta frase deve ser removida pelo relevance",
                uptadedPhrase: nil,
                howSo: ["dialogo","dialogo"],
                proveIt: ["Dialogo", "Dialogo"],
                relevance: ["Dialogo"],
                state: Assertion.state.removable,
                trigger: Assertion.trigger.relevance),
            
            Assertion(
                phrase: "Esta frase deve permanecer inalterada",
                uptadedPhrase: nil,
                howSo: ["dialogo","dialogo"],
                proveIt: ["Dialogo", "Dialogo"],
                relevance: ["Dialogo"],
                state: nil,
                trigger: Assertion.trigger.none),
            
        ]
        
        
        scenes = [Scene(
            theme: "COMPRE!!",
            character: "Vendendor",
            assertions: myAssertions,
            background: nil)]
    }
}
