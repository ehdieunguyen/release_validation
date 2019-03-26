var md2json = require('md-2-json');
var fs = require('fs-extra');

const fileContents = fs.readFileSync('./CHANGELOG.md', 'utf8');
const jsonContent = md2json.parse(fileContents);

let appJsonRaw = fs.readFileSync('./app.json');
let currentVersion = JSON.parse(appJsonRaw)['version'];

console.log(jsonContent['Changelog'][currentVersion]['raw']);
