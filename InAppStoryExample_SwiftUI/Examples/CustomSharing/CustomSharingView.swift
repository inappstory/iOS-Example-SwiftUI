//
//  CustomSharingView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// To simplify the readability of the code, enter typealias for closure at the end of sharing.
typealias ShareComplete = (Bool) -> Void

/// Example of using a custom modal window for sharing.
///
/// To work correctly, you need to specify *serviceKey* for SDK in ``ContentView``.
///
/// To use URL schema, you need to add their list to info.plist
///
/// ```
/// <key>LSApplicationQueriesSchemes</key>
/// <array>
///     <string>tg</string>
///     <string>instagram</string>
///     <string>instagram-stories</string>
///     <string>whatsapp</string>
/// </array>
/// ```
struct CustomSharingView: View {
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "1")
        /// Set the closure that will be called when the share button is pressed in the reader
        InAppStory.shared.customShare = customShare(shareObject:complete:)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            /// stoies list creation
            StoryListView()
                /// closure, called when a button or SwipeUp event is triggered in the reader
                /// - Parameters:
                ///   - target: the action by which the link was obtained
                ///   - type: type of action that called this method
                ///   - storyType: the type of stories that have been opened, depending on the source
                ///
                /// ### ActionType
                /// - `.button` - push the button in story;
                /// - `.swipe` - swipe up slide in story;
                /// - `.game` - link from Game;
                /// - `.deeplink` - deeplink from cell in story list.
                ///
                /// ### StoriesType
                /// - `.list(feed: <String>?)` - type for StoryView, *feed* - id stories list;
                /// - `.single` - type for single story reader;
                /// - `.onboarding(feed: <String>)` - type for onboarding story reader, *feed* - id stories list.
                .onAction { target, type, actionType in
                    /// Closing the story reader before clicking a link, if the link does not open
                    /// the internal screen of the story, you don't need to close it, the reader will stop playing
                    /// the timers and on returning from a third-party browser to the app, will start the timers again.
                    ///
                    /// If the link implies displaying the application screen,
                    /// you can close the reader and go to the desired screen.
                    ///
                    /// You can also use the `InAppStory.present(...)` method,
                    /// with the help of which you can display the screen on top of the reader,
                    /// for this you need to wrap the new screen you want to
                    /// show in `UIHostingController` and pass it to `.present`.
                    /// ```
                    /// InAppStory.shared.present(controller: UIHostingController(rootView: NewView()))
                    /// ```
                    InAppStory.shared.closeReader {
                        if let url = URL(string: target) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom sharing view"))
    }
    
    /// Function that handles closure, which is called when the reader's sharings button is pressed.
    /// - Parameters:
    ///   - shareObject: object that contains data to be shared
    ///   - complete: closure that must be called when unsharing is finished (e.g. closing the sharing window)
    ///
    /// ### SharingObject
    /// - `text` - plain text <String?>;
    /// - `images` - image array <Array<UIImage>?>;
    /// - `link` -  link <String?>;
    /// - `payload` - custom data set in the console when creating the widget "Share <String?>;
    func customShare(shareObject: SharingObject, complete: @escaping ShareComplete) {
        /// Creating a custom sharing window instance
        let customShareView = ShareView(shareObject: shareObject, complete: complete, defaultComplete: {
            /// This closure is called if the user wants to use system sharing and taps the relevant button, see ``ShareView/defaultComplete``.
            defaultShareComplete(shareObject: shareObject, complete: complete)
        })
        /// To display items on top of the reader, *InAppStorySDK* only supports `UIViewController`,
        /// so you need to wrap the custom view of the sharing window in `UIHostingController`.
        let newController = UIHostingController(rootView: customShareView)
        /// For the controller to be displayed on top of the reader without overlapping it, it is necessary to specify a transparent background for it
        newController.view.backgroundColor = .clear
        /// Display the controller on top of the reader
        InAppStory.shared.present(controller: newController, with: .crossDissolve)
    }
    
    /// Method of displaying the system window of sharing
    /// - Parameters:
    ///   - shareObject: object that contains data to be shared
    ///   - complete: closure that must be called when unsharing is finished (e.g. closing the sharing window)
    ///
    /// ### SharingObject
    /// - `text` - plain text <String?>;
    /// - `images` - image array <Array<UIImage>?>;
    /// - `link` -  link <String?>;
    /// - `payload` - custom data set in the console when creating the widget "Share <String?>; 
    func defaultShareComplete(shareObject: SharingObject, complete: ((Bool) -> Void)? = nil) {
        /// Creating a list of objects for sharing
        var items = [Any]()
        /// If the object contains text
        if let text = shareObject.text {
            items.append(text)
        }
        /// If the object contains link
        if let url = shareObject.link {
            items.append(url)
        }
        /// If the object contains images
        if let images = shareObject.images, !images.isEmpty {
            for image in images {
                items.append(image)
            }
        }
        
        /// Create `UIActivityViewController` for displaying on top of the reader. Because `UIActivityViewController`
        /// is an inheritor of `UIViewController` class, there is no need to do anything with it before displaying.
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        /// On closure of the sharding, it should be passed to the closure with what result it was completed.
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if let completeSharing = complete {
                if success {
                    completeSharing(true)
                } else {
                    completeSharing(false)
                }
                
                if error != nil {
                    completeSharing(false)
                }
            }
        }
        
        /// Display the controller on top of the reader
        InAppStory.shared.present(controller: activityViewController, with: .crossDissolve)
    }
}

struct CustomSharingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSharingView()
    }
}
