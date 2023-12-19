//
//  MultifeedOnboardingView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using onboarding with custom feed
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
/// With onboarding display you can display any feed you have created in your console, to do this you need to specify
/// the name of the feed you want to display when specifying the `onboardingStories` modifier. In this case,
/// the onboarding logic remains unchanged and the reader will only show stories that the user has not yet opened.
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
struct MultifeedOnboardingView: View
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
            feed: "custom_feed", /// set custom feed id for onboarding list
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

struct MultifeedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
