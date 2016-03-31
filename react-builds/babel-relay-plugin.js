var babel = require('babel-core');
transformRelayCode = function(relayCode) { return babel.transform('a=1'); }
