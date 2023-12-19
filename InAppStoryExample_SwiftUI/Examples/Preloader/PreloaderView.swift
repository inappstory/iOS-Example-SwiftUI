//
//  PreloaderView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using placeholder for the time of loading the list of stories
///
/// In order to display a placeholder (skeleton) while the story list is loading, 
/// it is necessary to create a closing View on top of the list or use a library that adds a skeleton.
/// Then, after `StoryListView` initialization, specify `onUpdate` closure and wait for its call.
///
/// After calling `onUpdate` check the `isContent` variable and if it is positive, 
/// hide the placeholder, otherwise you can hide the list or display a user notification
/// on top of the `StoryListView` that there are no stories at the moment.
///
/// - Note: `onUpdate` is called whenever the list is updated. it is also called even
/// if there is an error - in this case `isContent = false` will be called.
struct PreloaderView: View
{
    /// variable indicating whether there is content in the list of stories
    @State var isStoriesContent: Bool = false
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
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
                        /// getting and assigning the value of presence of stories in the list
                        isStoriesContent = isContent
                    }
                    /// when initializing StoryListView, you should specify its size,
                    /// otherwise it will stretch to the whole screen
                    .frame(height: 150.0)
                /// If there are no stories in the list, a download is displayed
                if !isStoriesContent {
                    Text("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: 150.0)
                        .background(Color.white)
                }
            }
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Simple integration"))
    }
}

struct PreloaderView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleIntegrationView()
    }
}
