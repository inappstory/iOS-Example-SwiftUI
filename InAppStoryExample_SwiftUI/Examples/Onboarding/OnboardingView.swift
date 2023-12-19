//
//  OnboardingView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of a screen using onboarding
///
/// Onboarding is used to show a single story or list of stories to a user.
/// The uniqueness of displays is determined by *UserID* set in `InAppStory.shared.settings`.
///
/// If this user was shown a story from the onboarding list and the same story exists in the `StoryListView` list,
/// it will automatically set to read. Also, if a story from the `StoryListView` list was read before the onboarding was shown,
/// it will not appear in the onboarding reader.
///
/// There are scenarios where the user ID cannot be obtained before displaying the onboarding (e.g. unauthorized user).
/// In such cases, the uniqueness of the view is determined by `UIDevice.current.identifierForVendor`.
/// In this case, an unauthorized user with `ID==""` will not have the onboarding shown more than once.
///
/// - Attention: Since `UIDevice.current.identifierForVendor` is provided only as long as the application
/// or applications from this developer are installed on the device, after reinstalling the application and if there are no other
/// applications from this developer installed, `identifierForVendor` will change, which will cause the onboarding
/// for a user without an ID to be displayed again.
///
/// # A simple display of onboarding
/// To show onboarding, you need to set the `.onboardingStories` modifier and
/// specify its Binding variable `isPresented`. If it is set to true, the reader will be shown.
/// ```
/// @State var isOnboardingPresent: Bool = false
///
/// var body: some View {
///     VStack() {
///     ...
///     }
///     .onboardingStories(isPresented: $isOnboardingPresent)
/// }
/// ```
///
/// # Custom feed
/// With onboarding display you can display any feed you have created in your console, to do this you need to specify
/// the name of the feed you want to display when specifying the `onboardingStories` modifier. In this case,
/// the onboarding logic remains unchanged and the reader will only show stories that the user has not yet opened.
/// Example see in ``MultifeedOnboardingView``
/// ```
/// @State var isOnboardingPresent: Bool = false
///
/// var body: some View {
///     VStack() {
///     ...
///     }
///     .onboardingStories(feed: "OtherFeed",
///                        isPresented: $isOnboardingPresent)
/// }
/// ```
///
/// # Limitations
/// If you want to limit the display of the onboarding feed to a few stories and not show the full feed at once,
/// you need to set a limit when specifying the `onboardingStories` modifier
/// ```
/// @State var isOnboardingPresent: Bool = false
///
/// var body: some View {
///     VStack() {
///     ...
///     }
///     .onboardingStories(limit: 2,
///                        isPresented: $isOnboardingPresent)
/// }
/// ```
///
/// # Tags
/// To show onboarding, you can set a separate list of tags different from the one set in `Settings(userID: String, tags: Array<String>)`. 
/// In this case, onboarding will ignore the list of tags set in `InAppStory.shared.settings`.
/// ```
/// @State var isOnboardingPresent: Bool = false
///
/// var body: some View {
///     VStack() {
///     ...
///     }
///     .onboardingStories(tags: ["new_tag1", "new_tag2"],
///                        isPresented: $isOnboardingPresent)
/// }
/// ```
///
/// # PanelSettings
/// For an onboarding reader instance, you can set unique bottom panel settings that will ignore those set for `StoryListView`. 
/// In this way, you can disable the bottom panel functionality that is not required for onboarding.
/// ```
/// @State var isOnboardingPresent: Bool = false
///
/// var body: some View {
///     VStack() {
///     ...
///     }
///     .onboardingStories(panelSettings: PanelSettings(like: false),
///                        isPresented: $isOnboardingPresent)
/// }
/// ```
///
/// For more information see: [Onboarding](https://docs.inappstory.com/sdk-guides/ios/onboardings.html#onboardings)
struct OnboardingView: View
{
    /// variable responsible for displaying onboarding
    @State var isOnboardingPresent: Bool = false
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            /// stoies list creation
            StoryListView()
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Onboarding"))
        .onAppear() {
            /// change the variable for displaying onboarding
            isOnboardingPresent = true
        }
        /// onboarding modifier
        .onboardingStories(
            limit: 2, /// two story limit
            isPresented: $isOnboardingPresent, /// reader display
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
            onAction: { target, actionType in
                isOnboardingPresent = false /// may call InAppStory.shared.closeReader()
            })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
