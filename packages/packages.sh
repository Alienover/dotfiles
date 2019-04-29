# Install yarn
brew install yarn --ignore-dependencies

# Install the python 2 and stable python
brew install python@2 python

# Install the linters for javascript
yarn global add eslint prettier flow-bin typescript

# Install the linters for python
pip install pylint autopep8

# Install tern for deoplete
yarn global add tern
