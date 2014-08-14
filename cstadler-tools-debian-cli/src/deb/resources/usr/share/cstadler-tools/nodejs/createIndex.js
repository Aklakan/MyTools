
console.log('var ns = {');

require('file').walkSync('.', function(dir, path, fileNames) {
  var entries = fileNames
    .filter(function(fileName) { return fileName != 'index.js'; })
    .map(function(fileName) {
      if(fileName.match('\.js$')) {
        var className = fileName.substring(0, fileName.length - 3);
        var requirePath = './' + path.join('/') + className;

        return '  ' + className + ': require(\'' + requirePath + '\')';
      }
    });
  var refs = entries.join(',\n');
  console.log(refs);
});

console.log('};');

console.log('Object.freeze(ns);');

console.log('module.exports = ns;');

