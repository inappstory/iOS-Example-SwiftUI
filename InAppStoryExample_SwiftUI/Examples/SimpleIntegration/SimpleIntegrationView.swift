//
//  SimpleIntegrationView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI 
import InAppStorySDK_SwiftUI

/// Example of a simple stories list integration
///
/// To work correctly, you need to specify *serviceKey* for SDK in ``ContentView``.
///
/// For more info, see [Basic initialization](https://docs.inappstory.com/sdk-guides/ios/how-to-get-started.html#basic-initialization)
struct SimpleIntegrationView: View
{
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
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
        .navigationBarTitle(Text("Simple integration"))
    }
}

struct SimpleIntegrationView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntegrationView()
    }
}
