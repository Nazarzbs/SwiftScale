//
//  ContentView.swift
//  SwiftScale
//
//  Created by Nazar on 08.08.2023.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
      
        TabView(selection: $selectedTab) {
            
            FirstView()
                .tabItem {
                    Image("thermometer.sun")
                    Text("Temperature")
                }
                .tag(0)
               
            
            SecondView()
                .tabItem {
                    Image("road.lanes.curved.right")
                    Text("Lenght")
                }
                .tag(1)
            
            ThirdView()
                .tabItem {
                    Image("clock")
                    Text("Time")
                }
                .tag(2)
            
            FourthView()
                .tabItem {
                    Image("spigot")
                    Text("Volume")
                }
                .tag(3)
        }
    }
}
//MARK: - #1 FirstView Temperature
struct FirstView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var inputTemperature = 0.0
    
    let temperatureUnits = ["celsius", "fahrenheit", "kelvin"]
    @State private var convertFrom: Int = 0 
    @State private var convertTo: Int = 0
    
    var outputTemperature: Double {
        let inputUnit = temperatureUnits[convertFrom]
        let outputUnit = temperatureUnits[convertTo]
        var convertedTemperature = inputTemperature
        
        switch inputUnit {
        case "celsius":
            if outputUnit == "fahrenheit" {
                convertedTemperature = (convertedTemperature * 9/5) + 32
            } else if outputUnit == "kelvin" {
                convertedTemperature = convertedTemperature + 273.15
            }
        case "fahrenheit":
            if outputUnit == "celsius" {
                convertedTemperature = (inputTemperature - 32) * 5/9
            } else if outputUnit == "kelvin" {
                convertedTemperature = (inputTemperature - 32) * 5/9 + 273.15
            }
        case "kelvin":
            if outputUnit == "fahrenheit" {
                convertedTemperature = (inputTemperature - 273.15) * 9/5 + 32
            } else if outputUnit == "celsius" {
                convertedTemperature = inputTemperature - 273.15
            }
            
        default:
            break
        }
        return convertedTemperature
    }

    //MARK: - body Temperature
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Please enter your value")) {
                    TextField("Enter Temperature", value: $inputTemperature, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section(header: Text("Choose an input unit")) {
                    Picker("Unit to convert from", selection: $convertFrom) {
                        ForEach(0..<temperatureUnits.count, id: \.self) {
                            Text("\(temperatureUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Choose an output unit")) {
                    Picker("Choose unit to get", selection: $convertTo) {
                        ForEach(0..<temperatureUnits.count, id: \.self) {
                            if $0 != convertFrom {
                                Text("\(temperatureUnits[$0])")
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Your value converted to \(temperatureUnits[convertTo])")) {
                    Text("\(outputTemperature, specifier: "%.2f")")
                }
            }
            .navigationTitle("Temperature Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}


//MARK: - #2 SecondView Length
struct SecondView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var inputLength  = 0.0
    private let lengthUnits = ["meters", "kilometers", "feet", "yards",  "miles"]
    
    private let length = [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards,  UnitLength.miles]
    
    @State private var convertFrom: Int = 0
    
    private func converter(_ convertTo: Int) -> Measurement<UnitLength> {
        
        let input = Measurement(value: inputLength, unit: length[convertFrom])
        
        var converted: Measurement<UnitLength> = input
        
        switch convertTo {
        case 0:
            converted = input.converted(to: length[0])
        case 1:
            converted = input.converted(to: length[1])
        case 2:
            converted = input.converted(to: length[2])
        case 3:
            converted = input.converted(to: length[3])
        default:
            converted = input.converted(to: length[4])
        }
        return converted
    }
   
    //MARK: - body Length
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Please enter your value")) {
                    TextField("Enter Temperature", value: $inputLength , format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section {
                    Picker("Select you value unit", selection: $convertFrom) {
                        ForEach(0..<lengthUnits.count, id: \.self) {
                            Text(lengthUnits[$0])
                        }
                    }
                }
               
                ForEach(0..<lengthUnits.count, id: \.self) { index in
                    if index != convertFrom {
                        Section(header: Text("Your value converted to \(lengthUnits[index])")) {
                            Text("\(converter(index).description)")
                        }
                    }
                }
            }
            .navigationTitle("Length converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

//MARK: - #3 ThirdView Time
struct ThirdView: View {
        @FocusState private var amountIsFocused: Bool
        @State private var inputTime = 0.0
        
        let timeUnits = ["seconds", "minutes", "hours", "days"]
        @State private var convertFrom: Int = 0
        @State private var convertTo: Int = 0
        
        var outputTime: Double {
            let inputUnit = timeUnits[convertFrom]
            let outputUnit = timeUnits[convertTo]
            var convertedTime = inputTime
            
            switch inputUnit {
            case "seconds":
                if outputUnit == "minutes" {
                    convertedTime = (convertedTime / 60)
                } else if outputUnit == "hours" {
                    convertedTime = convertedTime / (60 * 60)
                } else if outputUnit == "days" {
                    convertedTime = convertedTime / (60 * 60 * 24)
                }
            case "minutes":
                if outputUnit == "seconds" {
                    convertedTime = (inputTime) * 60
                } else if outputUnit == "hours" {
                    convertedTime = (inputTime) / 60
                } else if outputUnit == "days" {
                    convertedTime = (inputTime ) / (60 * 24)
                }
            case "hours":
                if outputUnit == "seconds" {
                    convertedTime = (inputTime) * (60 * 60)
                } else if outputUnit == "minutes" {
                    convertedTime = inputTime * 60
                } else if outputUnit == "days" {
                    convertedTime = inputTime / 24
                }
                
            default: //"days"
                if outputUnit == "seconds" {
                    convertedTime = (inputTime) * (60 * 60 * 24)
                } else if outputUnit == "minutes" {
                    convertedTime = inputTime * (60 * 24)
                } else if outputUnit == "hours" {
                    convertedTime = inputTime * 24
                }
            }
            return convertedTime
        }

        //MARK: - body Time
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Please enter your value")) {
                        TextField("Enter Time", value: $inputTime, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                    }
                    
                    Section(header: Text("Choose an input unit")) {
                        Picker("Unit to convert from", selection: $convertFrom) {
                            ForEach(0..<timeUnits.count, id: \.self) {
                                Text("\(timeUnits[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Choose an output unit")) {
                        Picker("Choose unit to get", selection: $convertTo) {
                            ForEach(0..<timeUnits.count, id: \.self) {
                                if $0 != convertFrom {
                                    Text("\(timeUnits[$0])")
                                }
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Your value converted to \(timeUnits[convertTo])")) {
                        Text("\(outputTime.formatted(.number))")
                    }
                }
                .navigationTitle("Time Converter")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        Button("Done") {
                            amountIsFocused = false
                        }
                    }
                }
            }
        }
    }

//MARK: - #4 FourthView Time
struct FourthView: View {
    @State private var inputVolume  = 0.0
    private let volumeUnits = ["milliliters", "liters", "cups", "pints", "gallons"]
    @FocusState private var amountIsFocused: Bool
    private let volume = [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints,  UnitVolume.gallons]
    
    @State private var convertFrom: Int = 0
    
    private func converter(_ convertTo: Int) -> Measurement<UnitVolume> {
        
        let input = Measurement(value: inputVolume, unit: volume[convertFrom])
        
        var converted: Measurement<UnitVolume> = input
        
        switch convertTo {
        case 0:
            converted = input.converted(to: volume[0])
        case 1:
            converted = input.converted(to: volume[1])
        case 2:
            converted = input.converted(to: volume[2])
        case 3:
            converted = input.converted(to: volume[3])
        default:
            converted = input.converted(to: volume[4])
        }
        return converted
    }
   
    //MARK: - body Volume
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Please enter your value")) {
                    TextField("Enter volume", value: $inputVolume , format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section {
                    Picker("Select you value unit", selection: $convertFrom) {
                        ForEach(0..<volumeUnits.count, id: \.self) {
                            Text(volumeUnits[$0])
                        }
                    }
                }
               
                ForEach(0..<volumeUnits.count, id: \.self) { index in
                    if index != convertFrom {
                        Section(header: Text("Your value converted to \(volumeUnits[index])")) {
                            Text("\(converter(index).description)")
                        }
                    }
                }
            }
            .navigationTitle("Volume converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
