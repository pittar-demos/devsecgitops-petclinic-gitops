
VERSION_TYPE="release"
version="2.4.3-SNAPSHOT-234"

if [ "$VERSION_TYPE" == "release" ]; then
  version=${version%-SNAPSHOT*}
  echo "$version"
fi

