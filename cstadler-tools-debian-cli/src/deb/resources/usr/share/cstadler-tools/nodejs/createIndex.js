console.log('\'use strict\';');
console.log();
console.log('var ns = {');

var entries = [];
require('file').walkSync('.', function(dirPath, dirNames, fileNames) {
  fileNames
    .filter(function(fileName) { return fileName.match('\.js$') && fileName != 'index.js'; })
    .forEach(function(fileName) {
      var className = fileName.substring(0, fileName.length - 3);
      var requirePath = './' + (dirPath === '.' ? '' :  dirPath + '/') + className;

      entries.push('    ' + className + ': require(\'' + requirePath + '\')');
    });
});

var refs = entries.join(',\n') + (entries.length > 0 ? ',' : '');
console.log(refs);
console.log('};');
console.log();
console.log('Object.freeze(ns);');
console.log();
console.log('module.exports = ns;');
