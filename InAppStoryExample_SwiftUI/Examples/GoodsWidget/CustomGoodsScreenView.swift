//
//  CustomGoodsScreenView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct CustomGoodsScreenView: View
{
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        
        // set custom GoodsWidget view
        InAppStory.shared.goodsView = GoodsView()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(onAction: { target in
                InAppStory.shared.closeReader {
                    if let url = URL(string: target) {
                        UIApplication.shared.open(url)
                    }
                }
              }, getGoodsObjects: { skus, complete in
                complete(.success(getObjects(skus: skus)))
              }, refresh: $isStoryRefresh)
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Custom Cell GoodsWidget"))
    }
}

extension CustomGoodsScreenView
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

struct CustomGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGoodsScreenView()
    }
}
