# Juspay Testing App (Flutter)

## Running the server

-   Replace the constant values with your credentials in the `.env.sample` file and rename it to `.env`

-   Dev Environment (Hot Reloading)

```zsh
npm run dev
```

-   Without Hot Reloading

```zsh
npm start
```

-   Making the server accessible by client ( + Monitoring network)

```
ngrok http 5002
```

-   Replace the link provided by `ngrok` in `/app/lib/utils/data.dart`

## Running the app

-   Changing the dir

```zsh
cd app/
```

-   Installing dependencies

```zsh
flutter pub get
```

-   Running the app

```zsh
flutter run
```

## Testing payment page for different ClientIDs

-   You will have to replace the clientIDs in the following DIRs (Do a global search and replace the default clientid: `ipec`):
    -   `/.env`
    -   `/app/android/build.gradle`
    -   `/app/ios/merchantConfig.txt`
    -   `/app/lib/screens/home.dart`
