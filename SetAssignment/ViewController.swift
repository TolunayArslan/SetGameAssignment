//
//  ViewController.swift
//  SetAssignment
//
//  Created by Arslan, Tolunay on 04.11.19.
//  Copyright © 2019 Arslan, Tolunay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    /// The main set game.
    private var setGame = SetGame()
    
    /// The card buttons being displayed in the UI.
    @IBOutlet var cardButtons: [UIButton]!
    
    /// Label which shows the score of the Player.
    @IBOutlet weak var scoreLabel: UILabel!
    
    private let color: [Int : UIColor] = [1 : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), 2 : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), 3 : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ]
    private let shape: [Int : String] = [1 : "■", 2 : "▲", 3 : "●"]
    private let fill: [Int : CGFloat] = [1 : 0.5, 2 : 1, 3 : 1]
    private let shade: [Int : CGFloat] = [1 : -3, 2 : -3, 3 : 2]
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    // MARK: Actions

    @IBAction func selectCard(_ sender: UIButton) {
        

        let index: Int! = cardButtons.firstIndex(of: sender)
        
        guard setGame.playingCards.indices.contains(index) else {return}
        
        let isThereAMatch = setGame.selectCard(at: index)
        
        if setGame.indexOfMatchedCards.count != 3 {
            
            if isThereAMatch == true {
                for index in setGame.indexOfSelectedCards {
                    cardButtons[index].layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    cardButtons[index].layer.borderWidth = 2
                }
                updateLabelFromModel()
                setGame.markCardsMatched()
            } else if isThereAMatch == false {
                // Mark Red because of mismatch
                for index in setGame.indexOfSelectedCards {
                    cardButtons[index].layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    cardButtons[index].layer.borderWidth = 2
                }
                updateLabelFromModel()
                setGame.deselectCards()
            } else {
                updateViewFromModel()
                }
            } else {
            replaceMatchedCards()
            updateViewFromModel()
        }
    }
    
    /// Replaces Matched Cards with brand new  cards.
    func replaceMatchedCards() {
        for index in setGame.indexOfMatchedCards {
            
            setGame.replaceCard(at: index)
        }
    }
    
    /// Adjusts the UI according to its state
    private func updateViewFromModel() {
        for index in setGame.playingCards.indices {
            let card = setGame.playingCards[index]
            
            if card.isSelected {
                cardButtons[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cardButtons[index].layer.borderWidth = 2
            } else {
                cardButtons[index].layer.borderWidth = 0
            }
        }
        
        for index in setGame.playingCards.indices {
            drawCard(for: index)
        }
        updateLabelFromModel()
    }
    
    private func updateLabelFromModel() { scoreLabel.text = "Score: \(setGame.score)" }
    
    private func drawCard(for index: Int) {
        
        let card = setGame.playingCards[index]
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : color[card.matrix.color]!.withAlphaComponent(fill[card.matrix.shade]!),
            .strokeWidth : shade[card.matrix.shade]!,
            .strokeColor : color[card.matrix.color]!,
            .font :  UIFont(name: "Helvetica-Bold", size: 25)!
            
        ]
        
        var getShape: String {
            var shapeToReturn = shape[card.matrix.symbol]!
            if card.matrix.number == 1 {
                return shapeToReturn
            } else if card.matrix.number == 2 {
                shapeToReturn += shape[card.matrix.symbol]!
                return shapeToReturn
            } else {
                shapeToReturn += shape[card.matrix.symbol]!
                shapeToReturn += shape[card.matrix.symbol]!
                return shapeToReturn
            }
        }
        
        let atttributedText = NSAttributedString(string: getShape, attributes: attributes)
        cardButtons[index].setAttributedTitle(atttributedText, for: .normal)
    }
    
    /// Adding three more cards from the deck to the UI.
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        if setGame.indexOfMatchedCards.count == 3 {
            replaceMatchedCards()
        } else {
            let _ = setGame.deal3Cards()
            
        }
        updateViewFromModel()
    }
    
    private func initializeButtons() {
        for index in cardButtons.indices {
            let atttributedText = NSAttributedString(string: "", attributes: nil)
            cardButtons[index].setAttributedTitle(atttributedText, for: .normal)
        }
    }
    
    /// Starts a new game completely.
    @IBAction func startNewGame(_ sender: UIButton) {
        initializeButtons()
        setGame = SetGame()
        updateViewFromModel()
    }
    
}

