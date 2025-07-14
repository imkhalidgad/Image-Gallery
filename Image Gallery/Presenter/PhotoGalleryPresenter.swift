import Foundation

class PhotoGalleryPresenter: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var currentQuery: String = "nature"
    
    private let service = PexelsService()
    
    func loadPhotos() {
        searchPhotos(query: currentQuery)
    }
    
    func searchPhotos(query: String) {
        isLoading = true
        errorMessage = nil
        currentQuery = query
        service.fetchPhotos(query: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let photos):
                self.photos = photos
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
} 