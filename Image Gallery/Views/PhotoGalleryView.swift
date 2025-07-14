//
//  ContentView.swift
//  Image Gallery
//
//  Created by Khalid Gad on 12/07/2025.
//

import SwiftUI

struct PhotoGalleryView: View {
    @StateObject private var presenter = PhotoGalleryPresenter()
    @State private var selectedPhoto: Photo? = nil
    @State private var searchText: String = ""
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var columns: [GridItem] {
        let count = (horizontalSizeClass == .compact) ? 2 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if presenter.isLoading {
                    ProgressView("Loading...")
                        .scaleEffect(1.5)
                } else if let error = presenter.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if presenter.photos.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(presenter.photos) { photo in
                                NavigationLink(destination: PhotoDetailsView(photo: photo)) {
                                    PhotoCardView(photo: photo)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationTitle("Image Gallery")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search images...")
            .onSubmit(of: .search) {
                let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    presenter.searchPhotos(query: trimmed)
                }
            }
            .onAppear {
                presenter.loadPhotos()
            }
        }
    }
}

struct PhotoCardView: View {
    let photo: Photo
    @State private var imageLoaded = false
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: photo.src.medium)) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.15)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            ProgressView()
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                        .opacity(imageLoaded ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.3)) {
                                imageLoaded = true
                            }
                        }
                case .failure:
                    Color.red.opacity(0.1)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                        )
                @unknown default:
                    EmptyView()
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

// PhotoDetailsView is now in its own file

#Preview {
    PhotoGalleryView()
}
