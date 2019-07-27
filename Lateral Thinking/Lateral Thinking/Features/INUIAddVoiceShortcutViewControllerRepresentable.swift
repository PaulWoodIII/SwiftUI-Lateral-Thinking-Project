//
//  INUIAddVoiceShortcutViewControllerRepresentable.swift
//  Lateral Thinking
//
//  Created by Paul Wood on 7/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import IntentsUI

class INUIAddVoiceShortcutViewControllerRepresentableDelegate: NSObject, INUIAddVoiceShortcutViewControllerDelegate {
  
  func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                      didFinishWith voiceShortcut: INVoiceShortcut?,
                                      error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
  
  func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

class INUIAddVoiceShortcutViewControllerRepresentableCoordinator: NSObject {
  let delegate = INUIAddVoiceShortcutViewControllerRepresentableDelegate()
}

struct INUIAddVoiceShortcutViewControllerRepresentable: UIViewControllerRepresentable {
  
  func updateUIViewController(_ uiViewController: INUIAddVoiceShortcutViewController,
                              context: UIViewControllerRepresentableContext<INUIAddVoiceShortcutViewControllerRepresentable>) {
    
  }
    
  typealias UIViewControllerType = INUIAddVoiceShortcutViewController
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<INUIAddVoiceShortcutViewControllerRepresentable>) -> INUIAddVoiceShortcutViewController {
    let vc = INUIAddVoiceShortcutViewController(shortcut: ShortcutMaker.makeShortcut())
    vc.delegate = context.coordinator.delegate
    return vc
  }
  
  func makeCoordinator() -> INUIAddVoiceShortcutViewControllerRepresentableCoordinator {
    return INUIAddVoiceShortcutViewControllerRepresentableCoordinator()
  }
}

#if DEBUG
struct SwiftUISiriDonateViewController_Previews: PreviewProvider {
    static var previews: some View {
        INUIAddVoiceShortcutViewControllerRepresentable()
    }
}
#endif
