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
    let type: [UnitType]
}

struct ContentView: View {
    
    static let units = [
        Unit(name:"Grams", symbol: "g", type:[UnitType.mass]),
        Unit(name:"Ounces", symbol: "oz", type:[UnitType.mass]),
        Unit(name: "Fluid Ounces", symbol: "fl oz", type: [UnitType.vol]),
        Unit(name: "Milliliters", symbol: "ml", type: [UnitType.vol]),
        Unit(name: "Celsius", symbol: "°C", type: [UnitType.temp]),
        Unit(name: "Farenheit", symbol: "°F", type: [UnitType.temp]),
        Unit(name: "Butter Sticks", symbol: "stick", type: [UnitType.vol, UnitType.mass]),
        Unit(name: "Tablespoon", symbol: "tbsp", type: [UnitType.vol]),
        Unit(name: "Cup", symbol: "cup", type: [UnitType.vol]),
        Unit(name: "Teaspoon", symbol: "tsp", type: [UnitType.vol])
        
        
    ]
    
    static let conversions: [String:[String:(Double) -> Double]] = [
        "g": ["oz":{x in x * 0.035274}, "stick":{x in x * (1/113)}],
        "stick": ["g": {x in x * 113}, "oz": {x in x * 113 * 0.035274}, "cup": {x in x/2}, "tbsp": {x in x * 8}, "fl oz": {x in x * 4}, "ml":{x in x * 111.294}],
        "oz": ["g":{x in x * (1/0.035274)}, "stick":{x in x * (1/0.035274) * (1/113)}],
        "ml": ["fl oz":{x in x * 0.033814}, "cup":{x in x * 0.00422675}, "tbsp": {x in x * 0.067628}],
        "fl oz": ["ml":{x in x * (1/0.033814)}, "cup": {x in x * 1/8}, "tbps": {x in x * 2}, "stick":{x in x/4}],
        "°C": ["°F":{x in (x * 9/5) + 32.0}],
        "°F": ["°C":{x in (x - 32) * 5/9}],
        "tbsp": ["ml": {x in x * (1/0.067628)} ,"cup": {x in x * 1/16}, "fl oz": {x in x * 0.5}, "stick" : {x in x/8} ],
        "tsp": ["tbsp": {x in x/3}],
        "cup": ["ml": {x in x * (1/0.00422675)}, "tbsp": {x in x * 16}, "fl oz": {x in x * 8}, "stick" : {x in x*2}]
        
    ]
    @State private var from: Unit = units[0]
    @State private var to: Unit = units[1]
    @State private var input: String = "0"
    @FocusState private var inputFocus: Bool
    private var output: Double {
        return ((ContentView.conversions[from.symbol]?[to.symbol] ?? {x in 0})(Double(input) ?? 0))
    }
    private var filteredUnits: [Unit] {
        var fs : [Unit] = []
        for type in from.type{
            switch type {
            case UnitType.mass:
                fs.append(contentsOf: ContentView.units.filter{$0.type.contains(UnitType.mass)  && $0.name != from.name})
                break
            case UnitType.vol:
                fs.append(contentsOf:  ContentView.units.filter{$0.type.contains(UnitType.vol) && $0.name != from.name})
                break
            case UnitType.temp:
                fs.append(contentsOf:  ContentView.units.filter{$0.type.contains(UnitType.temp) && $0.name != from.name})
                break
            }
        }
        return fs
    }
        
    var body: some View {
        VStack {
            VStack{
                Text("Unit Converter")
                                .font(.largeTitle)
                                .fontWeight(.black)
                Text("Kitchen Essentials")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            VStack{
                
                HStack{
                    Text("From")
                        .font(.headline)

                    
                    Picker("From",selection: $from) {
                        ForEach(ContentView.units){ unit in
                            Text(unit.symbol).tag(unit)
                        }
                        
                    }.onChange(of: from, perform: {value in if (from.type != to.type || from.name == to.name ) {to = filteredUnits[0] }}).frame(width: 80).pickerStyle(.inline)
                    
                    Text("➡️")
                    Text("To")
                        .font(.headline)
                    Picker("To",selection: $to) {
                        ForEach(filteredUnits){ unit in
                            Text(unit.symbol).tag(unit)
                        }
                    }.frame(width: 80).pickerStyle(.inline)
                }.padding()
                HStack {
                    TextField("", text: $input).numbersOnly($input, includeDecimal: true)
                        .textFieldStyle(.roundedBorder)
                        .frame(minWidth: 50,idealWidth: 50,maxWidth:70)
                        .focused($inputFocus)
                    
                    Text("\(from.symbol)")
                        .font(.headline)

                    Text("➡️")

                    Text("\( String(format: "%.2f", output))").padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 1)
                        )
                    Text("\(to.symbol)")
                        .font(.headline)

                }
            }.padding()
            Spacer()
            Spacer()
            VStack{Text("Made with ♥️ for Mamou").font(.footnote)}.frame(alignment: .bottom)
            
        }
        .padding()
        .onTapGesture(perform: {inputFocus = false})
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
