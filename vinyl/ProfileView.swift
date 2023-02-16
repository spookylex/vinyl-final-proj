//
//  ProfileView.swift
//  vinyl
//
//  Alexis Osipovs
//
// https://www.youtube.com/watch?v=a05eLxsbCCw
// https://www.youtube.com/watch?v=YgjYVbg1oiA
// https://medium.com/swlh/how-to-open-the-camera-and-photo-library-in-swiftui-9693f9d4586b
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-alert

import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct ProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    @EnvironmentObject var dataManager: DataManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.postedOn, ascending: true)],
        animation: .default)
    private var drafts: FetchedResults<Item>
    
    let email = Auth.auth().currentUser?.email
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplay = false
    @State private var showingAlert = false
    @State private var showReviewViewSheet = false
    
    @State var selectedDraft: Item?
    @State var selectedAlbum: Album?

    
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                VStack{
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack{
                        Text("Hi, " + String((email) ?? "user"))
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .offset(x: 150, y:0)
                        
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 130, height: 130)
                                .padding(22)
                                .offset(x: -170)
                            
                        }
                        else
                        {
                            Image("logo")
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .padding(20)
                                .offset(x: -170)
                        }
                    }
                    .padding()
                    VStack {
                        Button("Choose from Photo Library") {
                            self.sourceType = .photoLibrary
                            self.isImagePickerDisplay.toggle()
                        }
                        .padding()
                        .font(.title3)
                        .fontWeight(.bold)
                        .offset(x: 12,y: -20)
                        
                        
                        Button("Open Camera") {
                            self.sourceType = .camera
                            self.isImagePickerDisplay.toggle()
                        }
                        .font(.title3)
                        .fontWeight(.bold)
                        .offset(x: -50, y: -20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.leading)
                    .padding()
                    
                    VStack{
                        Divider()
                        Text("Your Drafted Reviews")
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        ForEach(drafts) { draft in
                            
                            NavigationLink{
                                        
                                        NewReviewView(album: dataManager.albums.first(where: { $0.id == draft.id }) ?? Album(id: "?????", name: "missing", image: "", artist: "missing", release: Date(), songs: "missing", genre: "missing"), review: Review(id: draft.id ?? "missing" , reviewer: draft.reviewer ?? "missing" , title: draft.title ?? "missing" , desc: draft.desc ?? "missing" , rating: Int(draft.rating ?? 0) , postedOn: draft.postedOn ?? "missing"))
                                            .environmentObject(contextHolder)
                                    
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(alignment: .top) {
                                        Text(draft.title ?? "untitled")
                                            .font(.system(.title3, weight: .medium))
                                            .lineLimit(2)
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 6) {
                                            HStack(spacing: 0) {
                                                ForEach(1...5, id: \.self) { number in
                                                    showStar(for: number)
                                                        .foregroundColor(number <= draft.rating ? .black : .gray)
                                                }
                                            }
                                            Text(draft.postedOn ?? "")
                                                .font(.system(.caption2, weight: .ultraLight))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    Text(draft.desc ?? "missing" )
                                        .font(.system(.footnote, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Divider()
                                }
                                     
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                }
                .sheet(isPresented: self.$isImagePickerDisplay) {
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                }
            } //scroll view
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        uploadPhoto()
                        showingAlert = true
                    }.alert("Your image has been saved to firebase", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
            }
        }
//        .sheet(isPresented: $showReviewViewSheet){
//            NavigationStack{
//                Draft(album: selectedAlbum ?? Album(id: "?????", name: "missing", image: "", artist: "missing", release: Date(), songs: "missing", genre: "missing"), rev: selectedDraft)
//                    .environmentObject(contextHolder)
//            }
//        }
    }
    func showStar (for number: Int) -> Image{
        if number > Int32(selectedDraft?.rating ?? 0) {
            return Image(systemName: "star")
        }
        else{
            return Image(systemName: "star.fill")
        }
            
    }
    func dateFormatter(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
        
            func uploadPhoto(){
                //ensure selected image prop isn't nil
                guard selectedImage != nil else {
                    return
                }
                //create storage reference
                let storageRef = Storage.storage().reference()
                
                //turn image into data
                let imageData = selectedImage!.jpegData(compressionQuality: 0.0)
                guard imageData != nil else{
                    return
                }
                // file path and name
                let path = "images/\(UUID().uuidString).jpg"
                let fileRef = storageRef.child(path) //create db collection in firebase
                
                //upload image
                let uploadImage = fileRef.putData(imageData!, metadata:nil){
                    metadata, error in
                    
                    if error == nil && metadata != nil{
                        //TODO: save reference to file in firestore db
                        let db = Firestore.firestore()
                        db.collection("images").document().setData(["url" : path, "user": email ?? ""]) // will generate a document for each image
                        
                    }
                }
                
                //save reference
                
            }
            
    }


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
