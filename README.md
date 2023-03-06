# vinyl-final-proj
 Matthew Lunsford and Alexis Osipovs's final project for CS 4720 at UVA


## App Description -
⭐ A review app (similar to Letterboxd) in which users can publicly log reviews of albums. Users can find albums to review by either browsing the existing database of albums or by searching for new albums through a web API. We make use of the iTunes Search Web API to retrieve album data and Firebase to store reviews and other system data. We make use of the camera to allow users to upload profile photos and Core Data in order to allow users to save review drafts locally before publishing.

## Platform Justification - What are the benefits to the platform you chose?
⭐ We decided to develop our app through SwiftUI as this is the direction Apple is gradually transitioning into. It was also a good continuation of our learning from React Native and our second projects where we both did SwiftUI. As a programmatic UI, SwiftUI overall reduces the amount of code and allows us to view live changes through the dynamic preview. SwiftUI is also easier to read and is quite straightforward in many ways. 

## Major Features/Screens - Include short descriptions of each (at least 3 of these)
⭐ Our main screens include: login, homepage, search, album details, review, and profile. 
⭐ After logging in, the user’s information (email and password) is stored in Firebase and used to correspond with the other data they save on our application (reviews and profile pictures). The Homepage displays popular albums, albums users recently imported, and popular genres. The albums are stored through a database collection in Firebase. Our Search page utilizes the iTunes API to scrape all available albums. When a user searches for an album, it will automatically be stored in Firebase and displayed on the Homepage. Users can write a review once they select an album, and when they post the review, it is stored in a subcollection in Firebase already associated with the reviewed album. If they want to continue editing their review, users can save it as a draft and view it on their profile page.
⭐ We also simulated and tested interruptions like timers and phone calls and they did not affect our application.

## Optional Features - Include specific directions on how to test/demo each feature and declare the exact set that adds up to 
⭐ We utilized the following optional features: Core Data storage, Firebase storage, Camera, and Web Services (API). 
⭐For Core Data storage, a user can save a review as a draft rather than publish them. They can access their drafts on their profile page and are able to post them. We created a draft item entity data model to store and fetch their local drafts. 
