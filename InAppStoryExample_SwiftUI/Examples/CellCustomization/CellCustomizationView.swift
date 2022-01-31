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
    private var storyView: StoryViewSUI = .init(deleagateFlowLayout: FlowDelegate.shared)
    
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
            storyView
                .frame(height: 150.0)
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("Cell customization"))
        .onAppear {
            storyView.create()
        }
    }
}

struct CellCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CellCustomizationView()
    }
}

fileprivate class FlowDelegate: NSObject, StoryViewDelegateFlowLayout
{
    static let shared: FlowDelegate = .init()
    
    func sizeForItem() -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
    
    func insetForSection() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func minimumLineSpacingForSection() -> CGFloat {
        return 8.0
    }
    
    func minimumInteritemSpacingForSection() -> CGFloat {
        return 8.0
    }
}
