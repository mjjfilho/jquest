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
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var apresentaçãoLabel: UILabel!
    
    var actualScene:Scene!
    var assertions: [Assertion] = []
    var sentences: [String] = []
    var actualDialog: Int!{
        didSet {
            if currentState == State.normal && self.actualDialog == 0{
                actionButton0.isHidden = true
                actionButton2.isHidden = false
                actionButton3.isHidden = false
            } else if currentState == State.normal {
                actionButton3.isHidden = false
                actionButton2.isHidden = false
                actionButton0.isHidden = false
            }
        }
    }
    var tutorialFirstScene: Bool = false
    var tutorialIsComplete: Bool = false
    var lastDialog: Int = 0
    var auxStringArray: [String] = []
    var actualButton: Button = .none
    var currentState: State! {
        didSet{
            if self.currentState == State.questioning{
                actionButton3.isHidden = false
                actionButton2.isHidden = false
                actionButton0.isHidden = false
            }
        }
    }
      
    var challengeSelected = 0
    
    enum State {
        
        case normal
        case questioning
        case challenging
        case dialoging
        case cutscene
    }
    enum Button {
        
        case howSo
        case proveIt
        case relevance
        case none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeView.alpha = 0
        themeLabel.alpha = 0
        actualDialog = 0
        actionButton0.layer.cornerRadius = 10
        actionButton1.layer.cornerRadius = 10
        actionButton2.layer.cornerRadius = 10
        actionButton3.layer.cornerRadius = 10
        actionButton0.isHidden = true
        actionButton2.isHidden = true
        actionButton3.isHidden = true
        currentState = State.cutscene
        apresentaçãoLabel.alpha = 0
        
        NotificationCenter.default.addObserver(forName: .saveChallenge, object: nil, queue: nil) {
            (notification) in
            let challengeVC = notification.object as! ChallengePopUpViewController
            let challengeSelected: Int = challengeVC.challengeSelected
            self.challengeAccepted(contradiction: challengeVC.statments[challengeSelected], finding: self.sentences[self.actualDialog],scene: self.actualScene!)
        }
        
        assertions = [
            Assertion(id: 0,
                      phrase: "",
                      howSo: [],
                      proveIt: [],
                      relevance: [],
                      state: nil,
                      trigger: nil,
                      howCharacter: [],
                      proveCharacter: [],
                      relevCharacter: [],
                      Loop: ["Ainda me lembro dos tempos de infância",
                             "O cheiro de todas as coisas eram como uma nova descoberta",
                             "assim como todos os sentidos...",
                             "Eu acho que foi naquela época",
                             "que eu comecei a me debruçar a respeito do que é belo, do que é moral.",
                             "Sobre as questões da filosofia",
                             "acho que foi naquela manhã que tudo mudou",
                             "eu devia ter uns… 12 anos, acho que é isso..."],
                      loopCharacter: [0,0,0,0,0,0,0,0])
        ]
        
        actualScene =  Scene(
            theme: "",
            character: ["Narrador"],
            assertions: self.assertions,
            
            background: nil,
            answer: Answer("",
                           ""),
            dialog: ["(Bem, ai está o pitch dele mais uma vez...)",
                     "(Ainda não fez tanto sentido..)",
                     "(Acho que eu devo dar mais uma olhada nos argumentos dele.)"])
        
        themeLabel.text = "Tema: \"\(actualScene.theme)\""
        sentences = assertions[0].loop!
        
        let characterLoop:Int  =  assertions[0].loopCharacter[actualDialog]
        
        characterLabel.text = actualScene.character[characterLoop]
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
            runDialog(.howSo)
        }
    }
    
    @IBAction func fwdButton(_ sender: UIButton) {
        switch currentState {
        case .normal:
            if actualDialog < sentences.count-1  {
                actualDialog += 1
                updateText()
            } else {
                actualDialog = 0
                runDialog(.none)
                print(sentences)
            }
            
        case .questioning:
            runDialog(Button.proveIt)
            
        case .dialoging:
            if actualDialog == sentences.count-1 {
                stopDialog()
            } else if actualDialog < sentences.count-1 {
                actualDialog += 1
                updateText()
                print(sentences)
            }
        case .cutscene:
            if actualDialog < sentences.count-1 {
                actualDialog += 1
                updateText()
            } else if actualDialog == sentences.count-1 {
                runNextScene()
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
        }
    }
    
    @IBAction func challengeButton(_ sender: UIButton) {
        
        if currentState == .normal {
            let challengePopUpView: UIStoryboard = UIStoryboard(name: "PopViewController", bundle: nil)
            let vc = challengePopUpView.instantiateViewController(identifier: "ChallengePopUp") as! ChallengePopUpViewController
            vc.actualDialog = actualDialog
            self.present(vc, animated: false, completion: nil)
            
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
        if currentState == State.cutscene{
            let characterLoop:Int  =  assertions[0].loopCharacter[actualDialog]
            characterLabel.text = actualScene.character[characterLoop]
            themeLabel.text = "Tema: \"\(actualScene.theme)\""
            dialogLabel.text = sentences[actualDialog]
            
        } else if currentState == State.normal{
            characterLabel.text = actualScene.character[0]
            themeLabel.text = "Tema: \"\(actualScene.theme)\""
            dialogLabel.text = sentences[actualDialog]
        } else if sentences == actualScene.dialog{
            characterLabel.text = actualScene.character[1]
            themeLabel.text = "Tema: \"\(actualScene.theme)\""
            dialogLabel.text = sentences[actualDialog]
        }
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
    func rodarAnimação() {
        
    }
    
    func runNextScene() {
        switch actualScene.theme {
        case "":
            actualScene.theme = " "
            actualScene.character = ["Kinha","Jota","","Narrador"]
            actualScene.assertions[0].loopCharacter = [2,1,0,1,0,1,0,1,0,2,0,1,0,3,3,3,3]
            assertions[0].loop = ["- Natal/RN, meados de 2002 - \n Casa do jota",
                                  "Bom dia, Kinha? quer ir comigo de bike para o colégio?",
                                  "Claro! Adivinha o que vamos fazer hoje? A gente vai estudar sobre o Protágoras, na aula hoje ",
                                  "… Quem?",
                                  "\"O homem é a medida de todas as coisas, das coisas que são, enquanto são, das coisas que não são, enquanto não são\".",
                                  "Ahh… Eu sei ele é o matématico, não é?",
                                  "Não, é Protágoras. Filosofo, Sofista…",
                                  "Pode crê…",
                                  "Ele é brilhante. Abriu minha mente para uma nova forma de ver o mundo..",
                                  "*jota mexe na bicicleta*",
                                  "você tá pelo menos prestando atenção no que eu estou falando?",
                                  "Uhhh… Foi mal, acho que tem alguém na porta",
                                  "Se apresse a gente tem que ir pro colégio daqui a 30 minutos ",
                                  "Meu nome é Mateus, meus amigos me chamam de Jota.",
                                  "Todos os meus amigos parecem se importar muito com filosofia…",
                                  "Mas eu nunca fui muito fã…",
                                  "Eu gosto mesmo de desenhar, no final das contas. Por que eu deveria me importar sobre a natureza do que é certo e errado?"]
            updateScene()
            
        case " ":
            actualScene.theme = "O vendedor"
            actualScene.character = ["Vendedor","Jota","Kinha","*interrompido pelo Jota*","*interrompido pelo Kinha*", "Jota, em seus pensamentos",""]
            actualScene.assertions[0].loopCharacter = [6,0,1,0,0,1,0,1,2,1,2,0,0,0,1,2,0,5,1,0]
            assertions[0].loop = ["*Jota abre a porta e um estranho aparece*",
                                  "Olá, Boa tarde!",
                                  "Olá.",
                                  "Meu nome é Billy, Billy o vendedor! eu passei o ano viajando pelo País vendendo meus artigos",
                                  "quando eu vi o seu belíssimo apartamento, eu soube instantaneamente: \"Aqui mora um rapaz que gosta de um bom négocio\".",
                                  "… Perdão?",
                                  "Você gostaria de ouvir sobre as fabulosas barganhas que eu tenho pra você hoje?",
                                  "Eu tenho que ir pra escola",
                                  "Por que você tá demorando tanto?",
                                  "Esse cara bateu na porta e começou a falar umas coisas...",
                                  "A gente tem que ir pro colégio… Quem é esse cara?",
                                  "Estou feliz que tenha perguntado, meu jovem.",
                                  "eu sou Billy, o Vendedor. Tenho vendido meus artigos pelo mund.. *interrompido por Jota*",
                                  "tá, tá Billy, beleza, a gente tem *  interrompido por Kinha *...",
                                  "Acho que deveríamos ouvi-lo",
                                  "se não nós importamos de ouvir, nunca se ganha algo na vida",
                                  "Obrigado, rapaz. Você não se arrependerá",
                                  "(tenho que certeza que eu irei... )",
                                  "*suspiro* Okay, Billy. Vamos escutar!",
                                  "Certo"]
            updateScene()
        case "O vendedor":
            actualScene.theme = "Compre meu produto "
            actualScene.character = ["Vendedor", "Jota","Kinha",""]
            actualScene.assertions[0].loopCharacter = [0,0,0,0,0,1,0,1,1,2,2,2,1,2,2,0,1,0,3]
            assertions[0].loop = ["eu tenho um ótimo produto pra você",
                                  "Ele é o melhor que existe",
                                  "Você precisa do meu produto para fazer o que ele faz",
                                  "você não quer aquelas pestes andando por aí",
                                  "isso é tudo pessoal!",
                                  "Mas você quase não me disse nada.",
                                  "Creiemdeuspai! Eu disse que meu produto é o melhor do mercado, do que mais você precisa saber?",
                                  "Kinha, Isso tudo é sua culpa, ele praticamente não me disse nada.",
                                  "O que eu faço agora?",
                                  "Bem… Geralmente, quando alguém quer mais informação ela pergunta.",
                                  "Neste caso, o mais apropriado é perguntar por um esclarecimento.",
                                  "Se você puder tirar qualquer vaguidade ao redor das ideias dele, você estará em uma posição melhor para lidar com elas.",
                                  "Certo…",
                                  "Legal! Boa parte dos argumentos são feitas de múltiplas asserções",
                                  "tenha certeza que você entendeu cada uma delas para cada uma das coisas que parecem vagas.",
                                  "E ai, meu caro? vai comprar?",
                                  "posso, ouvir seu pitch mais uma vez?",
                                  "Claro, meu caro.",
                                  "\"Perguntar por esclarecimento foi adicionado\""
            ]
            
            UIView.animate(withDuration: 1.0, animations: {
                self.apresentaçãoLabel.alpha = 1
            }) { (complete) in
                UIView.animate(withDuration: 1.0, animations: {
                    
                })
                self.apresentaçãoLabel.alpha = 0
                self.themeLabel.alpha = 1
                self.themeView.alpha = 1
            }
            updateScene()
            
        case "Compre meu produto ":
            actualScene.theme = "Compre meu produto"
            actualScene.character = ["Vendedor", "Jota", "Kinha", "", "Jota, pensando"]
            actualScene.assertions = [Assertion(id: 1,
                                                phrase: "eu tenho um ótimo produto pra você",
                                                howSo: ["E exatamente que tipo de produto é esse?",
                                                        "é um repelente para cervos",
                                                        "Ah, Okay",
                                                        "Nem foi tão dificil",
                                                        "*Asserção atualizada*"],
                                                proveIt: [],
                                                relevance: [],
                                                state: .editable,
                                                trigger: .howSo,
                                                howCharacter: [],
                                                proveCharacter: [1,0,1,0,3],
                                                relevCharacter: [],
                                                Loop: [],
                                                loopCharacter: []),
                                      Assertion(id: 0,
                                                phrase:"Ele é o melhor que existe",
                                                howSo: [" O que você quer dizer com isso?",
                                                        "é o melhor! É melhor do que o resto!",
                                                        "Ele é muito bom, em fazer o que ele faz jovem",
                                                        "Certo!",
                                                        "Acho que isso não esclarece nada sobre a venda dele"],
                                                proveIt: [],
                                                relevance: [],
                                                state: .none,
                                                trigger: nil,
                                                howCharacter: [1,0,0,1,3],
                                                proveCharacter: [],
                                                relevCharacter: [],
                                                Loop: [],
                                                loopCharacter: []),
                                      Assertion(id: 0,
                                                phrase: "Você precisa do meu produto para fazer o que ele faz",
                                                howSo: ["e, uh.. e o que ele faz exatamente?",
                                                        "Ele te protege do perigo meu caro, do perigo, dos CERVOS!",
                                                        "E acredite meu jovem, você estará totalmente protegido",
                                                        "*Asserção atualizada*"],
                                                proveIt: [],
                                                relevance: [],
                                                state: .cutscener,
                                                trigger: .howSo,
                                                howCharacter: [],
                                                proveCharacter: [],
                                                relevCharacter: [],
                                                Loop: [],
                                                loopCharacter: [])]
            currentState = .normal
            updateScene()
            
        default:
            break
        }
        
    }
    
    func updateScene () {
        if currentState == State.cutscene {
            actualDialog = 0
            sentences = assertions[0].loop!
            updateText()
        } else {
            actualDialog = 0
            sentences = []
            for phrase in actualScene.assertions {
                sentences.append(phrase.phrase)
            }
            updateText()
        }
        
    }
    func runDialog(_ sender:Button) {
        changeBack()
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
            sentences = actualScene.dialog
            updateText()
            
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
            return Assertion(id: 0,
                             phrase: "O produto que eu tenho aqui é o Repelente de cervos do Billy.",
                             howSo: ["Ainda não tenho certeza do que é exatamente isso, você pode esclarecer pra mim?",
                                     "Claro. Você borrifa isso e isso repele cervos. Por isso se chama repelente de cervo",
                                     "Ah, claro faz sentido."],
                             proveIt: [],
                             relevance: [],
                             state: nil,
                             trigger: nil,
                             howCharacter: [0,1,0],
                             proveCharacter: [],
                             relevCharacter: [],
                             Loop: [],
                             loopCharacter: [])
        default:
            return Assertion(id: 0,
                             phrase: "",
                             howSo: [],
                             proveIt: [],
                             relevance: [],
                             state: nil,
                             trigger: nil,
                             howCharacter: [],
                             proveCharacter: [],
                             relevCharacter: [],
                             Loop: [],
                             loopCharacter: [])
        }
        
    }
    func positioningAssertion() {
        assertions[actualDialog].state = nil
        assertions.insert(createNewAssertion(assertions[actualDialog].id!), at: actualDialog)
        sentences.insert(assertions[actualDialog].phrase, at: actualDialog)
    }
    func editingAssertion() {
        sentences.remove(at: actualDialog)
        assertions.insert(createNewAssertion(assertions[actualDialog].id!), at: actualDialog)
        sentences.insert(assertions[actualDialog].phrase, at: actualDialog)
        positioningAssertion()
    }
    
    func checkChanges(_ sender:Button) {
        switch assertions[actualDialog].state {
        case .editable:
            
            switch assertions[actualDialog].trigger {
            case .howSo:
                if sender == Button.howSo {
                    editingAssertion()
                }
            case .proveIt:
                if sender == Button.proveIt {
                    editingAssertion()
                    
                }
            case .relevance:
                if sender == Button.relevance {
                    editingAssertion()
                    
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
}

