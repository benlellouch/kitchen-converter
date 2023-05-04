//
//  ContentView.swift
//  Kitchen Converter
//
//  Created by Benjamin Lellouch on 03/05/2023.
//

import SwiftUI

enum UnitType {
    case mass,vol,temp
}

struct Unit: Hashable, Identifiable {
    var id: Self {self}
    
    
    let name: String
    let symbol: String
    let type: UnitType
}

struct ContentView: View {
    
    static let units = [
        Unit(name:"Grams", symbol: "g", type:UnitType.mass),
        Unit(name:"Ounces", symbol: "oz", type:UnitType.mass),
        Unit(name: "Fluid Ounces", symbol: "fl oz", type: UnitType.vol),
        Unit(name: "Milliliters", symbol: "ml", type: UnitType.vol)
    ]
    @State private var from: Unit = units[0]
    @State private var to: Unit = units[1]
    @State private var input: String = "0"
        
    var body: some View {
        VStack {
            Text("Converter")
            HStack{
                Text("From")
                Picker("From",selection: $from) {
                    ForEach(ContentView.units){ unit in
                        Text(unit.symbol)
                    }

                }
                Text("➡️")
                Text("To")
                Picker("To",selection: $to) {
                    let filteredUnits = filterUnits(unit: from, list: ContentView.units)
                    ForEach(filteredUnits){ unit in
                        Text(unit.symbol)
                    }
                }
            }
            Text("You are converting \(from.name) to \(to.name)")
            TextField("Input unit", text: $input).numbersOnly($input, includeDecimal: true)
        }
        .padding()
    }
    
    func filterUnits(unit: Unit, list: [Unit]) -> [Unit]{
        switch unit.type {
        case UnitType.mass:
            let fs = list.filter{$0.type == UnitType.mass}
            return fs
        case UnitType.vol:
            let fs = list.filter{$0.type == UnitType.vol}
            return fs
        case UnitType.temp:
            let fs = list.filter{$0.type == UnitType.temp}
            return fs
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
