require './lib/server'
Thread.abort_on_exception = true
$stdout.sync = true
server = Server.new
server.start
