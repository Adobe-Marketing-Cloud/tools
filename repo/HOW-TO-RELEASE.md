How to create a `repo` release
==============================

Requirements: push rights for [Adobe-Marketing-Cloud/tools](https://github.com/Adobe-Marketing-Cloud/tools) and [Adobe-Marketing-Cloud/homebrew-brews](https://github.com/Adobe-Marketing-Cloud/homebrew-brews).

Steps:

1. prepare github release (if it does not exist yet)
   - go to [releases](https://github.com/Adobe-Marketing-Cloud/tools/releases) and "Draft a new release"
   - title: `repo VERSION` (e.g. `repo 1.4`)
   - description: list changes with sections "New" & "Fixes" (check github issues & commits)
   - save as draft
2. bump up `VERSION=` in script to release number
   - e.g. `1.4-beta` to `1.4`
   - commit
3. edit github release

   - set tag to `repo-VERSION` (e.g. `repo-1.4`)
   - attach repo script file (the just tagged version) as release binary
   - save and publish release
   
4. update homebrew formula (on OSX), based on [this guide](http://thecoatlessprofessor.com/programming/updating-a-homebrew-formula/) and the cheatsheet [here](https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md) (section "Contribute a fix to the foo formula")
   
   - `brew update`
   - `cd $(brew --repo adobe-marketing-cloud/brews)`
   - `git checkout -b repo-VERSION origin/master` (e.g. `-b repo-1.4`)
   - `brew audit --strict --online repo.rb` and track any errors (fix below when editing)
   - `brew edit repo.rb` (or edit `repo.rb` directly using your favorite editor)
   - update version & download URL & sha1, then save
   - `brew uninstall --force repo.rb`
   - `brew install --build-from-source repo.rb`
   - `brew test repo.rb`
   - `repo --version` should return VERSION
   - `brew audit --strict --online repo.rb`
   - `git add repo.rb`
   - `git commit -m "updating repo to VERSION"` (e.g. 1.4)
   - `git push`
   - test `brew install adobe-marketing-cloud/brews/repo` or `brew upgrade adobe-marketing-cloud/brews/repo` on a "clean" machine