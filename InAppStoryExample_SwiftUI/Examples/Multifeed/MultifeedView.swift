//
//  SimpleIntegrationView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using Multi-feed functionality
///
/// In order to display several different ribbons on the screen, it is necessary to specify different feeds for them during initialization.
/// ```
/// StoryListView(feed: "custom_feed")
///     .onUpdate { isContent, storyType in
///         if isContent {
///             switch storyType {
///             case .list(let feed):
///                 print("StoryView has content in feed \(feed ?? "")")
///             case .single:
///                 print("SingleStory has content")
///             case .onboarding(let feed):
///                 print("Onboarding has content in feed \(feed)")
///             case .ugcList:
///                 print("UGC StoryView has content")
///             @unknown default:
///                 break
///             }
///         } else {
///             print("No content")
///         }
///     }
/// ```
///
/// For more information see: [Multi-feed](https://docs.inappstory.com/sdk-guides/ios/multi-feed.html#multi-feed)
struct MultifeedView: View
{
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            /// stoies list creation
            StoryListView()
                /// closure is triggered when the story list is refreshed
                /// is called even if the new value of the list is identical to the old one.
                /// - Parameters:
                ///   - isContent: boolean variable indicating the presence of stories in the list
                ///   - storyType: the type of stories that have been opened, depending on the source
                ///
                /// ### StoriesType
                /// - `.list(feed: <String>?)` - type for StoryView, *feed* - id stories list;
                /// - `.single` - type for single story reader;
                /// - `.onboarding(feed: <String>)` - type for onboarding story reader, *feed* - id stories list.
                .onUpdate { isContent, storyType in
                    if isContent {
                        switch storyType {
                        case .list(let feed):
                            print("StoryView has content in feed \(feed ?? "")")
                        case .single:
                            print("SingleStory has content")
                        case .onboarding(let feed):
                            print("Onboarding has content in feed \(feed)")
                        case .ugcList:
                            print("UGC StoryView has content")
                        @unknown default:
                            break
                        }
                    } else {
                        print("No content")
                    }
                }
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
                .onAction { target, type, storyType in
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
                .padding(.bottom)
            StoryListView(feed: "custom_feed") /// Stories list with custom feed id
                .onAction { target, type, storyType in
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
        .navigationBarTitle(Text("Multi feed"))
    }
}

struct MultifeedView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntegrationView()
    }
}
