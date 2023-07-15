flutterfire configure \
  -o lib/firebase/dev/firebase_options.dart \
  -i "com.example.simplifyTheTaskDev" \
  -a "com.example.simplify_the_task.dev" \
  --project="simplify-the-task" \
  --platforms="android,ios" \
  --no-apply-gradle-plugins \
  --no-app-id-json;

flutterfire configure \
  -o lib/firebase/prod/firebase_options.dart \
  --no-apply-gradle-plugins \
  --project="simplify-the-task" \
  --platforms="android,ios" \
  --no-app-id-json



# export PATH="$PATH":"$HOME/.pub-cache/bin"
# Dev environment (note: do the same for Stg and Prod)
# flutterfire config \
#   --project=simplify-the-task \
#   --out=lib/firebase_options.dart \ \
#   --platforms="android,ios";
# flutterfire config \
#   --project=simplify-the-task-dev \
#   --out=lib/firebase_options_dev.dart \
#   --platforms="android,ios";
