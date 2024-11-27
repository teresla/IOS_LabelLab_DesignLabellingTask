//
//  LabellingTask.swift
//  LabelLab
//
//  Created by Teresa Windlin on 13.11.2024.
//

import Foundation
import SwiftUI

protocol LabellingTask: View, Identifiable {
    var id: UUID { get }
    var title: String { get }
    var description: String { get }
    var titelImage: Image { get }
}


