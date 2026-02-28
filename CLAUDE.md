# CLAUDE Instructions

## Release Instruction

### 1. Ensure you are on `main` and it is up-to-date

```bash
git checkout main
git pull origin main
```

---

### 2. Determine the next version

Follow [Semantic Versioning](https://semver.org/):

| Change type | Example bump |
|---|---|
| Bug fixes only | `0.5.1` → `0.5.2` |
| New backward-compatible features | `0.5.1` → `0.6.0` |
| Breaking changes | `0.5.1` → `1.0.0` |

Current version is in `lib/easyship/version.rb`. Review the `[Unreleased]` section of `CHANGELOG.md` to decide the correct bump type.

---

### 3. Update the version constant

Edit `lib/easyship/version.rb` and set the new version:

```ruby
module Easyship
  VERSION = 'X.Y.Z'  # replace with the new version
end
```

---

### 4. Update `CHANGELOG.md`

The changelog follows [Keep a Changelog](https://keepachangelog.com/) format.

- Rename the `## [Unreleased]` section header to `## [vX.Y.Z](https://github.com/mmarusyk/easyship/tree/vX.Y.Z) - YYYY-MM-DD`
  - Use today's date in `YYYY-MM-DD` format.
- Add a new empty `## [Unreleased]` section at the top (above the new version section).

**Before:**
```markdown
## [Unreleased]

### Added
- Some new feature
```

**After:**
```markdown
## [Unreleased]

## [v0.6.0](https://github.com/mmarusyk/easyship/tree/v0.6.0) - 2026-02-28

### Added
- Some new feature
```

---

### 5. Run bundle install and tests with linting

```bash
bundle install
bundle exec rake
```

This runs both the test suite (`rspec`) and linter (`rubocop`). **Do not proceed if either fails.** Fix all issues before continuing.

---

### 6. Commit the release changes

Stage only the version and changelog files:

```bash
git add lib/easyship/version.rb CHANGELOG.md Gemfile.lock
git commit -m "Release vX.Y.Z"
```

The commit message must follow the pattern `Release vX.Y.Z` exactly (e.g. `Release v0.6.0`).

---

### 7. Push the commit to `main`

```bash
git push origin main
```

---

### 8. Create and push the version tag

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

Pushing a tag matching `v*` automatically triggers the `.github/workflows/release.yml` GitHub Actions workflow, which builds and publishes the gem to RubyGems.org using trusted publishing (no manual API key needed).

---

### 9. Verify the release

- Check the [Actions tab](https://github.com/mmarusyk/easyship/actions) to confirm the `Release Gem` workflow completed successfully.
- Confirm the new version appears on [RubyGems.org](https://rubygems.org/gems/easyship).

---
