//
//  ContentView.swift
//  Lateral Thinking macOS
//
//  Created by Paul Wood on 7/26/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
