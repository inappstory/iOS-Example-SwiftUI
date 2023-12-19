//
//  SingleView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using a single story display
///
/// To show a single story, you need to know its ID specified in the console.
/// To display stories on the screen, just call `InAppStory.shared.showSingle`.
///
/// As a target, it is desirable to specify the top controller in the screen hierarchy to properly display
/// the reader on top of all application elements.
///
/// If you want to change the appearance or animation of the reader's show, only for displaying single story,
/// you need to set parameters in `InAppStory` before  `singleStory()` modifire affected.
/// For more information on reader customization, see ``ReaderCustomizationView``.
///
/// - Warning: Changes set for single reader customization will be applied to the whole library.
/// In order to return the original settings for other readers, it is necessary in the `storyReaderDidClose` closure
/// to set the reader settings as they were before the single reader was displayed.
///
/// - Note: If initially, some display parameters were set by default and were not changed,
/// before displaying the single reader with custom settings, they should be saved and applied
/// to `InAppStory` after closing the reader.
///
/// The only thing that can be changed independently is the display of the bottom panel using the `PanelSettings` object
/// when `singleStory()` is called, this change will not affect other readers and will only be used to display a particular story.
///
/// # PanelSettings
/// For an single reader instance, you can set unique bottom panel settings that will ignore those set for `StoryView`.
/// In this way, you can disable the bottom panel functionality that is not required for onboarding.
/// ```
/// @State var isSinglePresent: Bool = false
///
/// var body: some View {
///     VStack() {
///     ...
///     }
///     .singleStory(storyID: "story_id",
///                  panelSettings: PanelSettings(like: false),
///                  isPresented: $isSinglePresent)
/// }
/// ```
///
/// For more information see [Single story](https://docs.inappstory.com/sdk-guides/ios/single-story.html#single-story)
struct SingleView: View
{
    /// variable responsible for displaying single story
    @State var isSinglePresent: Bool = false
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Show Single Story") {
                /// change the variable for displaying single story
                isSinglePresent = true
            }
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Single Story"))
        .singleStory(
            storyID: "story_id", /// story id for presenting
            isPresented: $isSinglePresent, /// reader display
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
            onAction: { target, actionType  in
                isSinglePresent = false /// may call InAppStory.shared.closeReader()
            })
    }
}

struct SingleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleView()
    }
}
