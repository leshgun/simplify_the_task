flutterfire configure \
  -i com.example.simplify_the_task.dev \
  -a com.example.simplify_the_task.dev \
  -o lib/firebase/dev/firebase_options.dart \
  --project=simplify-the-task-dev \
  --no-apply-gradle-plugins \
  --platforms="android,ios"; \
  --no-app-id-json;

flutterfire configure \
  -i com.example.simplify_the_task \
  -a com.example.simplify_the_task \
  -o lib/firebase/prod/firebase_options.dart \
  --project=simplify-the-task \
  --no-apply-gradle-plugins \
  --platforms="android,ios" \
  --no-app-id-json




# Dev environment (note: do the same for Stg and Prod)
flutterfire config \
  --project=simplify-the-task \
  --out=lib/firebase_options.dart \ \
  --platforms="android,ios";
flutterfire config \
  --project=simplify-the-task-dev \
  --out=lib/firebase_options_dev.dart \
  --platforms="android,ios";
