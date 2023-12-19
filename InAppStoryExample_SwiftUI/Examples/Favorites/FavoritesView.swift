//
//  FavoritesView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of how to use favorites
///
/// For the favorites functionality to work, you need:
/// * enable favorites in the console project settings;
/// * enable favorites in sdk via setting the `InAppStory.shared.panelSettings` parameter in SDK;
/// * if necessary, set the icon of the "Favorites" button via the `InAppStory` parameters `favoriteImage` and `favoriteSelectedImag`;
/// * if necessary, create and set a custom favorite cell at `StoryView.favoriteCell`;
/// * show a screen with a list of favorite stories;
///
/// - Note: For the favorites functionality to work, it must be enabled in the console and set to true via panelSettings.
/// If one of the conditions is not met, the favorites will not be displayed on the reader panel.
///
/// # Custom favorites icon
/// The favorite button in the reader can be in two states:
/// * selected - the story is in favorites;
/// * unselected - the story is not in favorites;
///
/// By this, it is necessary to set images for each state.
/// Since the bottom panel with a set of buttons, including favorites, is added when the reader is created, pictures should be set before the reader is attempted.
/// The best solution is to add setting custom icons at application startup, for example in `YourAppNameApp.swift` or `AppDelegate` if you use it.
/// ```
/// InAppStory.shared.favoriteImage = UIImage(named: "favoriteIcon")
/// InAppStory.shared.favoriteSelectedImag = UIImage(named: "favoriteIcon_selected")
/// ```
///
/// # Custom favorite cell
/// A custom favorite cell must be a class that inherits `UICollectionViewCell` and implements the `FavoriteCellProtocol` protocol.
/// - Note: A favorites cell is an additional list item that allows you to track a user's attempt to go to the favorites screen and does not replace the cells in the list that displays favorites.
///
/// To replace the default favorite cell, you must set your own cell when creating `StoryListView` so
/// that the new cell has time to register with `UICollectionView` and display after the list is loaded.
/// ```
/// StoryListView()
///      .setFavoriteCell(customCell: CustomFavoriteCell())
/// ```
///
/// # Tracking the pressed favorite
/// In order to understand that the user has tapped on a favorite cell, it is necessary to specify the `favoriteDidSelect` closure
/// and perform the necessary actions in it, for example, show the controller with the list of favorites.
///
/// For more panel settings, see [Likes, Share, Favorites](https://docs.inappstory.com/sdk-guides/ios/favorites.html#likes-share-favorites)
struct FavoritesView: View
{
    /// variable responsible for displaying the list of favorites via `NavigationView`
    @State var isFavoriteSelected: Bool = false
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        /// enable favorite button in reader & showinng favorite cell in the end of list
        InAppStory.shared.panelSettings = PanelSettings(favorites: true)
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
        }
        .padding(.top)
        .navigationBarTitle(Text("Favorites"))
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

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
