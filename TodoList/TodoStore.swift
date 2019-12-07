//
//  TodoStore.swift
//  TodoList
//
//  Created by Apollo Zhu on 12/6/19.
//  Copyright © 2019 UWAppDev. All rights reserved.
//

import Foundation
import SwiftUI

class TodoStore: ObservableObject {
  @Published var todos: [TodoItem] {
    didSet {
      UserDefaults.standard.set(try? JSONEncoder().encode(todos), forKey: "TODO")
    }
  }
  
  init() {
    todos = UserDefaults.standard.data(forKey: "TODO").flatMap {
      try? JSONDecoder().decode([TodoItem].self, from: $0)
    } ?? []
  }
  
  func add(_ title: String) {
    let item = TodoItem(title: title)
    todos.append(item)
  }
  
  func toggleComplete(_ item: TodoItem) {
    index(of: item).map { todos[$0].isCompleted.toggle() }
  }
  
  func updateTitle(of item: TodoItem, to newTitle: String) {
    index(of: item).map { todos[$0].title = newTitle }
  }
  
  func index(of item: TodoItem) -> Int? {
    return todos.firstIndex(of: item)
  }
  
  func remove(at index: Int) {
    todos.remove(at: index)
  }
}
