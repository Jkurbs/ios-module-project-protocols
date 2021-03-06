import Foundation

//: ## Step 1
//: Create an enumeration for the value of a playing card. The values are: `ace`, `two`, `three`, `four`, `five`, `six`, `seven`, `eight`, `nine`, `ten`, `jack`, `queen`, and `king`. Set the raw type of the enum to `Int` and assign the ace a value of `1`.
enum Rank: Int, CustomStringConvertible {

    case ace = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    
    var description:String {
        switch self {
        case .ace:
            return "Ace"
        case .two:
            return "Two"
        case .three:
            return "Three"
        case .four:
            return "Four"
        case .five:
            return "Five"
        case .six:
            return "Six"
        case .seven:
            return "Seven"
        case .eight:
            return "Eight"
        case .nine:
            return "Nine"
        case .ten:
            return "Ten"
        case .jack:
            return "Jack"
        case .queen:
            return "Queen"
        case .king:
            return "King"
        }
    }
    
    static var allRanks: [Rank] {
        
        return [ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king]
    }
}

extension Rank: Comparable {
    
    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
}
    
    //: ## Step 2
    //: Once you've defined the enum as described above, take a look at this built-in protocol, [CustomStringConvertible](https://developer.apple.com/documentation/swift/customstringconvertible) and make the enum conform to that protocol. Make the face cards return a string of their name, and for the numbered cards, simply have it return that number as a string.
    
    
    
    
    //: ## Step 3
    //: Create an enum for the suit of a playing card. The values are `hearts`, `diamonds`, `spades`, and `clubs`. Use a raw type of `String` for this enum (this will allow us to get a string version of the enum cases for free, no use of `CustomStringConvertible` required).
    
    enum Suit: String {
        
        case hearts
        case diamonds
        case spades
        case clubs
        
        static var allSuits: [Suit] {
            return [hearts, diamonds, spades, clubs]
        }
    }


//: ## Step 4
//: Using the two enums above, create a `struct` called `Card` to model a single playing card. It should have constant properties for each constituent piece (one for suit and one for rank).
struct Card: CustomStringConvertible {
    
    let rank: Rank
    let suit: Suit
    
    var description: String {
        return "\(rank) of \(suit)"
    }
}



//: ## Step 5
//: Make the card also conform to `CustomStringConvertible`. When turned into a string, a card's value should look something like this, "ace of spades", or "3 of diamonds".
   /// Create an instace of  Card
   let card = Card(rank: .eight, suit: .diamonds)
   print(card)


//: ## Step 6
//: Create a `struct` to model a deck of cards. It should be called `Deck` and have an array of `Card` objects as a constant property. A custom `init` function should be created that initializes the array with a card of each rank and suit. You'll want to iterate over all ranks, and then over all suits (this is an example of _nested `for` loops_). See the next 2 steps before you continue with the nested loops.
struct Deck {
    
    var cards = [Card]()

    init() {
        
        /// Iterate over all ranks and suits
        for rank in Rank.allRanks {
            for suit in Suit.allSuits {
                let card = Card(rank: rank, suit: suit)
                self.cards.append(card)
            }
        }
    }
    
    
    /// Function to draw cards randomly
    func drawCard() -> Card {
        
        return cards.randomElement()!
    }
}




//: ## Step 7
//: In the rank enum, add a static computed property that returns all the ranks in an array. Name this property `allRanks`. This is needed because you can't iterate over all cases from an enum automatically.




//: ## Step 8
//: In the suit enum, add a static computed property that returns all the suits in an array. Name this property `allSuits`.




//: ## Step 9
//: Back to the `Deck` and the nested loops. Now that you have a way to get arrays of all rank values and all suit values, create 2 `for` loops in the `init` method, one nested inside the other, where you iterate over each value of rank, and then iterate over each value of suit. See an example below to get an idea of how this will work. Imagine an enum that contains the 4 cardinal directions, and imagine that enum has a property `allDirections` that returns an array of them.
//: ```
//: for direction in Compass.allDirections {
//:
//:}
//:```





//: ## Step 10
//: These loops will allow you to match up every rank with every suit. Make a `Card` object from all these pairings and append each card to the `cards` property of the deck. At the end of the `init` method, the `cards` array should contain a full deck of standard playing card objects.

// Print card counts
var deck = Deck()
print(deck.cards.count)



//: ## Step 11
//: Add a method to the deck called `drawCard()`. It takes no arguments and it returns a `Card` object. Have it draw a random card from the deck of cards and return it.
//: - Callout(Hint): There should be `52` cards in the deck. So what if you created a random number within those bounds and then retrieved that card from the deck? Remember that arrays are indexed from `0` and take that into account with your random number picking.

// Draw random cards
deck.drawCard()


//: ## Step 12
//: Create a protocol for a `CardGame`. It should have two requirements:
//: * a gettable `deck` property
//: * a `play()` method
protocol CardGame {
    
    var deck: Deck {get}
    func play()
}



//: ## Step 13
//: Create a protocol for tracking a card game as a delegate called `CardGameDelegate`. It should have two functional requirements:
//: * a function called `gameDidStart` that takes a `CardGame` as an argument
//: * a function with the following signature: `game(player1DidDraw card1: Card, player2DidDraw card2: Card)`
protocol CardGameDelegate {
    
    func gameDidStart(cardGame: CardGame)
    func game(player1DidDraw card1: Card, player2DidDraw card2: Card)
    func gameDidEnd( _ game: CardGame)

}



//: ## Step 14
//: Create a class called `HighLow` that conforms to the `CardGame` protocol. It should have an initialized `Deck` as a property, as well as an optional delegate property of type `CardGameDelegate`.
class HighLow: CardGame {
    
    var deck = Deck()
    var cardGameDelegate: CardGameDelegate?
    
    var timer:Timer?
    var time = 3.0
    
    
    init(cardGameDelegate: CardGameDelegate) {
        self.cardGameDelegate = cardGameDelegate
    }
    
    func play() {
        
        /// Create a countdown before game start 
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.time -= 1
            print("A new game is about to start in \(self.time)")
            if self.time == 0.0 {
                timer.invalidate()
                
                /// Start game
                self.cardGameDelegate?.gameDidStart(cardGame: self)
                
                /// Create cards for players
                let player1Card = self.deck.drawCard()
                let player2Card = self.deck.drawCard()
                
                /// Ongoing game
                self.cardGameDelegate?.game(player1DidDraw: player1Card, player2DidDraw: player2Card)
                
                /// End game
                self.cardGameDelegate?.gameDidEnd(self)
            }
        })
    }
}



//: ## Step 15
//: As part of the protocol conformance, implement a method called `play()`. The method should draw 2 cards from the deck, one for player 1 and one for player 2. These cards will then be compared to see which one is higher. The winning player will be printed along with a description of the winning card. Work will need to be done to the `Suit` and `Rank` types above, so see the next couple steps before continuing with this step.




//: ## Step 16
//: Take a look at the Swift docs for the [Comparable](https://developer.apple.com/documentation/swift/comparable) protocol. In particular, look at the two functions called `<` and `==`.




//: ## Step 17
//: Make the `Rank` type conform to the `Comparable` protocol. Implement the `<` and `==` functions such that they compare the `rawValue` of the `lhs` and `rhs` arguments passed in. This will allow us to compare two rank values with each other and determine whether they are equal, or if not, which one is larger.





//: Step 18
//: Make the `Card` type conform to the `Comparable` protocol. Implement the `<` and `==` methods such that they compare the ranks of the `lhs` and `rhs` arguments passed in. For the `==` method, compare **both** the rank and the suit.





//: ## Step 19
//: Back to the `play()` method. With the above types now conforming to `Comparable`, you can write logic to compare the drawn cards and print out 1 of 3 possible message types:
//: * Ends in a tie, something like, "Round ends in a tie with 3 of clubs."
//: * Player 1 wins with a higher card, e.g. "Player 1 wins with 8 of hearts."
//: * Player 2 wins with a higher card, e.g. "Player 2 wins with king of diamonds."



//: ## Step 20
//: Create a class called `CardGameTracker` that conforms to the `CardGameDelegate` protocol. Implement the two required functions: `gameDidStart` and `game(player1DidDraw:player2DidDraw)`. Model `gameDidStart` after the same method in the guided project from today. As for the other method, have it print a message like the following:
//: * "Player 1 drew a 6 of hearts, player 2 drew a jack of spades."
class CardGameTracker:  CardGameDelegate {
   
    var numberOfTurns = 0
    
    func gameDidStart(cardGame: CardGame) {
        self.numberOfTurns = 0
        if cardGame is HighLow {
            print("A new game has started.")
        }
    }
    
    
    func game(player1DidDraw card1: Card, player2DidDraw card2: Card) {
        
        numberOfTurns += 1
        
        print("Player 1 drew a \(card1), player 2 drew \(card2)")
        
        if card1.rank == card2.rank && card1.suit == card2.suit ||  card1.rank == card2.rank && card1.suit != card2.suit {
            print("Round ends in a tie with \(card1)")
        } else if card1.rank > card2.rank {
            // Compare cards to see which one is greater
            print("Player 1 wins with \(card1)")
        } else {
            print("Player 2 wins with \(card2)")
        }
    }
    
    func gameDidEnd(_ game: CardGame) {
        print("The game lasted for \(numberOfTurns) turns.")
    }
}


//: Step 21
//: Time to test all the types you've created. Create an instance of the `HighLow` class. Set the `delegate` property of that object to an instance of `CardGameTracker`. Lastly, call the `play()` method on the game object. It should print out to the console something that looks similar to the following:
//:
//: ```
//: Started a new game of High Low
//: Player 1 drew a 2 of diamonds, player 2 drew a ace of diamonds.
//: Player 1 wins with 2 of diamonds.
//: ```


/// Create instance of HighLow
let highLow = HighLow(cardGameDelegate: CardGameTracker())

/// Play
highLow.play()


