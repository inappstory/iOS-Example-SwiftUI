//
//  CustomCellView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct CustomCellView: View
{
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(onAction: { target, actionType in
                InAppStory.shared.closeReader {
                    if let url = URL(string: target) {
                        UIApplication.shared.open(url)
                    }
                }
              }, refresh: $isStoryRefresh)
                .setStoryCell(customCell: CustomStoryCell())
                .itemsSize(CGSize(width: 120.0, height: 120.0))
                .edgeInserts(UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0))
                .lineSpacing(16.0)
                .interitemSpacing(16.0)
                .frame(height: 150.0)
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
