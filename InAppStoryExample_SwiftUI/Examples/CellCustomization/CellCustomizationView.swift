//
//  CellCustomizationView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import UIKit
import SwiftUI
import InAppStorySDK_SwiftUI

struct CellCustomizationView: View
{
    @State var isStoryRefresh: Bool = false
    
    init() {
        // setup InAppStorySDK for user with ID
        InAppStory.shared.settings = .init(userID: "")
        
        // quality of cover images in cells
        InAppStory.shared.coverQuality = .high
        
        // show title in cell
        InAppStory.shared.showCellTitle = true
    
        // color of cell border
        InAppStory.shared.cellBorderColor = .purple
        // cell title font
        InAppStory.shared.cellFont = UIFont.systemFont(ofSize: 12.0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StoryListView(
                onAction: { target, actionType in
                    InAppStory.shared.closeReader {
                        if let url = URL(string: target) {
                            UIApplication.shared.open(url)
                        }
                    }
                }, refresh: $isStoryRefresh)
                .itemsSize(CGSize(width: 150.0, height: 150.0))
                .edgeInserts(UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0))
                .lineSpacing(8.0)
                .interitemSpacing(8.0)
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Cell customization"))
    }
}

struct CellCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CellCustomizationView()
    }
}
