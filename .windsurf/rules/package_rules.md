---
trigger: always_on
---
# Dictionary Text Package Rules

## Code Quality Standards

### 1. Linting
- Must pass `flutter analyze` with zero issues
- No warnings, errors, or hints allowed
- Use `flutter_lints` package for consistent code style

### 2. Formatting
- Code must be formatted with `dart format`
- No formatting changes allowed in commits
- Line length must not exceed 80 characters

### 3. Testing
- All tests must pass: `flutter test`
- Test coverage should be maintained above 90%
- No timer-related code in tests (use `test_api` instead of real timers)
- Widget tests must use [testWidgets](cci:1://file:///Users/waseem/Documents/personals/dictionary_text/test/widgets/dictionary_text_test.dart:181:4-193:49) and pump widgets properly

### 4. Dependencies
- Only add dependencies that are absolutely necessary
- Prefer Flutter built-in widgets over third-party packages
- Avoid packages that cause test failures (e.g., flutter_animate)
- Keep dependency versions updated but stable

### 5. API Design
- Public APIs must be simple and intuitive
- Follow Flutter conventions (e.g., positional `data` parameter like Text widget)
- Remove internal/testing parameters from public constructors
- Use meaningful parameter names

### 6. Documentation
- All public APIs must have dartdoc comments
- README must be up-to-date with examples
- Include image/video placeholders for UI components

### 7. Git Workflow
- Commit messages must be descriptive and follow conventional format
- Each PR should address a single feature/fix
- Must pass all CI checks before merging
- Keep git history clean

### 8. Performance
- Avoid unnecessary rebuilds
- Use `const` constructors where possible
- Implement proper disposal of resources
- Cache expensive operations (e.g., API calls)

### 9. Accessibility
- Ensure proper contrast ratios
- Add semantic labels where needed
- Support screen readers
- Provide haptic feedback for interactions

### 10. Security
- Never hardcode API keys or sensitive data
- Validate all user inputs
- Use secure network practices
- Follow Flutter security guidelines

## Validation Commands

Before any commit/push, run:
```bash
flutter analyze
flutter test
dart format . --set-exit-if-changed