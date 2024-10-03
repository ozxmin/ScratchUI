//
//  AvatarImageView.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 01/10/24.
//

import SwiftUI

// TODO: - Implement zoomable and pan-able 
struct AvatarImageView: View {
    private var placeHolderImage: Image
    private var url: URL?

    init<T>(placeholder: Data, details: ContactDisplay<T>) {
        self.placeHolderImage = Image(uiImage: UIImage(data: placeholder)!)
        url = details.avatarURL ?? nil
    }

    var body: some View {
        if url != nil {
            AsyncImage(url: url, scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ZStack {
                    ProgressView()
                    placeHolderImage
                }
            }
        }
    }
}
