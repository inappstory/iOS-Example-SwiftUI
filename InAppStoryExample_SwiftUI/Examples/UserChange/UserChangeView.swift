//
//  UserChangeView.swift
//  InAppStoryExample_SwiftUI
//
//  Created by StPashik on 24.11.2021.
//

import SwiftUI
import InAppStorySDK_SwiftUI

struct UserChangeView: View
{
    @State var isStoryRefresh: Bool = false
    
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
              }, refresh: $isStoryRefresh)
                .frame(height: 150.0)
            HStack {
                Spacer()
                Button("Change user") {
                    InAppStory.shared.settings = .init(userID: "666")
                    isStoryRefresh.toggle()
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle(Text("User Change"))
    }
}

struct UserChangeView_Previews: PreviewProvider {
    static var previews: some View {
        UserChangeView()
    }
}
