//
//  ContentView.swift
//  TodoList
//
//  Created by Apollo Zhu on 12/6/19.
//  Copyright © 2019 UWAppDev. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
  @State var editMode: EditMode = .inactive
  
  @EnvironmentObject var database: TodoStore
  
  var body: some View {
    NavigationView {
      List {
        ForEach(database.todos) { item in
          NavigationLink(
            destination: TodoItemDetailView(item: item)
          ) {
            TodoItemRow(item: item)
              .environment(\.editMode, self.$editMode.animation())
          }
        }
        .onDelete { (indices) in
          self.database.remove(at: indices.first!)
        }
        TodoItemNewEntry()
      }
      .navigationBarTitle("Todo")
      .navigationBarItems(trailing: EditButton())
      .environment(\.editMode, $editMode.animation())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(TodoStore())
  }
}

struct TodoItemRow: View {
  var item: TodoItem
  
  @EnvironmentObject var database: TodoStore
  @Environment(\.editMode) var editMode
  
  var body: some View {
    HStack {
      if editMode?.wrappedValue != .active {
        Image(systemName:
          item.isCompleted ? "checkmark.circle.fill" : "circle")
          .imageScale(.large)
          .foregroundColor(item.isCompleted ? .green : .primary)
          .onTapGesture {
            self.database.toggleComplete(self.item)
        }
      }
      TextField(item.title,
                text: database.index(of: item)
                  .map { $database.todos[$0].title }
                  ?? .constant(item.title))
      Spacer()
    }
  }
}

struct TodoItemDetailView: View {
  var item: TodoItem
  
  @State private var isPresentingAlert = false
  
  var body: some View {
    ScrollView {
      Text(item.title)
        .font(.largeTitle)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               alignment: .leading)
        .padding()
        .onTapGesture(count: 2) {
          UIPasteboard.general.string = self.item.title
          self.isPresentingAlert = true
      }
      .alert(isPresented: $isPresentingAlert) {
        Alert(title: Text("Copied"))
      }
    }.navigationBarTitle("Details")
  }
}

struct TodoItemNewEntry: View {
  @EnvironmentObject var database: TodoStore
  @State private var newTodo: String = ""
  
  var body: some View {
    HStack {
      Image(systemName: "circle")
        .imageScale(.large)
        .foregroundColor(
          newTodo.isEmpty ? Color(.systemGray3) : .primary
      )
      TextField("New TODO", text: $newTodo) {
        withAnimation {
          self.database.add(self.newTodo)
          self.newTodo = ""
        }
      }
    }
  }
}
