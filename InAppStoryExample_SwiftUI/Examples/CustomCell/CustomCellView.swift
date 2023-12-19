//
//  CustomCellView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using a cast cell for a list of stories.
///
/// To completely modify a cell, you must create an `UICollectionViewCell` inheritor class
/// that implements `StoryCellProtocol` and pass it to the `.setStoryCell(customCell:)` method at initialization.
/// Examples of custom cell implementations can be found at the following links ``CustomStoryCell``
///
/// If you use only `InAppStory` parameters to change the cell view, its size is automatically calculated:
/// * for a horizontal list - equal to the `StoryListView` height minus the indents and has the aspect ratio set in the console for the project;
/// * for a vertical list - equal to the width of the `StoryListView` list minus the indents from the list edge, the indents between cells and the aspect ratio set in the console for the project;
///
///  - Remark: It is recommended to use closures to customize cell sizes and indents for better control of the list display
///
/// For your own control over the size and indentation of cells in a list, you should use closures.
/// The list of stories is based on `UICollectionView`, by this closure has been named as `UICollectionViewDelegateFlowLayout` methods and is responsible for the same thing.
///
/// ```
/// itemsSize() -> CGSize
/// edgeInserts() -> UIEdgeInsets
/// lineSpacing() -> CGFloat
/// interitemSpacing() -> CGFloat
/// ```
///
///  Documentation on cell replacement can be viewed here [Fully custom cells](https://docs.inappstory.com/sdk-guides/ios/appearance.html#fully-custom-cells)
struct CustomCellView: View
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
                /// setting a custom cell, you can also change it to ``CustomStoryCell``
                .setStoryCell(customCell: CustomStoryCell())
                /// These closures affect the location, size, and indentation of cells in the list.
                /// They work similarly to UICollectionViewDelegateFlowLayout methods
            
                /// returns the cell size for the list
                .itemsSize { CGSize(width: 120.0, height: 120.0) }
                /// returns padding from the edges of the list for cells
                .edgeInserts { UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0) }
                /// the spacing between successive rows or columns of a section
                .lineSpacing { 16.0 }
                /// the spacing between successive items of a single row or column
                .interitemSpacing { 16.0 }
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 152.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell"))
    }
}

struct CustomCellView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCellView()
    }
}
