//
//  ViewController.swift
//  JQuest
//
//  Created by Mateus J. J. Paulo Filho on 21/01/20.
//  Copyright © 2020 Mateus J. J. Paulo Filho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dialogLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    
    @IBOutlet weak var actionButton0: UIButton!
    @IBOutlet weak var actionButton1: UIButton!
    @IBOutlet weak var actionButton2: UIButton!
    @IBOutlet weak var actionButton3: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    
    var actualScene:Scene!
    var sentences: [String] = []
    var actualDialog: Int = 0
    
    enum State{
        case normal
        case questioning
        case challenging
        case chatting
    }
    enum Button{
        case howSo
        case proveIt
        case relevance
    }
    
    var currentState = State.normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actualScene =  Model.shared.scenes[0]
        
        for assertion in actualScene.assertions {
                sentences.append(assertion.phrase)
        }
        
        themeLabel.text = "Tema: \"\(actualScene.theme)\""
        characterLabel.text = actualScene.character
        dialogLabel.text = sentences[actualDialog]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if currentState == .normal  {
            if actualDialog > 0 {
                actualDialog -=  1
                updateText()
            }
            
        } else if currentState == .questioning {
            runDialog()
            checkChanges(Button.howSo)
            changeBack()
            updateText()
        }
    }
    
    @IBAction func fwdButton(_ sender: UIButton) {
        if currentState == .normal{
            
            if actualDialog < sentences.count-1  {
                actualDialog += 1
                updateText()
            }
            
        } else if currentState == .questioning{
            runDialog()
            changeBack()
            checkChanges(Button.proveIt)
            updateText()
            
        }
    }
    
    @IBAction func questionButton(_ sender: UIButton) {
        
        if currentState == .normal {
            changeButton()
            
        } else if currentState == .questioning{
            checkChanges(Button.relevance)
            changeBack()
            updateText()
        }
    }
    
    @IBAction func challengeButton(_ sender: UIButton) {
        
        if currentState == .normal {
        } else if currentState == .questioning  {
            changeBack()
        }
    }
    
    func updateText() {
        
        themeLabel.text = "Tema: \"\(actualScene.theme)\""
        characterLabel.text = actualScene.character
        dialogLabel.text = sentences[actualDialog]
        
    }
    
    func changeButton() {
        currentState = .questioning
        actionButton0.setTitle("\"Como assim?\"", for: UIControl.State.normal)
        actionButton1.setTitle("\"Prove!\"", for: UIControl.State.normal)
        actionButton2.setTitle("\"É relevante?\"", for: UIControl.State.normal)
        actionButton3.setTitle("\"Deixa quieto\"", for: UIControl.State.normal)
    }
    
    func changeBack() {
        currentState = .normal
        actionButton0.setTitle("Back", for: UIControl.State.normal)
        actionButton1.setTitle("Foward", for: UIControl.State.normal)
        actionButton2.setTitle("Question", for: UIControl.State.normal)
        actionButton3.setTitle("Challenge", for: UIControl.State.normal)
    }
    
    func runDialog() {
//        currentState = .chatting
//        actionButton0.isHidden = true
//        actionButton1.isHidden = true
//        actionButton2.isHidden = true
//        actionButton3.isHidden = true
    }
    func createNewAssertion(_ Id:Int) -> Assertion {
        print("frase adicionada na sentença")
        return Assertion(phrase: "Está frase foi adicionada", howSo: ["",""], proveIt: ["",""], relevance: ["",""])
    }
    func positioningAssertion() {
        actualScene.assertions[actualDialog].state = .none
        actualScene.assertions.insert(createNewAssertion(actualScene.assertions[actualDialog].id!), at: actualDialog)
        sentences.insert(actualScene.assertions[actualDialog].phrase, at: actualDialog)
        
    }
    
    func checkChanges(_ sender:Button) {
        switch actualScene.assertions[actualDialog].state {
        case .editable:
            
            switch actualScene.assertions[actualDialog].trigger {
            case .howSo:
                if sender == Button.howSo {
                    sentences[actualDialog] = actualScene.assertions[actualDialog].uptadedPhrase!
                }
            case .proveIt:
                if sender == Button.proveIt {
                    sentences[actualDialog] = actualScene.assertions[actualDialog].uptadedPhrase!
                }
            case .relevance:
                if sender == Button.relevance {
                    sentences[actualDialog] = actualScene.assertions[actualDialog].uptadedPhrase!
                }
            default: break
                
            }
            
        case .removable:
            switch actualScene.assertions[actualDialog].trigger {
            case .howSo: if sender == Button.howSo {
                sentences.remove(at: actualDialog)
                }
            case .proveIt: if sender == Button.proveIt {
                sentences.remove(at: actualDialog)
                }
            case .relevance: if sender == Button.relevance {
                sentences.remove(at: actualDialog)
                }
                
            default:
                break
                
            }
            
        case .creator:
            switch actualScene.assertions[actualDialog].trigger {
            case .howSo: if sender == Button.howSo{
                positioningAssertion()
                }
            case .proveIt: if sender == Button.proveIt{
                positioningAssertion()
                }
            case .relevance: if sender == Button.relevance{
               positioningAssertion()
                }
            default:
                break
            }
            
        default: break
            
        }
    }
    
}

