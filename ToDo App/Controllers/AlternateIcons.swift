//
//  AlternateIcons.swift
//  ToDo App
//
//  Created by A. Faruk Acar on 22.01.2024.
//

import SwiftUI

class AlternateIcons: ObservableObject {
    
    var iconNames: [String?] = [nil]
        //exact index we're at inside our icon names
        @Published var currentIndex = 0
        
        init() {
            getAlternateIconNames()
            print("TRYING TO GET ICONS")
            if let currentIcon = UIApplication.shared.alternateIconName{
                self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
                
            }
    }
        
        func getAlternateIconNames(){
        //looking into our info.plist file to locate the specific Bundle with our icons
                if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
                    let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
                {
                    print("Info.plist icons: \(icons)")
                    print("Alternate icons: \(alternateIcons)")

                     for (_, value) in alternateIcons{
                         print("VALue of alternateIcons", value)
                        //Accessing the name of icon list inside the dictionary
                         guard let iconList = value as? Dictionary<String,Any> else{return}
                         print("icon list: ", iconList)
                         //Accessing the name of icon files
                         guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                             else{
                             print("Error: Icon files array is empty or not found.")
                             return}
                         
                         print("icon files: ", iconFiles)
                             //Accessing the name of the icon
                         guard let icon = iconFiles.first else{
                             print("seconf else")
                             return}
                         print("ICON DATA: ", icon)
                         iconNames.append(icon)
            
                     }
                }
        }
}
