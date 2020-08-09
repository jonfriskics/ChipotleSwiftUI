//
//  ContentView.swift
//  ChipotleSwiftUI
//
//  Created by Jon Friskics on 7/27/20.
//

import SwiftUI

class Meat: Identifiable, Equatable, ObservableObject {
  @Published var id = UUID()
  @Published var meat_name: String = "meat name"
  @Published var meat_price: String = "meat price"
  @Published var meat_nutrition: String = "meat nutrition"
  @Published var meat_image_string: String = "meat image string"
  @Published var meat_selected: Bool = false
  @Published var show_alert: Bool = false
  
  init(meat_name: String, meat_price: String, meat_nutrition: String, meat_image_string: String, meat_selected: Bool, show_alert: Bool) {
    self.meat_name = meat_name
    self.meat_price = meat_price
    self.meat_nutrition = meat_nutrition
    self.meat_image_string = meat_image_string
    self.meat_selected = meat_selected
    self.show_alert = show_alert
  }
  
  static func ==(lhs: Meat, rhs: Meat) -> Bool {
    return lhs.id == rhs.id
  }
  
}

class ViewModel: ObservableObject {
  @Published var meats: [Meat] = []
  
  init() {
    self.meats = [
      Meat(meat_name: "Chicken1", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false),
      Meat(meat_name: "Chicken2", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false),
      Meat(meat_name: "Chicken3", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false),
      Meat(meat_name: "Chicken4", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false),
      Meat(meat_name: "Chicken5", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false),
      Meat(meat_name: "Chicken6", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false),
      Meat(meat_name: "Chicken7", meat_price: "$7.00", meat_nutrition: "180 cal", meat_image_string: "chipotle-guacamole", meat_selected: false, show_alert: false)
    ]
  }
}

func totalMeatsSelected(meat_data: [Meat]) -> Int {
  var total_meats_selected = 0
  for m in meat_data {
    if(m.meat_selected) {
      total_meats_selected += 1
    }
  }
  return total_meats_selected
}

struct ContentView: View {
  @ObservedObject var view_model = ViewModel()
  
  var body: some View {
    NavigationView {
      List {
        Section(header: ListHeader()) {
          ForEach(view_model.meats) { meat in
            CellContent(meat: meat, total_meats_selected: totalMeatsSelected(meat_data: view_model.meats))
            .onTapGesture {
              updateMeat(meat: meat)
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
  func updateMeat(meat: Meat) {
    if let index = self.view_model.meats.firstIndex(where: {$0.id == meat.id}) {
      let meat_selected = meat.meat_selected == false && totalMeatsSelected(meat_data: self.view_model.meats) < 2 ? true : false
      let show_alert = totalMeatsSelected(meat_data: self.view_model.meats) == 2 ? true : false
      let new_meat = Meat(meat_name: meat.meat_name,
                          meat_price: meat.meat_price,
                          meat_nutrition: meat.meat_nutrition,
                          meat_image_string: meat.meat_image_string,
                          meat_selected: meat_selected,
                          show_alert: show_alert)
      self.view_model.meats[index] = new_meat
      if(totalMeatsSelected(meat_data: self.view_model.meats) < 2) {
        clearAlerts(view_model: self.view_model)
      }
    }
  }
  func clearAlerts(view_model: ViewModel) {
    for (index, meat) in view_model.meats.enumerated() {
      let new_meat = Meat(meat_name: meat.meat_name,
                          meat_price: meat.meat_price,
                          meat_nutrition: meat.meat_nutrition,
                          meat_image_string: meat.meat_image_string,
                          meat_selected: meat.meat_selected,
                          show_alert: false)
      self.view_model.meats[index] = new_meat
    }
  }
}

struct ListHeader: View {
  var body: some View {
    HStack {
      Spacer()
      Text("Filling")
        .font(.headline)
        .textCase(.uppercase)
      Spacer()
    }
  }
}

struct CellContent: View {
  @ObservedObject var meat: Meat
  var total_meats_selected: Int

  var body: some View {
    VStack(alignment: .leading) {
      if(meat.show_alert) {
        ZStack {
          Text("No more meat").foregroundColor(Color.white)
        }.background(Color.black).padding(5)
      }
      HStack {
        Image(meat.meat_image_string)
          .resizable()
          .frame(width: 80, height: 80, alignment: .center)
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
            if(meat.meat_selected && total_meats_selected == 1) {
              Text("✔")
            } else if(meat.meat_selected && total_meats_selected == 2) {
              Text("½")
            }
          }
        }
      }
    }
    .padding(.vertical, 10.0)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
