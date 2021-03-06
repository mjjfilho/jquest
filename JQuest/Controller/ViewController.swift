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
    var assertions: [Assertion] = []
    var sentences: [String] = []
    var actualDialog: Int = 0
    var lastDialog: Int = 0
    var auxStringArray: [String] = []
    var actualButton: Button = .none
    var currentState = State.normal
    var challengeSelected = 0
    
    enum State {
        
        case normal
        case questioning
        case challenging
        case dialoging
    }
    enum Button {
        
        case howSo
        case proveIt
        case relevance
        case none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .saveChallenge, object: nil, queue: nil) {
            (notification) in
            let challengeVC = notification.object as! ChallengePopUpViewController
            let challengeSelected: Int = challengeVC.challengeSelected
            self.challengeAccepted(contradiction: challengeVC.statments[challengeSelected], finding: self.sentences[self.actualDialog],scene: self.actualScene!)
            
            
            }
        
        actualScene =  Scene(
        theme: "COMPRE!!",
        character: "Vendendor",
        assertions: [
            
            Assertion(
                phrase: "Esta frase deve ser alterada pelo howSo",
                uptadedPhrase: String("Esta frase já foi alterada."),
                howSo: ["1 dialogo do HowSo da 1 assertion","2 dialogo do HowSo da primeira assertion"],
                proveIt: ["1 dialogo do proveIt"],
                relevance: ["Dialogo"],
                state: Assertion.state.editable,
                trigger: Assertion.trigger.howSo),
            
            Assertion(
                id: 1,
                phrase: "Esta frase deve criar uma nova frase pelo proveIt",
                uptadedPhrase: nil ,
                howSo: ["1 dialogo do HowSo da 2 assertion","2 dialogo do HowSo da 2 assertio"],
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
            
        ],
        
        background: nil,
        answer: Answer("",
                       ""))
        assertions = actualScene.assertions
        themeLabel.text = "Tema: \"\(actualScene.theme)\""
        characterLabel.text = actualScene.character
        
        for assertion in assertions {
            sentences.append(assertion.phrase)
        }
        
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
            currentState = .dialoging
            changeBack()
            runDialog(.howSo)
            updateText()
        }
    }
    
    @IBAction func fwdButton(_ sender: UIButton) {
        switch currentState {
        case .normal:
            if actualDialog < sentences.count-1  {
                actualDialog += 1
                updateText()
            }
        case .questioning:
            changeBack()
            runDialog(Button.proveIt)
            updateText()
            
        case .dialoging:
            if actualDialog == sentences.count-1 {
                stopDialog()
            } else if actualDialog < sentences.count-1 {
                actualDialog += 1
                updateText()
            }
        default:
            print("Error")
        }
    }
    
    @IBAction func questionButton(_ sender: UIButton) {
        
        if currentState == .normal {
            changeButton()
            
        } else if currentState == .questioning {
            runDialog(.relevance)
            updateText()
        }
    }
    
    @IBAction func challengeButton(_ sender: UIButton) {
        
        if currentState == .normal {
            
        } else if currentState == .questioning  {
            changeBack()
        }
    }
    func challengeAccepted(contradiction: String, finding: String, scene: Scene ) {
        if contradiction == scene.answer.contradiction && finding ==  scene.answer.finding {
            print("game over")
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
    
    func runDialog(_ sender:Button) {
        auxStringArray = sentences
        lastDialog = actualDialog
        actualDialog = 0
        actualButton = sender
        switch sender {
        case Button.howSo:
            updateText()
            sentences = assertions[lastDialog].howSo
        case Button.proveIt:
            updateText()
            sentences = assertions[lastDialog].proveIt
        case Button.relevance:
            updateText()
            sentences = assertions[lastDialog].relevance
        default:
            break
        }
        currentState = .dialoging
        actionButton0.isHidden = true
        actionButton2.isHidden = true
        actionButton3.isHidden = true
    }
    func stopDialog() {
        currentState = .normal
        actionButton0.isHidden = false
        actionButton2.isHidden = false
        actionButton3.isHidden = false
        sentences = auxStringArray
        actualDialog = lastDialog
        checkChanges(actualButton)
        changeBack()
        updateText()
        
    }
    func createNewAssertion(_ Id:Int) -> Assertion {
        switch Id {
        case 1:
            return Assertion(phrase: "Esta frase foi adicionada", howSo: ["",""], proveIt: ["",""], relevance: ["",""])
        default:
            return Assertion(phrase: "Esta frase foi adicionada", howSo: ["",""], proveIt: ["",""], relevance: ["",""])
        }
        
    }
    func positioningAssertion() {
        assertions[actualDialog].state = .none
        assertions.insert(createNewAssertion(assertions[actualDialog].id!), at: actualDialog)
        sentences.insert(assertions[actualDialog].phrase, at: actualDialog)
    }
    
    func checkChanges(_ sender:Button) {
        switch assertions[actualDialog].state {
        case .editable:
            
            switch assertions[actualDialog].trigger {
            case .howSo:
                if sender == Button.howSo {
                    sentences[actualDialog] = assertions[actualDialog].uptadedPhrase!
                }
            case .proveIt:
                if sender == Button.proveIt {
                    sentences[actualDialog] = assertions[actualDialog].uptadedPhrase!
                }
            case .relevance:
                if sender == Button.relevance {
                    sentences[actualDialog] = assertions[actualDialog].uptadedPhrase!
                }
            default: break
                
            }
            
        case .removable:
            switch assertions[actualDialog].trigger {
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
            switch assertions[actualDialog].trigger {
            case .howSo: if sender == Button.howSo {
                positioningAssertion()
                }
            case .proveIt: if sender == Button.proveIt {
                positioningAssertion()
                }
            case .relevance: if sender == Button.relevance {
                positioningAssertion()
                }
            default:
                break
            }
            
        default: break
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "challengePopUpViewController" {
            let popup = segue.destination as! ChallengePopUpViewController
            popup.actualDialog = actualDialog
        }
    }
}

