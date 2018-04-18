class Log

	def self.log(msg)
    info(msg)
	end

  def self.info(msg)
    puts_log "INFO", msg
  end

	def self.alert(msg)
		puts "[ALERT]#{time_now}| #{msg}"
	end

	def self.debug(msg)
		puts "[DEBUG]#{time_now}| #{msg}"
	end

	def self.error(msg)
    puts_log "ERROR", msg
	end

	def self.send(msg)
		#puts "#{'[SEND]'.green}#{time_now}| #{msg} "
	end

	def self.push(msg)
		#puts "#{'[PUSH]'.green}#{time_now}| #{msg} "
	end

	def self.time_now
		"[#{Time.now.strftime('%T')} #{Time.now.usec}]"
	end

  def self.puts_log(type, msg)
    puts "[#{Thread.current["name"]}][#{type}]#{time_now}| #{msg}"
  end

end
