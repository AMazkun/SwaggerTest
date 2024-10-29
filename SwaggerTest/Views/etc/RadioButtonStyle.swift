//
//  RadioButtonStyle.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

struct RadioButton: View {
    @Binding private var isSelected: Bool
    private let label: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
           circleView
           labelView
        }
        .contentShape(Rectangle())
        .onTapGesture { isSelected = true }
    }


  @ViewBuilder var labelView: some View {
      if !label.isEmpty { // Show label if label is not empty
        Text(label)
      }
  }
  
  @ViewBuilder var circleView: some View {
     Circle()
       .fill(innerCircleColor) // Inner circle color
       .padding(4)
       .overlay(
          Circle()
            .stroke(outlineColor, lineWidth: 1)
        ) // Circle outline
       .frame(width: 20, height: 20)
  }
   var innerCircleColor: Color {
      return isSelected ? Color.blue : Color.clear
   }

   var outlineColor: Color {
      return isSelected ? Color.blue : Color.gray
   }

   // To support multiple options
    init<V: Hashable>(tag: V, selection: Binding<V?>, label: String = "") {
      self._isSelected = Binding(
        get: { selection.wrappedValue == tag },
        set: { _ in selection.wrappedValue = tag }
      )
      self.label = label
    }
}

enum Option {
  case a
  case b
  case c
}

struct PreviewProvider_RB : PreviewProvider {
    static var previews: some View {
        
    @State var selectedOption: Option? = nil
    VStack {
      RadioButton(tag: .a, selection: $selectedOption, label: "Option A")
      RadioButton(tag: .b, selection: $selectedOption, label: "Option B")
      RadioButton(tag: .c, selection: $selectedOption, label: "Option C")
    }
  }
}
