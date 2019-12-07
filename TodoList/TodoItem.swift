//
//  TodoItem.swift
//  TodoList
//
//  Created by Apollo Zhu on 12/6/19.
//  Copyright © 2019 UWAppDev. All rights reserved.
//

import Foundation

struct TodoItem: Equatable, Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
