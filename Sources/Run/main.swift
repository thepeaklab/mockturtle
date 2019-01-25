//
//  main.swift
//  Run
//
//  Created by Christoph Pageler on 16.11.18.
//


import App


do {
    try app(.detect()).run()
} catch {
    print("failed: \(error)")
}
