//
//  ReaderCustomizationView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// An example of changing the appearance of the Storys reader
///
/// Customization of the reader is done through parameters set in `InAppStory`.
/// All parameters, preferably set before the first opening of the reader
///
/// # Timer customization
/// Reader timers, have 3 main settings:
/// * close button location:
///     - The `InAppStory.shared.closeButtonPosition:<ClosePosition>` parameter is used to change the location of the close button.
/// * gradient display behind timers:
///     - To change the gradient display behind the timer bar, you must use `InAppStory.shared.timerGradientEnable:<Bool>`.
/// * close button icon:
///     - To change the close button icon, you must specify your own image in the `InAppStory.shared.closeReaderImage:<UIImage>` parameter
///
/// ### ClosePosition
/// Position of the close button on the card in the reader:
///
/// - `.left` - to the left of the timers;
/// - `.right` - to the right of the timers;
/// - `.bottomLeft` - on the left under the timers;
/// - `.bottomRight` - on the right under the timers;
///
/// # Showing and closing
/// There are 3 settings responsible for showing and closing the reader:
/// * type of show and close animation:
///     - To change the animation of the reader display on the screen, you must use the `InAppStory.shared.presentationStyle:<PresentationStyle>` parameter
/// * ability to close the reader when saiping on the outermost stories in the list:
///     - To be able to close the reader when flipping on the last slide, you must use `InAppStory.shared.overScrollToClose:<Bool>`To be able to close the reader when flipping on the last slide, you must use `InAppStory.shared.overScrollToClose:<Bool>`
/// * swipe down closing lock:
///     - To prevent the reader from closing by swiping down, set the `InAppStory.shared.swipeToClose:<Bool>` parameter to `false`.
///
/// ### PresentationStyle
/// Reader display animation style:
///
/// - `.crossDissolve` - showing reader from transparency;
/// - `.modal` - modal reader display;
/// - `.zoom` - display reader from list's cell;
///
/// # Bottom panel (like, favorite, share)
/// The bottom panel showing possible actions inside a story is displayed automatically if the like, favorite or share functionality is enabled.
/// It can also be displayed if a video with sound is embedded in the story and the sound is not disabled in the console.
///
///- Note: To enable like, favorite or share functionality, you must also enable these features in the console.
/// Otherwise, the panel or individual buttons may not be shown.
///
/// If the like, favorite, or share functionality is already enabled in the console,
/// you must set the `InAppStory.shared.panelSettings:<PanelSettings>`
/// parameter with the functionality you want to display.
/// ```
/// InAppStory.shared.panelSettings = PanelSettings(like: true, favorites: true, share: true)
/// ```
///
/// To change the appearance of the buttons on the bottom panel, it is necessary to set a new icon for each of them.
/// Each button has 2 states, for correct display it is necessary to set icons for both states.
/// - Attention: The image size for icons should not exceed 24x24pt.
///
/// # Changing the flipping animation
/// The `InAppStory.shared.scrollStyle:<ScrollStyle>` parameter must be set to change the scroll animation.
///
/// ### ScrollStyle
/// Story transition animation style in reader:
///
/// - `.flat` - usual, one after another, like UIScrollView;
/// - `.cover` - covered with next slide;
/// - `.depth` - covered with next slide with previos slide alpha;
/// - `.cube` - in the form of a 3D cube;
///
/// # Refresh setup
/// There are scenarios when the content of a story slide fails to load.
/// In such cases, the refresh button appears in the reader, and when you tap on it, an attempt is made to retrieve the data.
/// To change the icon of the "Refresh" button - you need to set a new image in the `InAppStory.shared.refreshImage:<UIImage>` parameter.
///
/// For more information and a complete list of parameters see: [Reader customization](https://docs.inappstory.com/sdk-guides/ios/appearance.html#reader-customization)
struct ReaderCustomizationView: View
{
    /// variable responsible for displaying the list of favorites via `NavigationView`
    @State var isFavoriteSelected: Bool = false
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        /// disable swipe gesture for reader closing
        InAppStory.shared.swipeToClose = false
        /// disabling closing the reader after scrolling through the last story
        InAppStory.shared.overScrollToClose = false
        /// placeholder color when loading stories
        InAppStory.shared.placeholderElementColor = .lightGray
        /// placeholder background color when loading stories
        InAppStory.shared.placeholderBackgroundColor = .white
        /// placeholder color when loading game
        InAppStory.shared.gamePlaceholderTint = .lightGray
        
        /// enable gradient shadow under timers in story
        InAppStory.shared.timerGradientEnable = false
        
        /// set new icons for buttons in the reader
        InAppStory.shared.likeImage = UIImage(named: "like")!
        InAppStory.shared.likeSelectedImage = UIImage(named: "likeSelected")!
        InAppStory.shared.dislikeImage = UIImage(named: "dislike")!
        InAppStory.shared.dislikeSelectedImage = UIImage(named: "dislikeSelected")!
        InAppStory.shared.favoriteImage = UIImage(named: "favorite")!
        InAppStory.shared.favoriteSelectedImag = UIImage(named: "favoriteSelected")!
        InAppStory.shared.shareImage = UIImage(named: "sharing")!
        InAppStory.shared.shareSelectedImage = UIImage(named: "sharingSelected")!
        InAppStory.shared.soundImage = UIImage(named: "sound")!
        InAppStory.shared.soundSelectedImage = UIImage(named: "soundSelected")!
        
        /// setting the icon for the "Close" button
        InAppStory.shared.closeReaderImage = UIImage(named: "closeIcon")!
        
        /// setting the icon for the "Refresh" button
        InAppStory.shared.refreshImage = UIImage(named: "refresh")!

        /// bottom panel setup
        InAppStory.shared.panelSettings = PanelSettings(like: true, /// enable like function in reader
                                                        favorites: true, /// enable favorite function in reader
                                                        share: true) /// enable share function in reader
        /// set position of close button in reader
        InAppStory.shared.closeButtonPosition = .bottomLeft
        /// set animation for switching between stories in the reader
        InAppStory.shared.scrollStyle = .cube
        /// set the animation for the reader
        InAppStory.shared.presentationStyle = .modal
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
                /// tracking the tap on a favorite cell
                .favoriteDidSelect {
                    /// change the variable to display the favorites list
                    isFavoriteSelected = true
                }
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Reader Customization"))
        /// Presents a sheet with favorites list when a binding to a Boolean value that you provide is true.
        .sheet(isPresented: $isFavoriteSelected) {
            NavigationView {
                /// creating a favorite list of stories for displaying favorite stories it is necessary to
                /// specify `isFavorite = true` parameter during `StoryListView` initialization.
                StoryListView(isFavorite: true)
                    .navigationBarTitle(Text("Favorites"), displayMode: .inline)
            }
        }
    }
}

struct ReaderCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderCustomizationView()
    }
}
