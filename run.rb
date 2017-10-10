require './lib/server'
$stdout.sync = true
server = Server.new
server.start