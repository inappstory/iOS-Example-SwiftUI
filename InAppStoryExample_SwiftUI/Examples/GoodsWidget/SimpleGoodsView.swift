//
//  SimpleGoodsView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of simple use of products in stories
///
/// To add goods to stories, you need to add a widget of goods in the console and specify in it a list
/// of SKUs of goods that should be displayed in stories. At the moment InAppStory does not store
/// data about the goods and therefore they must be passed in the `getGoodsObject` closure.
/// To do this, you can use a closure on InAppStory that will be called for all stories regardless of
/// where they are displayed or specify a closure on a specific list. In the closure it is necessary to
/// get data about goods corresponding to the SKU list and pass it to `complete:<GoodsComplete>`.
///
/// - Note: For simple embedding of goods, it is necessary to pass to the complete list of `GoodObject`or inherit from it.
///
/// This list of items will be used to generate a view in the stories. To track the user's interaction with
/// a particular item, it is necessary to specify the `goodItemSelected` closure, which will be called
/// every time the user taps on the item card.
///
/// ## Customization
/// You can change the appearance of the card by using `InAppStory` parameters.
/// To do this, you must set the desired parameters to `InAppStory` after initialization.
/// ```
/// InAppStory.shared.goodsCellMainTextColor: UIColor = .black
/// InAppStory.shared.goodsCellDiscountTextColor: UIColor = .red
/// ```
///
/// The full list of parameters and descriptions can be found here
/// [Customization](https://docs.inappstory.com/sdk-guides/ios/widget-goods.html#customization)
///
/// To customize product cell, see ``CustomCellGoodsView``.
///
/// For more information see: [Widget “Goods”](https://docs.inappstory.com/sdk-guides/ios/widget-goods.html#widget-goods)
struct SimpleGoodsView: View
{
    /// variable responsible for displaying the alert with the product name
    @State var isAlertShowing: Bool = false
    /// variable storing data about the selected SKU of the product
    @State var selectedItemSKU: String = ""
    
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
                /// closure to get the list of products by SKU
                /// it is necessary to have a `GoodObject` or inherit from it.
                .getGoodsObject { skus, complete in
                    /// transfer of ready list of goods to SDK
                    complete(.success(getObjects(skus: skus)))
                }
                /// closure to track user action
                .goodItemSelected { item, storyType in
                    /// closing the reed to display an alert with the name of the selected item
                    InAppStory.shared.closeReader {
                        selectedItemSKU = item.sku as String
                        isAlertShowing = true
                    }
                }
                /// when initializing StoryListView, you should specify its size,
                /// otherwise it will stretch to the whole screen
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Simple GoodsWidget"))
        /// standard alert display modifier
        .alert(isPresented: $isAlertShowing) {
            /// Alert displaying SKU of the selected product
            Alert(
                title: Text("Select goods item"),
                message: Text("Goods item has SKU: \(selectedItemSKU)"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

extension SimpleGoodsView {
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

struct SimpleGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleGoodsView()
    }
}
