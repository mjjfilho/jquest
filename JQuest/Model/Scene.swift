//
//  Singleton.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 22/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import Foundation
import UIKit


class Scene {
    
    var theme : String
    var character : String
    var assertions :  [Assertion]
    var background : UIImage?

    init (theme: String,
          character: String,
          assertions: [Assertion],
          background: UIImage?) {
        
        self.theme = theme
        self.character = character
        self.assertions = assertions
        self.background = background
    }

    
}


