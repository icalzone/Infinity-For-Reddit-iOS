//
//  CommentInterfaceView.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-13.
//

import SwiftUI
import Swinject
import GRDB

struct CommentInterfaceView: View {
    @StateObject private var commentInterfaceViewModel = CommentInterfaceViewModel()
    
    var body: some View {
        List {
            Toggle("Show Top-level Comments First", isOn: $commentInterfaceViewModel.showTopLevelCommentsFirst)
                .padding(.leading, 44.5)
            Toggle("Show Comment Divider", isOn: $commentInterfaceViewModel.showCommentDivider)
                .padding(.leading, 44.5)
            Toggle("Show Only One Comment Level Indicator", isOn: $commentInterfaceViewModel.showCommentDivider)
                .padding(.leading, 44.5)
            Toggle("Comment Toolbar Hidden by Default", isOn: $commentInterfaceViewModel.commentToolbarHiddenByDefault)
                .padding(.leading, 44.5)
            Toggle("Click to Show/Hide Comment Toolbar", isOn: $commentInterfaceViewModel.clickToShowHideCommentToolbar)
                .padding(.leading, 44.5)
            Toggle("Fully Collapse Comment", isOn: $commentInterfaceViewModel.fullyCollapseComment)
                .padding(.leading, 44.5)
            Toggle("Show Author Avatar", isOn: $commentInterfaceViewModel.showAuthorAvatar)
                .padding(.leading, 44.5)
            Toggle("Always Show the Number of Child Comments", isOn: $commentInterfaceViewModel.alwaysShowNumberOfChildComments)
                .padding(.leading, 44.5)
            Toggle("Hide the Number of Votes", isOn: $commentInterfaceViewModel.hideNumberOfVotes)
                .padding(.leading, 44.5)
            
            Picker("Show Fewer Toolbar Options Starting From Level", selection: $commentInterfaceViewModel.showFewerToolbarOptionsStartingFromLevel) {
                ForEach(0..<commentInterfaceViewModel.toolBarOptionLevels.count, id: \.self) { index in
                    Text(commentInterfaceViewModel.toolBarOptionLevels[index]).tag(index)
                }
            }
            .padding(.leading, 44.5)
            
            Picker("Embedded Media Type", selection: $commentInterfaceViewModel.embeddedMediaType) {
                ForEach(0..<commentInterfaceViewModel.embeddedMediaTypes.count, id: \.self) { index in
                    Text(commentInterfaceViewModel.embeddedMediaTypes[index]).tag(index)
                }
            }
            .padding(.leading, 44.5)
        }
        .navigationTitle("Comment")
    }
}
    
