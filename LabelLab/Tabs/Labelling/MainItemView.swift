//
//  MainItemView.swift
//  LabelLab
//
//  Created by Teresa Windlin on 19.11.2024.
//
import SwiftUI

struct MainItemView: View {
    let task: any LabellingTask
    
    var body: some View {
        VStack() {
            task.titelImage
            Text(task.title)
        }
    }
}

