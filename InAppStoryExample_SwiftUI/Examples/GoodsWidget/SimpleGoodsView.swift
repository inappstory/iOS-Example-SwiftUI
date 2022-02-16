//
//  SimpleGoodsView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct SimpleGoodsView: View
{
    @State var isAlertShowing: Bool = false
    @State var isStoryRefresh: Bool = false
    
    @State var selectedItemSKU: String = ""
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
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
        .navigationBarTitle(Text("Simple GoodsWidget"))
        .alert(isPresented: $isAlertShowing) {
            Alert(
                title: Text("Select goods item"),
                message: Text("Goods item has SKU: \(selectedItemSKU)"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

extension SimpleGoodsView
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

struct SimpleGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleGoodsView()
    }
}
