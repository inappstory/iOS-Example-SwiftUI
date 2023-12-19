//
//  UserChangeView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of changing a user in an application
///
/// After initializing and configuring `InAppStory`, it may be necessary to change the user in the SDK,
/// for example after authorization. To do this, you need to create a new `Settings` object and set it to `InAppStory.shared.settings`.
///
/// If the application has a story list, `StoryListView` should be updated after setting a new UserID.
/// To update, it is necessary to specify a Binding variable and specify it when initializing `StoryListView`,
/// when this variable is changed, the list will be updated.
///
/// If the application does not use the `StoryListView` list, and only displays onboarding and single stories,
/// then after setting a new UserID, you don't need to do anything, the next time you call the reader,
/// the SDK will display stories for the new user.
///
/// Since SDK version 1.22.x, you can also add a closure to update the list, and call it when needed.
/// With this method, it is also possible to update the feed and tags for `InAppStory`
/// ```
/// @State var refreshClosure: ((_ feed: String?, _ tags: Array<String>?) -> Void)!
///
/// var body: some View {
///     StoryListView()
///     .refresh { refresh in
///         refreshClosure = refresh
///     }
/// }
///
/// func refreshStories() {
///     refreshClosure("new_feed", ["new_tag_1", "new_tag_2"])
/// }
/// ```
///
/// - Note: If it is necessary to display the list of stories or the reader's appearance differently for different users,
/// for example, an unauthorized user cannot like stories and add them to favorites,
/// it is recommended to set these settings immediately after setting a new UserID in `InAppStory`.
///
/// For more information see: [User change](https://docs.inappstory.com/sdk-guides/ios/user-change.html#user-change)
struct UserChangeView: View
{
    /// variable responsible for refresh story list
    @State var isStoryRefresh: Bool = false
    /// closure causing the list to be updated
    @State var refreshClosure: ((_ feed: String?, _ tags: Array<String>?) -> Void)!
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            /// stoies list creation
            StoryListView(refresh: $isStoryRefresh)
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
                /// closure passing the `refresh` method to refresh the list
                .refresh { refresh in
                    /// assignment of the `refresh` method to a local variable
                    refreshClosure = refresh
                }
                .frame(height: 150.0)
            HStack {
                Spacer()
                /// new user button
                Button("Change user") {
                    /// setting up a new user in InAppStory
                    InAppStory.shared.settings = .init(userID: "new_user")
                    /// refreshing the list via Binding variable
                    isStoryRefresh.toggle()
                }
                Spacer()
            }
            HStack {
                Spacer()
                /// new user button
                Button("Change user 2") {
                    /// setting up a new user in InAppStory
                    InAppStory.shared.settings = .init(userID: "new_user_2")
                    /// refreshing the list via closure
                    refreshClosure("new_feed", ["new_tag_1", "new_tag_2"])
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("User Change"))
    }
}

struct UserChangeView_Previews: PreviewProvider {
    static var previews: some View {
        UserChangeView()
    }
}
