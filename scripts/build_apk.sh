# flutter build apk --split-per-abi --build-name=1.2.0
flutter build apk --flavor dev -t lib/main_dev.dart --split-per-abi --analyze-size --build-name=1.2.1_beta;
flutter build apk --release --flavor prod -t lib/main_prod.dart --split-per-abi --obfuscate --analyze-size --build-name=1.2.1
