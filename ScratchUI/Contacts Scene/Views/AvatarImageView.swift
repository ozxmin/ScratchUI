//
//  AvatarImageView.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 01/10/24.
//

import SwiftUI

// TODO: - Implment zoomable and panable
struct AvatarImageView: View {
    private var placeHolderimage: Image
    private var url: URL?

    init(placeholder: Data, details: ContactDetailsDisplay) {
        placeHolderimage = Image(uiImage: UIImage(data: placeholder)!)
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
                    placeHolderimage
                }
            }
        }
    }
}
