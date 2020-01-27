//
//  challengeTableViewCell.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 26/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var statementChallengeLabel: UILabel!
    @IBOutlet weak var descriptionChallengeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
