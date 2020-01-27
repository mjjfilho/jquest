//
//  ChallengePopUpViewController.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 26/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import UIKit

class ChallengePopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var statments = ["Your Face is Ugly","Morality can`t be found"]

    @IBOutlet weak var popupBg: UIView!
    @IBOutlet weak var statement: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var actualDialog = 0
    var challengeSelected: Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return statments.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as! ChallengeTableViewCell
           cell.statementChallengeLabel.text = statments[indexPath.row]
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: .saveChallenge, object: self)
        challengeSelected = indexPath.row
        
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "challengeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        
        popupBg.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
