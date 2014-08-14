console.log('\'use strict\';');
console.log();
console.log('var ns = {');

require('file').walkSync('.', function(dirPath, dirNames, fileNames) {
console.log(arguments);
  var entries = fileNames
    .filter(function(fileName) { return fileName.match('\.js$') && fileName != 'index.js'; })
    .map(function(fileName) {
      var className = fileName.substring(0, fileName.length - 3);
      var requirePath = './' + (dirPath === '.' ? '' :  dirPath + '/') + className;

      return '    ' + className + ': require(\'' + requirePath + '\')';
    });
  var refs = entries.join(',\n');
  console.log(refs);
});

console.log('};');
console.log();
console.log('Object.freeze(ns);');
console.log();
console.log('module.exports = ns;');
console.log();
