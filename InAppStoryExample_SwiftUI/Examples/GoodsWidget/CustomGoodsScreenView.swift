//
//  CustomGoodsScreenView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using a custom goods widget
///
/// In order to completely redesign the appearance and display logic of the goods widget, it is necessary
/// to create an inheritor class from `CustomGoodsView`, see ``GoodsView`` for an example.
/// To apply its use in the SDK, it must be specified in `InAppStory.shared.goodsView` when
/// configuring `InAppStory`, before creating a `StoryListView` or showing Single/Onboarding.
///
/// When using a custom product widget, there is no need to set the `getGoodsObject` closure,
/// because the SKU list is passed directly to `CustomGoodsView`.
///
/// For more information see: [Full widget override](https://docs.inappstory.com/sdk-guides/ios/widget-goods.html#full-widget-override)

struct CustomGoodsScreenView: View
{
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        
        /// set custom GoodsWidget view
        InAppStory.shared.goodsView = GoodsView()
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
                /// closure to get the list of products by SKU
                /// it is necessary to have a `GoodObject` or inherit from it.
                .getGoodsObject { skus, complete in
                    complete(.success(getObjects(skus: skus)))
                }
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell GoodsWidget"))
    }
}

extension CustomGoodsScreenView {
    /// Function that creates a list of products
    /// - Parameter skus: list of SKUs on the basis of which goods are to be received
    /// - Returns: list of commodity objects implementing the `GoodsObjectProtocol` protocol
    fileprivate func getObjects(skus: Array<String>) -> Array<GoodsObjectProtocol>
    {
        var items: Array<GoodsObjectProtocol> = []
        for sku in skus {
            items.append(GoodObject(sku: sku,
                                    title: sku,
                                    subtitle: sku,
                                    imageURL: nil,
                                    price: nil,
                                    oldPrice: nil))
        }
        
        return items
    }
}

struct CustomGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGoodsScreenView()
    }
}
