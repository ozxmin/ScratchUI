//
//  AvatarImageView.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 01/10/24.
//

import SwiftUI

// TODO: - Implement zoomable and pan-able 
struct AvatarImageView: View {
#if DEBUG
    @available(*, renamed: "init(placeholder:details:)", message: "This initializer is just for previewing")
    init() {
        placeHolderImage = Image(systemName: "person.crop.circle.fill")
        url = URL(string:"")
    }
#else
    @available(*, unavailable, message: "This initializer is not available in production")
    init() {
        fatalError("This initializer should not be used in production")
    }
#endif

    private var placeHolderImage: Image
    private var url: URL?

    init<T>(placeholder: Data, details: ContactDisplay<T>) {
        self.placeHolderImage = Image(uiImage: UIImage(data: placeholder)!)
        url = details.getImageURL(size: 700)
    }

    var body: some View {
        if let url { buildScreenWithAsyncImage(from: url) }
    }

/*---**/

    func buildScreenWithAsyncImage(from url: URL) -> some View {
        return AsyncImage(url: url) { phase in
            if let image = phase.image {
                image.resizable().scaledToFill()

            } else if phase.error != nil {
                failedFetchImage.resizable()
            } else {
                loadingImage
            }
        }
    }

    var loadingImage: some View {
        ZStack {
            placeHolderImage
                .resizable()
                .scaledToFit()
            ProgressView().controlSize(.extraLarge)
        }

    }
    var failedFetchImage: Image {
        Image(systemName: "person.crop.circle.fill").resizable()
    }
}


struct ZoomablePannableImage: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State var image: Image
    var body: some View {
        GeometryReader { geometry in
            image
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            lastScale = value
                            scale *= delta
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
                .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

#Preview {
    AvatarImageView()
}
