import SwiftUI
import MapKit
import CoreLocation

struct BuildingMapView: View {
    // MARK: - Properties
    
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.66522, longitude: 139.73003),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    @State private var places: [Place] = [
        Place(name: "東京タワー", coordinate: .init(latitude: 35.65858, longitude: 139.74543), isFavorite: true, imageName: "tokyo.tower.fill"),
        Place(name: "東京スカイツリー", coordinate: .init(latitude: 35.71006, longitude: 139.8107), isFavorite: false, imageName: "building.2.fill"),
        Place(name: "渋谷スクランブル交差点", coordinate: .init(latitude: 35.65952, longitude: 139.70043), isFavorite: false, imageName: "person.3.sequence.fill"),
        Place(name: "六本木ヒルズ", coordinate: .init(latitude: 35.66038, longitude: 139.72922), isFavorite: true, imageName: "building.columns.fill"),
        Place(name: "お台場海浜公園", coordinate: .init(latitude: 35.63044, longitude: 139.7772), isFavorite: true, imageName: "figure.water.fitness")
    ]
    
    // Viewの状態を管理するプロパティ
    @State private var showingPermissionAlert = false
    @State private var showOnlyFavorites = false
    @State private var selectedPlace: Place?
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Computed Properties
    
    /// `showOnlyFavorites`の状態に応じて表示する場所をフィルタリング
    private var filteredPlaces: [Place] {
        showOnlyFavorites ? places.filter { $0.isFavorite } : places
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .top) {
            // 地図
            Map(position: $position, selection: $selectedPlace) {
                UserAnnotation()
                
                ForEach(filteredPlaces) { place in
                    Marker(place.name, coordinate: place.coordinate)
                        .tag(place)
                        .tint(place.isFavorite ? .red : .accentColor)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // UIコントロール
            VStack {
                // お気に入りフィルタートグル
                Toggle("お気に入りのみ表示", isOn: $showOnlyFavorites)
                    .padding(8)
                    .background(.white.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    .padding(.top)

                Spacer()

                // 現在地ボタン
                HStack {
                    Spacer()
                    Button(action: checkLocationPermission) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(12)
                            .background(.white.opacity(0.85))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .alert("位置情報の許可が必要です", isPresented: $showingPermissionAlert, actions: {
            Button("キャンセル") {}
            Button("設定を開く") { openAppSettings() }
        }, message: {
            Text("現在地を表示するには、設定アプリで位置情報の利用を許可してください。")
        })
        .sheet(item: $selectedPlace) { place in
            // ★重要：ここで`places`配列の要素へのバインディングを渡す
            if let index = places.firstIndex(where: { $0.id == place.id }) {
                PlaceDetailView(place: $places[index])
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// 位置情報の許可状態をチェックし、状態に応じた処理を実行
    private func checkLocationPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            position = .userLocation(fallback: .automatic)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showingPermissionAlert = true
        @unknown default:
            break
        }
    }
    
    /// アプリの設定画面を直接開く
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
