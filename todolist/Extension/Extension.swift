//
//  Extension.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 20.11.2024.
//

import Foundation

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
