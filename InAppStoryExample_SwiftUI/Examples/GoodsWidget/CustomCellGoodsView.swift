//
//  CustomCellGoodsView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct CustomCellGoodsView: View
{
    @State var isAlertShowing: Bool = false
    @State var isStoryRefresh: Bool = false
    
    @State var selectedItemSKU: String = ""
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        
        // set custom GoodsWidget cell realization
        InAppStory.shared.goodCell = CustomGoodCell()
        
        // set delegate for layout of GoodsWidget list
        InAppStory.shared.goodsDelegateFlowLayout = CustomCellGoodsFlowDelegate.shared
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(onAction: { target, actionType in
                InAppStory.shared.closeReader {
                    if let url = URL(string: target) {
                        UIApplication.shared.open(url)
                    }
                }
              }, getGoodsObjects: { skus, complete in
                complete(.success(getObjects(skus: skus)))
              }, selectGoodsItem: { item in
                  InAppStory.shared.closeReader {
                      selectedItemSKU = item.sku as String
                      isAlertShowing = true
                  }
              }, refresh: $isStoryRefresh)
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell GoodsWidget"))
        .alert(isPresented: $isAlertShowing) {
            Alert(
                title: Text("Select goods item"),
                message: Text("Goods item has SKU: \(selectedItemSKU)"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

extension CustomCellGoodsView
{
    fileprivate func getObjects(skus: Array<String>) -> Array<GoodsObjectProtocol>
    {
        var items: Array<GoodsObjectProtocol> = []
        for sku in skus {
            items.append(GoodObject(sku: sku,
                                    title: sku,
                                    subtitle: sku,
                                    imageURL: nil,
                                    price: nil,
                                    discount: nil))
        }
        
        return items
    }
}

struct CustomCellGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCellGoodsView()
    }
}

fileprivate class CustomCellGoodsFlowDelegate: NSObject, GoodsDelegateFlowLayout
{
    static let shared: CustomCellGoodsFlowDelegate = .init()
    
    func sizeForItem() -> CGSize
    {
        return CGSize(width: 130.0, height: 130.0)
    }
    
    func insetForSection() -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func minimumLineSpacingForSection() -> CGFloat
    {
        return 8
    }
}
