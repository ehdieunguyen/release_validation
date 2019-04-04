const md2json = require('md-2-json');
const fs = require('fs-extra');

const argv = require('minimist')(process.argv.slice(2));
const changeLogPath = argv.f;
const releaseVersion = argv.v;

if (changeLogPath == undefined) {
  throw 'Please set the CHANGELOG.md file path';
}

if (releaseVersion == undefined) {
  throw 'Please set a new release version';
}

let releaseNoteContent;

try {
  const fileContents = fs.readFileSync(changeLogPath, 'utf8');
  const jsonContent = md2json.parse(fileContents);
  releaseNoteContent = jsonContent['Changelog'][releaseVersion]['raw'];
} catch (err) {
  throw err.message;
}

if (!releaseNoteContent || releaseNoteContent.length == 0) {
  throw 'Please make sure to adding the release note on CHANGELOG.md file';
}

console.log(releaseNoteContent);
