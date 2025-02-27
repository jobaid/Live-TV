Overview

Live TV is an iOS application designed to provide users with seamless access to live television channels. Built using Swift 5, the app ensures high-quality video streaming, an intuitive user interface, and a smooth user experience. It supports various channel categories and includes features such as search functionality, favorites, and user-friendly navigation.

Features

Live Streaming: Watch TV channels in real time with minimal buffering.

User-Friendly Interface: Simple and intuitive design for easy navigation.

Search Functionality: Quickly find channels by name or category.

Favorites List: Save your preferred channels for quick access.

Multi-Category Support: Browse channels by different genres such as news, sports, entertainment, and more.

Adaptive Streaming: Adjusts video quality based on network conditions for a smooth viewing experience.

Dark Mode Support: Provides a comfortable viewing experience in low-light conditions.

Technologies Used

Swift 5 – Programming language for iOS development.

AVPlayer – Native Apple video player for streaming live content.

UIKit – UI framework for building interactive elements.

Core Data – Used for managing local storage of user preferences and favorite channels.

Google AdMob – Integrated for monetization through ads.

RESTful APIs – Fetches channel lists and stream URLs dynamically.

Installation

Follow these steps to set up and run the Live TV app on your local machine:

Clone the Repository:

git clone https://github.com/jobaid/Live-TV.git
cd Live-TV

Install Dependencies:
Open the project in Xcode and ensure all dependencies are installed.

Set Up API Keys:

If the app requires an API key for fetching channels, update the configuration in Config.swift.

Run the App:

Select a simulator or a connected device in Xcode.

Click on Run (▶) to build and launch the app.

Monetization with Google Ads

The app includes Google AdMob integration to generate revenue. Ensure you have the correct AdMob app ID and ad unit IDs configured in your Info.plist file.

Steps to Enable Google Ads

Register an account on Google AdMob.

Create an ad unit and obtain the AdMob App ID.

Add the App ID in Info.plist:

<key>GADApplicationIdentifier</key>
<string>your-admob-app-id</string>

Enable necessary privacy permissions for iOS compliance.

Contributing

Contributions are welcome! If you would like to contribute to this project, follow these steps:

Fork the repository.

Create a new branch (git checkout -b feature-branch).

Make your changes and commit (git commit -m "Add new feature").

Push to your branch (git push origin feature-branch).

Open a Pull Request.

License

This project is licensed under the MIT License. See the LICENSE file for more details.

Contact

For any questions, suggestions, or support, feel free to reach out via GitHub issues or contact the project owner directly.

Enjoy seamless live TV streaming with the Live TV app! 🚀

