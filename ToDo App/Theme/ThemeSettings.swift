//
//  ThemeSettings.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 23.01.2024.
//

import SwiftUI

final public class ThemeSettings: ObservableObject {
  @Published public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
    didSet {
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
 
  private init() {}
  public static let shared = ThemeSettings()
}
