//
//  CustomCellGoodsView.swift
//  InAppStoryExample_SwiftUI
//

import SwiftUI
import InAppStorySDK_SwiftUI

/// Example of using a custom cell in the Goods widget
///
/// Using a custom product cell, is similar to using a custom cell for a list of stories.
///
/// To fully customize a cell, you need to create a `UICollectionViewCell` successor class
/// that implements the `GoodsCellProtocol` and pass it to `InAppStory.shared.goodCell`
/// before create `StoryListView` or showing the Single/Onbosarding reader.
/// Examples of custom cell implementations can be found at the following links ``CustomGoodCell``
///
/// When using a custom cell in the `getGoodsObject` closure, you can create `GoodObject` objects
/// just like `SimpleGoodsController` or create your own class with any set of parameters,
/// the main thing is that it implements `GoodsObjectProtocol`.
///
/// When implementing a custom cell and creating your own object for the product model, SDK knows
/// only the SKU of the product itself and in the `goodItemSelected` closure will pass an abstract object
/// with an indication of the implementation of the protocol `GoodsObjectProtocol`. In order to get
/// access to the fields of your object, it must be greeted to the created in the `getGoodsObject` closure.
///
/// For more information see: [Custom cell](https://docs.inappstory.com/sdk-guides/ios/widget-goods.html#custom-cell)
struct CustomCellGoodsView: View
{
    /// variable responsible for displaying the alert with the product name
    @State var isAlertShowing: Bool = false
    /// variable storing data about the selected SKU of the product
    @State var selectedItemSKU: String = ""
    
    init() {
        /// setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        
        /// set custom GoodsWidget cell realization
        InAppStory.shared.goodCell = CustomGoodCell()
        
        /// setup googs cells in widget
        setupGoodsCells()
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
        .navigationBarTitle(Text("Custom Cell GoodsWidget"))
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

extension CustomCellGoodsView {
    
    /// Customizing product cell dimensions and paddings
    /// These closures affect the location, size, and indentation of cells in the goods widget.
    /// They work similarly to UICollectionViewDelegateFlowLayout methods
    fileprivate func setupGoodsCells() {
        /// returns the cell size for the list
        InAppStory.shared.goodsSizeForItem = { CGSize(width: 130.0, height: 130.0) }
        /// returns padding from the edges of the list for cells
        InAppStory.shared.goodsInsetForSection = { UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0) }
        /// the spacing between successive rows or columns of a section
        InAppStory.shared.goodsMinimumLineSpacingForSection = { 8 }
    }
    
    /// Function that creates a list of products
    /// - Parameter skus: list of SKUs on the basis of which goods are to be received
    /// - Returns: list of commodity objects implementing the `GoodsObjectProtocol` protocol
    fileprivate func getObjects(skus: Array<String>) -> Array<GoodsObjectProtocol> {
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

struct CustomCellGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCellGoodsView()
    }
}
