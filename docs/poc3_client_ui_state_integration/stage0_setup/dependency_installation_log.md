# Dependency Installation Log (Stage 0)

> Populate this file with the full stdout from `flutter pub add` / `flutter pub get` commands.
>
> Include:
> 1. Timestamp of command execution
> 2. Exact command invocation(s)
> 3. Full console output (wrapped in triple backticks)
> 4. Any warnings or errors noted
> 5. Confirmation that `pubspec.lock` updated successfully

9:24 2025-06-13

```
PS D:\PROJECTS\worldchef\worldchef_poc_riverpod> flutter pub get
Resolving dependencies... 
Downloading packages... 
> flutter_lints 6.0.0 (was 3.0.2)
  go_router 13.2.5 (15.2.0 available)
  leak_tracker 10.0.9 (11.0.1 available)
  leak_tracker_flutter_testing 3.0.9 (3.0.10 available)
  leak_tracker_testing 3.0.1 (3.0.2 available)
> lints 6.0.0 (was 3.0.0)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
  test_api 0.7.4 (0.7.6 available)
  vector_math 2.1.4 (2.2.0 available)
  vm_service 15.0.0 (15.0.2 available)
Changed 2 dependencies!
9 packages have newer versions incompatible with dependency constraints.    
Try `flutter pub outdated` for more information.

*pubspec.lock verification:* Confirmed that `flutter_lints` 6.0.0 appears in pubspec.lock and analyzer runs without version conflict.

9:21 2025-06-13
```
PS D:\PROJECTS\worldchef\worldchef_poc_riverpod> flutter pub upgrade
Resolving dependencies... (1.5s)
Downloading packages... 
  flutter_lints 3.0.2 (6.0.0 available)
  go_router 13.2.5 (15.2.0 available)
  leak_tracker 10.0.9 (11.0.1 available)
  leak_tracker_flutter_testing 3.0.9 (3.0.10 available)
  leak_tracker_testing 3.0.1 (3.0.2 available)
  lints 3.0.0 (6.0.0 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
  test_api 0.7.4 (0.7.6 available)
  vector_math 2.1.4 (2.2.0 available)
  vm_service 15.0.0 (15.0.2 available)
> watcher 1.1.2 (was 1.1.1)
Changed 1 dependency!
11 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

9:20 2025-06-13

```
PS D:\PROJECTS\worldchef\worldchef_poc_riverpod> flutter pub outdated
Showing outdated packages.
[*] indicates versions that are not the latest available.

Package Name                  Current  Upgradable  Resolvable  Latest       

direct dependencies:
go_router                     *13.2.5  *13.2.5     15.2.0      15.2.0       

dev_dependencies:
flutter_lints                 *3.0.2   *3.0.2      6.0.0       6.0.0        

transitive dependencies:
material_color_utilities      *0.11.1  *0.11.1     *0.11.1     0.13.0       
meta                          *1.16.0  *1.16.0     *1.16.0     1.17.0       
test_api                      *0.7.4   *0.7.4      *0.7.4      0.7.6        
vector_math                   *2.1.4   *2.1.4      *2.1.4      2.2.0        
vm_service                    *15.0.0  *15.0.0     *15.0.0     15.0.2       
watcher                       *1.1.1   1.1.2       1.1.2       1.1.2        

transitive dev_dependencies:
leak_tracker                  *10.0.9  *10.0.9     *10.0.9     11.0.1       
leak_tracker_flutter_testing  *3.0.9   *3.0.9      *3.0.9      3.0.10       
leak_tracker_testing          *3.0.1   *3.0.1      *3.0.1      3.0.2        
lints                         *3.0.0   *3.0.0      6.0.0       6.0.0        

1 upgradable dependency is locked (in pubspec.lock) to an older version.    
To update it, use `flutter pub upgrade`.

3  dependencies are constrained to versions that are older than a resolvable version.
To update these dependencies, edit pubspec.yaml, or run `flutter pub upgrade --major-versions`.
```





09:14 2025-06-13

```bash
$ flutter pub add flutter_riverpod riverpod_lint riverpod_generator
$ flutter pub add dio connectivity_plus hive hive_flutter
$ flutter pub get
```

*Warnings noted:* The output lists multiple packages with newer versions incompatible with current constraints (e.g., `flutter_lints` 6.0.0, `go_router` 15.2.0). These are acceptable for PoC purposes; we remain on stable minor versions to avoid unrelated migration work.

*pubspec.lock verification:* File regenerated and contains the newly added packages (flutter_riverpod 2.6.1, dio 5.8.0+1, hive 2.2.3, etc.).

_Record commit: `git rev-parse HEAD` → `<insert-hash-after-commit>`_

```
PS D:\PROJECTS\worldchef\worldchef_poc_riverpod> flutter pub add flutter_riverpod riverpod_lint riverpod_generator
>> flutter pub add dio connectivity_plus hive hive_flutter
>> flutter pub get
Resolving dependencies... 
Downloading packages... (1.2s)
+ analyzer_plugin 0.13.1
+ ci 0.1.0
+ cli_util 0.4.2
+ custom_lint 0.7.5
+ custom_lint_builder 0.7.5
+ custom_lint_core 0.7.5
+ custom_lint_visitor 1.0.0+7.4.5
  flutter_lints 3.0.2 (6.0.0 available)
+ flutter_riverpod 2.6.1
+ freezed_annotation 3.0.0
  go_router 13.2.5 (15.2.0 available)
+ hotreloader 4.3.0
  leak_tracker 10.0.9 (11.0.1 available)
  leak_tracker_flutter_testing 3.0.9 (3.0.10 available)
  leak_tracker_testing 3.0.1 (3.0.2 available)
  lints 3.0.0 (6.0.0 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
+ riverpod 2.6.1
+ riverpod_analyzer_utils 0.5.10
+ riverpod_annotation 2.6.1
+ riverpod_generator 2.6.5
+ riverpod_lint 2.6.5
+ state_notifier 1.0.0
  test_api 0.7.4 (0.7.6 available)
  vector_math 2.1.4 (2.2.0 available)
  vm_service 15.0.0 (15.0.2 available)
  watcher 1.1.1 (1.1.2 available)
Changed 16 dependencies!
12 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Resolving dependencies... 
Downloading packages... 
+ connectivity_plus 6.1.4
+ connectivity_plus_platform_interface 2.0.1
+ dbus 0.7.11
+ dio 5.8.0+1
+ dio_web_adapter 2.1.1
  flutter_lints 3.0.2 (6.0.0 available)
  go_router 13.2.5 (15.2.0 available)
+ hive 2.2.3
+ hive_flutter 1.1.0
  leak_tracker 10.0.9 (11.0.1 available)
  leak_tracker_flutter_testing 3.0.9 (3.0.10 available)
  leak_tracker_testing 3.0.1 (3.0.2 available)
  lints 3.0.0 (6.0.0 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
+ nm 0.5.0
+ petitparser 6.1.0
  test_api 0.7.4 (0.7.6 available)
  vector_math 2.1.4 (2.2.0 available)
  vm_service 15.0.0 (15.0.2 available)
  watcher 1.1.1 (1.1.2 available)
+ xml 6.5.0
Changed 10 dependencies!
12 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Resolving dependencies... 
Downloading packages... 
  flutter_lints 3.0.2 (6.0.0 available)
  go_router 13.2.5 (15.2.0 available)
  leak_tracker 10.0.9 (11.0.1 available)
  leak_tracker_flutter_testing 3.0.9 (3.0.10 available)
  leak_tracker_testing 3.0.1 (3.0.2 available)
  lints 3.0.0 (6.0.0 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
  test_api 0.7.4 (0.7.6 available)
  test_api 0.7.4 (0.7.6 available)
  test_api 0.7.4 (0.7.6 available)
  vector_math 2.1.4 (2.2.0 available)
  vm_service 15.0.0 (15.0.2 available)
  watcher 1.1.1 (1.1.2 available)
  ```

When complete, mark this header with the date and commit hash used.

---
*Template generated: 2025-06-13* 