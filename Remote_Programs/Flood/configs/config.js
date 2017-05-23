const CONFIG = {
  baseURI: '/username/flood',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: './server/db/',
  floodServerHost: '0.0.0.0',
  floodServerPort: PORT,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: 'SECRETKEY',
  scgi: {
    socket: true,
    socketPath: 'SOCKETPATH'
  },
  ssl: false,
  sslKey: '/absolute/path/to/key/',
  sslCert: '/absolute/path/to/certificate/'
};

module.exports = CONFIG;

