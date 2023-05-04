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

struct Unit: Hashable, Identifiable, Equatable {
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
        Unit(name: "Milliliters", symbol: "ml", type: UnitType.vol),
        Unit(name: "Celsius", symbol: "°C", type: UnitType.temp),
        Unit(name: "Farenheit", symbol: "°F", type: UnitType.temp)
        
    ]
    
    static let conversions = [
        "g": ["oz":{x in x * 0.035274}],
        "ml": ["fl oz":{x in x * 0.033814}],
        "°C": ["°F":{x in (x * 9/5) + 32.0}]
        
    ]
    @State private var from: Unit = units[0]
    @State private var to: Unit = units[1]
    @State private var input: String = "0"
    private var output: Double {
        return ((ContentView.conversions[from.symbol]?[to.symbol] ?? {x in 0})(Double(input) ?? 0))
    }
    private var filteredUnits: [Unit] {
        switch from.type {
        case UnitType.mass:
            let fs = ContentView.units.filter{$0.type == UnitType.mass && $0.name != from.name}
            return fs
        case UnitType.vol:
            let fs = ContentView.units.filter{$0.type == UnitType.vol && $0.name != from.name}
            return fs
        case UnitType.temp:
            let fs = ContentView.units.filter{$0.type == UnitType.temp && $0.name != from.name}
            return fs
        }
    }
        
    var body: some View {
        VStack {
            VStack{
                Text("Converter")
                HStack{
                    Text("From")
                    
                    Picker("From",selection: $from) {
                        ForEach(ContentView.units){ unit in
                            Text(unit.symbol).tag(unit)
                        }
                        
                    }.onChange(of: from, perform: {value in if (from.type != to.type) {to = filteredUnits[0] }})
                    
                    Text("➡️")
                    Text("To")
                    Picker("To",selection: $to) {
                        ForEach(filteredUnits){ unit in
                            Text(unit.symbol).tag(unit)
                        }
                    }
                }
                Text("You are converting \(from.name) to \(to.name)")
                TextField("Input unit", text: $input).numbersOnly($input, includeDecimal: true)
                Text("Converted unit: \(output)")
            }.padding()
            VStack{Text("For Mamou ♥️ by Ben")}.frame(alignment: .bottom)
            
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
