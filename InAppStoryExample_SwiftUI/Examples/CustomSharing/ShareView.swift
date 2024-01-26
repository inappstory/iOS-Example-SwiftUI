//
//  ShareView.swift
//  InAppStorySUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of a window of custom sharing
struct ShareView: View {
    /// Tracking the display status to control the window display   
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /// object that contains data to be shared
    /// - `text` - plain text <String?>;
    /// - `images` - image array <Array<UIImage>?>;
    /// - `link` -  link <String?>;
    /// - `payload` - custom data set in the console when creating the widget "Share <String?>;
    var shareObject: SharingObject
    /// closure that must be called when unsharing is finished (e.g. closing the sharing window)
    var complete: (Bool) -> Void
    /// This closure is called if the user wants to use system sharing and taps the relevant button.
    var defaultComplete: () -> Void
    
    @State private var message: String?
    
    private var sharedActions: Array<SharingAction> {
        get {
            /// get the list of actions
            generateActions()
        }
    }
    /// Initializing View
    init(shareObject: SharingObject, complete: ((Bool) -> Void)? = nil, defaultComplete: (() -> Void)? = nil) {
        self.shareObject = shareObject
        self.complete = complete ?? { _ in }
        self.defaultComplete = defaultComplete ?? { }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                /// half-background in the form of a button that closes the sharing window when pressed
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                    complete(false)
                } label: {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                }
                
                ZStack(alignment: .center) {
                    VStack {
                        /// top part of the sharing window with title and close button
                        ZStack(alignment: .trailing) {
                            /// title
                            Text("Share")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                            Spacer()
                            /// close button
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                                self.complete(false)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .imageScale(.large)
                            }
                            
                        }
                        /// list of possible sharing actions
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                /// a button is created for each action from the list
                                ForEach(sharedActions, id: \.self) { action in
                                    Button {
                                        /// when the button is pressed, a link is generated to open it in the corresponding application
                                        if let url = action.generateURL(sharingObject: shareObject) {
                                            /// opening the url schema link
                                            UIApplication.shared.open(url)
                                            /// close the sharing window
                                            self.presentationMode.wrappedValue.dismiss()
                                            /// call closure indicating successful sharing
                                            self.complete(true)
                                        }
                                    } label: {
                                        /// icon and the name of the place where sharing will take place
                                        VStack(alignment: .center) {
                                            Image(action.icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(16)
                                                .frame(width: 60, height: 60)
                                            Text(action.title)
                                                .font(.system(size: 11))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                Button {
                                    /// close the sharing window
                                    self.presentationMode.wrappedValue.dismiss()
                                    /// call closure on which you want to show the system window of sharing
                                    defaultComplete()
                                } label: {
                                    /// icon and the name of the place where sharing will take place
                                    VStack(alignment: .center) {
                                        ZStack(alignment: .center) {
                                            Image(systemName: "ellipsis")
                                                .imageScale(.large)
                                                .foregroundColor(.gray)
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .cornerRadius(16)
                                                .frame(width: 60, height: 60)
                                        }
                                        Text("More...")
                                            .font(.system(size: 11))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 8)
                        /// if there is something to check, a separator is added.
                        if shareObject.link != nil || shareObject.images != nil && !shareObject.images!.isEmpty {
                            Divider()
                                .padding(.bottom, 8)
                        }
                        /// if the sharing object contains a link, then show the button to copy it
                        if shareObject.link != nil {
                            button(title: "Copy link", imageName: "") {
                                UIPasteboard.general.string = shareObject.link!
                                /// after copying show the message
                                showMesage("Link copied to clipboard")
                            }
                        }
                        /// if the sharing object contains images, show the button to copy it
                        if let images = shareObject.images, !images.isEmpty {
                            button(title: "Copy image", imageName: "") {
                                UIPasteboard.general.images = shareObject.images
                                /// after copying show the message
                                showMesage("Image copied to clipboard")
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Rectangle()
                    .fill(.white)
                    .cornerRadius(16))
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
            /// show copy message
            if let textMessage = message {
                ZStack(alignment: .center) {
                    Text(textMessage)
                        .foregroundColor(.white)
                        .font(Font.system(size: 14))
                        .padding(16)
                        .background(Capsule()
                            .fill(.black.opacity(0.7)))
                }
                .transition(.opacity)
            }
        }
    }
    
    /// Generating actions for the sharing window
    func generateActions() -> Array<SharingAction> {
        var actions: Array<SharingAction> = []
        /// Telegram
        /// if it was possible to get a link to open the application (url schema)
        if let telegramUrl = URL(string: SharingAction.telegram.url) {
            /// if the received link can be opened
            if UIApplication.shared.canOpenURL(telegramUrl) {
                /// if the object has a link field
                if shareObject.link != nil {
                    /// adding an action to the list
                    actions.append(.telegram)
                }
            }
        }
        /// WhatsApp
        /// /// if it was possible to get a link to open the application (url schema)
        if let whatsappUrl = URL(string: SharingAction.whatsapp.url) {
            /// if the received link can be opened
            if UIApplication.shared.canOpenURL(whatsappUrl) {
                /// if the object has a link field
                if shareObject.link != nil {
                    /// adding an action to the list
                    actions.append(.whatsapp)
                }
            }
        }
        /// Instagram
        /// /// if it was possible to get a link to open the application (url schema)
        if let instagramUrl = URL(string: SharingAction.instagram.url) {
            /// if the received link can be opened
            if UIApplication.shared.canOpenURL(instagramUrl) {
                /// if the object has an images field and the list of images is not empty
                if shareObject.images != nil && !shareObject.images!.isEmpty {
                    /// adding an action to the list
                    actions.append(.instagram)
                }
            }
        }
        /// iMessage system application
        /// /// if it was possible to get a link to open the application (url schema)
        if let smsUrl = URL(string: SharingAction.sms.url) {
            /// if the received link can be opened
            if UIApplication.shared.canOpenURL(smsUrl) {
                /// if the object has a link field
                if shareObject.link != nil {
                    /// adding an action to the list
                    actions.append(.sms)
                }
            }
        }
        
        return actions
    }
    
    /// display the message to be copied
    func showMesage(_ text: String) {
        withAnimation(.easeIn(duration: 0.2)) {
            message = text
        }
        
        /// 1 sec delay for displaying the message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 0.2)) {
                message = nil
            }
            
            /// closing the sharing window after displaying the message
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.presentationMode.wrappedValue.dismiss()
                /// call closure indicating successful sharing
                self.complete(true)
            }
        }
    }
    
    /// Button generation
    /// - Parameters:
    ///   - title: title
    ///   - stratche: if set, stretches the button across the screen width
    ///   - imageName: if you need to set an image for a button
    ///   - action: button tap closure
    /// - Returns: button view
    func button(title: String, stratche: Bool = true, imageName: String, _ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: imageName)
                    .imageScale(.large)
                    .font(.system(size: 16.0))
                    .foregroundColor(.white)
                if title != "" {
                    Text(title)
                        .font(.system(size: 16.0))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: stratche ? .infinity : nil)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.blue)
        )
    }
}
