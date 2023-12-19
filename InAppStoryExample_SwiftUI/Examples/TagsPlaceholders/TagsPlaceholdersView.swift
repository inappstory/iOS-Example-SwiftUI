//
//  TagsPlaceholdersView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using tags and placeholders
///
/// # Tags
/// A set of tags can be used for segmenting the display of stories lists.
/// Tags for specific stories are set in the console when creating or editing them.
///
/// > For example, if for an unauthorized user you want to show a story with a call to register and
/// > not show special offers. You can set the tag "unauthorize" in the console, and "authorize" for all other users,
/// > thus dividing the feed into two parts. When creating a feed, check if the user is authorized and add a corresponding list of tags.
/// > ```
/// > if user.isAuthorize {
/// >     InAppStory.shared.settings = Settings(userID: user.id, tags: ["authorize"])
/// > } else {
/// >     InAppStory.shared.settings = Settings(userID: "", tags: ["unauthorize"])
/// > }
/// > ```
///
/// - Remark: Split the display of stories can also be done using the "Multifeed" tool,
/// you can see an example of how to use it ``MultifeedView``
///
/// There are several options for setting up a tag list:
/// - setting the list in the `Settings` object during `InAppStory` initialization
/// ```
/// InAppStory.shared.initWith(serviceKey: "serviceKey", settings: Settings(userID: "userID", tags: ["one", "two"]))
/// ```
/// - setting tags before using the `StoryView` list of stories
/// ```
/// InAppStory.shared.settings = Settings(userID: "userID", tags: ["one", "two"])
/// ```
/// - adding or deleting tag lists using `addTags` and `removeTags` methods
/// ```
/// InAppStory.shared.addTags(["three", "four"])
/// InAppStory.shared.removeTags(["three"])
/// ```
/// - override tag list for Onboardings. For more details see ``OnboardingView``
/// - refresh tag list via `.refresh` method
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
///     refreshClosure(nil, ["new_tag_1", "new_tag_2"])
/// }
/// ```
///
/// - Note: After setting new tags via the `Settings` object or changing the list of `addTags`
/// and `removeTags`, if the `StoryView` list is already created and displayed on the screen,
/// the refresh must be called to make the changes take effect.
///
/// For more information about tags see: [Tags](https://docs.inappstory.com/sdk-guides/ios/tags.html#tags)
///
/// # Placeholders
///
/// Placeholders are used to personalize and modify displayed stories directly on the device.
/// For correct operation, placeholders must be started in the console and specified in `InAppStory.shared`
/// before creating `StoryListView` or displaying Single/Onboarding.
///
/// ## Text placeholders
/// Text placeholders are set in `InAppStory` as `Dictionary<String, String>`,
/// with the key specified without curly braces, and the value can be anything.
/// If no value is specified for a placeholder, the default value set in the console when
/// it was created will be shown in the story.
/// ```
/// InAppStory.shared.placeholders = ["one" : "Replace one", "two" : "Replace two"]
/// ```
///
/// ## Images placeholders
/// Image placeholders are set in `InAppStory` as `Dictionary<String, String>`,
/// the key is specified without curly brackets, and the value must contain a link to the image that will be displayed in the story.
/// ```
/// InAppStory.shared.imagesPlaceholders = ["img_1" : "imageURL_1", "img_2" : "imageURL_1"]
/// ```
///
/// - Note: The link to the story can be either local or external. SDK in any case will download it to its own cache for correct work.
///
/// For more information about placeholders see: [Placeholders](https://docs.inappstory.com/sdk-guides/ios/placeholders.html#placeholders)
struct TagsPlaceholdersView: View
{
    /// variable responsible for refresh story list
    @State var isStoryRefresh: Bool = false
    /// closure causing the list to be updated
    @State var refreshClosure: ((_ feed: String?, _ tags: Array<String>?) -> Void)!
    
    init() {
        /// setup InAppStorySDK for user with ID & tags
        InAppStory.shared.settings = .init(userID: "", tags: ["one", "two"])
        /// add tags after set settings
        InAppStory.shared.addTags(["three", "four"])
        /// remove tags if needed
        InAppStory.shared.removeTags(["three"])
        
        /// set replacing placeholders list
        InAppStory.shared.placeholders = ["one" : "Replace one", "two" : "Replace two"]
        
        /// set replacing images placeholders list
        InAppStory.shared.imagesPlaceholders = ["img_1" : "imageURL_1", "img_2" : "imageURL_1"]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
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
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 150.0)
            HStack {
                Spacer()
                /// new user button
                Button("Change placeholders") {
                    /// set replacing placeholders list
                    InAppStory.shared.placeholders = ["one" : "Replace one", "two" : "Replace two"]
                    /// set replacing images placeholders list
                    InAppStory.shared.imagesPlaceholders = ["img_1" : "imageURL_1", "img_2" : "imageURL_1"]
                    /// refreshing the list via Binding variable
                    isStoryRefresh.toggle()
                }
                Spacer()
            }
            HStack {
                Spacer()
                /// new user button
                Button("Change placeholders 2") {
                    /// set replacing placeholders list
                    InAppStory.shared.placeholders = ["one" : "Replace one", "two" : "Replace two"]
                    /// set replacing images placeholders list
                    InAppStory.shared.imagesPlaceholders = ["img_1" : "imageURL_1", "img_2" : "imageURL_1"]
                    /// refreshing the list via closure
                    refreshClosure("new_feed", ["new_tag_1", "new_tag_2"])
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Tags & Placeholders"))
    }
}

struct TagsPlaceholdersView_Previews: PreviewProvider {
    static var previews: some View {
        TagsPlaceholdersView()
    }
}
