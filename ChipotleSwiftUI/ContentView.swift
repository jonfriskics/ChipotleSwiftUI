//
//  ContentView.swift
//  ChipotleSwiftUI
//
//  Created by Jon Friskics on 7/27/20.
//

import SwiftUI

struct Meat: Identifiable, Equatable {
  var id = UUID()
  var meat_name: String
  var meat_price: String
  var meat_nutrition: String
  var meat_image_string: String
  var meat_selected: Bool
  
  static func ==(lhs: Meat, rhs: Meat) -> Bool {
      return lhs.id == rhs.id
  }
}

struct ContentView: View {
  
  @State var meats_tapped: [Meat] = []
  @State private var showAlert = false
  @State private var alert_position = 0
  
  var meat_data: [Meat] = [
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false),
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false),
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false),
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false),
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false),
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false),
    Meat(meat_name: "Chicken", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false)
  ]
    
  var body: some View {
    NavigationView {
      List {
        Section(header: ListHeader(meats_tapped: $meats_tapped)) {
          ForEach(meat_data.indices) { idx in
            CellContent(meat: meat_data[idx], meats_tapped: $meats_tapped, show_alert: $showAlert)
              .padding(.vertical, 10.0)
              .onTapGesture {
                if(self.meats_tapped.count >= 2) {
                  self.showAlert = true
                } else {
                  self.meats_tapped.append(meat_data[idx])
                }
              }
          }
        }
      }
      .listStyle(PlainListStyle())
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          VStack {
            Text("Build your")
              .font(.subheadline)
            Text("Burrito")
              .font(.headline)
              .textCase(.uppercase)
          }
        }
        ToolbarItem(placement: .bottomBar) {
          Text("Add to bag")
            .textCase(.uppercase)
        }
      }
    }
  }
}

struct ListHeader: View {
  @Binding var meats_tapped: [Meat]
  
  var body: some View {
    HStack {
      Spacer()
      Text("Filling \(meats_tapped.count)")
        .font(.headline)
        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
      Spacer()
    }
  }
}

struct CellContent: View {
  var meat: Meat
  @Binding var meats_tapped: [Meat]
  @Binding var show_alert: Bool

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if(show_alert) {
          ZStack {
            Text("No more meat").foregroundColor(Color.white)
          }.background(Color.black)
        }
        Image(meat.meat_image_string)
          .resizable()
          .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        VStack {
          Text(meat.meat_name)
            .font(.system(size: 20))
            .fontWeight(.heavy)
            .padding(.bottom, 10.0)
          HStack {
            Text(meat.meat_price)
              .font(.subheadline)
            Text(meat.meat_nutrition)
              .font(.subheadline)
          }
        }
        Spacer()
        VStack(alignment: .trailing) {
          HStack {
            if(meats_tapped.contains(meat)) {
              Text("1/2")
            }
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
