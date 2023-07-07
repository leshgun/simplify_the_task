# flutter build apk --split-per-abi --build-name=1.2.0
flutter build apk --flavor dev -t lib/main_dev.dart --split-per-abi --build-name=1.2.1_beta;
flutter build apk --flavor prod -t lib/main.dart --split-per-abi --build-name=1.2.1
