//
//  ConversationManager+EditorObject.swift
//  FlowDown
//
//  Created by 秋星桥 on 1/31/25.
//

import AlertController
import Combine
import ConfigurableKit
import Foundation
import RichEditor
import Storage

extension ConversationManager {
    func getRichEditorObject(identifier: Conversation.ID) -> RichEditorView.Object? {
        temporaryEditorObjects[identifier]
    }

    func setRichEditorObject(identifier: Conversation.ID, _ object: RichEditorView.Object?) {
        if let object {
            temporaryEditorObjects[identifier] = object
        } else {
            temporaryEditorObjects.removeValue(forKey: identifier)
        }
    }

    func clearRichEditorObject() {
        temporaryEditorObjects.removeAll()
    }
}

extension ConversationManager {
    static let removeAllEditorObjectsPublisher: PassthroughSubject<Void, Never> = .init()
    static let removeAllEditorObjects: ConfigurableObject = .init(
        icon: "eraser",
        title: String(localized: "Clear Editing"),
        explain: String(localized: "This will delete all edits, including unsent conversation text and attachments."),
        ephemeralAnnotation: .action { controller in
            let alert = AlertViewController(
                title: String(localized: "Clear Editing"),
                message: String(localized: "This will delete all edits, including unsent conversation text and attachments.")
            ) { context in
                context.addAction(title: String(localized: "Cancel")) {
                    context.dispose()
                }
                context.addAction(title: String(localized: "Clear"), attribute: .dangerous) {
                    context.dispose {
                        ConversationManager.shared.clearRichEditorObject()
                        removeAllEditorObjectsPublisher.send(())
                        Indicator.present(
                            title: String(localized: "Done"),
                            preset: .done,
                            haptic: .success,
                            referencingView: controller?.view
                        )
                    }
                }
            }
            controller?.present(alert, animated: true)
        }
    )
}
