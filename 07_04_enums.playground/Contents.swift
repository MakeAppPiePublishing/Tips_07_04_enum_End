//
//  An exercise file for iOS Development Tips Weekly
//  by Steven Lipton (C)2018, All rights reserved
//  For videos go to http://bit.ly/TipsLinkedInLearning
//  For code go to http://bit.ly/AppPieGithub
//
import UIKit

// We'll break apart a csv stream of dounut menu items
// data is An item number X0000XX(String), Description(String) and price(String).
// item number  has three parts.
//      X               0000            XX
//     /                 |               \
//  type                number          2 Toppings
//  H - HOLE            (unique)         X - none
//  F - FILLED                           C - Chocolate
//                                       G - glazed
//                                       S - Sprinkles
//

// Here's our data
var dataString = """
H0001XG,Plain,0.95
F0002XX,Lemon, X1.49X
F0003CX,Boston Cream, 1.49
F0004CS,Choco Nutella, 1.95se
H0005SG,Happy,$0.95.01
F0006GS,Strawberry, $0.95-34
"""

enum DoughnutType:Int{
    case hole = 1,filled = 10
}

enum DoughnutTopping:String{
    case none = ""
    case chocolate
    case glazed
    case sprinkles
}

DoughnutType.hole.rawValue
DoughnutType.filled.rawValue
DoughnutTopping.chocolate.rawValue




class MenuEntry{
    var itemNumber:String = ""
    var description:String = ""
    var price:Double = 0.00
    var type:DoughnutType{
        switch itemNumber.prefix(1){
        case "H":
            return .hole
        case "F":
            return .filled
        default:
            return .hole
        }
    }
    var toppings:[DoughnutTopping]{
        var toppings = [DoughnutTopping]()
        for topping in itemNumber.suffix(2){
            switch topping {
            case "C":
                toppings += [.chocolate]
            case "G":
                toppings += [.glazed]
            case "S":
                toppings += [.sprinkles]
            default:
                toppings += [.none]
            }
        }
        return toppings
    }
    
    
    func toppingsString()-> String{
        var string = ""
        for topping in toppings{
            if topping != .sprinkles{
                string = " " + topping.rawValue + string
            } else {
                string += " with " + topping.rawValue
            }
        }
        return string
    }
    
    
    
    
    init (csvRecord:String, separator:Character){
        let record = csvRecord.split(separator: separator)
        itemNumber = String(record[0])
        description = String(record[1])
        let filter = "0123456789-"
        var cleanedString = String(record[2])
        cleanedString.removeAll(where: {!filter.contains($0)})
        var dashes = cleanedString.suffix(cleanedString.count - 1)
        dashes.removeAll(where: {"-" == $0})
        cleanedString = String(cleanedString.prefix(1) + dashes)
        
        if let price = Double(cleanedString){
            self.price = price
        } else {
            self.price = 0.0
        }
    }
}

var menu = [MenuEntry]()
var lineArray = [String]()
dataString.enumerateLines { (line, stop) in
    menu.append(MenuEntry(csvRecord: line, separator: ","))
}


for menuEntry in menu{
    var displayString = menuEntry.description
    if menuEntry.type == .filled{
        displayString += " filled"
    }
    displayString += menuEntry.toppingsString()
    displayString += " doughnut"
    displayString += "\t\(menuEntry.price)"
    print(displayString)
}
