echo "Download hugo theme..."
git submodule update --init --recursive

echo "Download npm dependencies"
npm install -D autoprefixer
npm install -D postcss-cli
npm install -D postcss
npm install