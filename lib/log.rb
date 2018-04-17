class Log

	def self.log(msg)
    info(msg)
	end

  def self.info(msg)
		puts "[INFO]#{time_now}| #{msg}"
  end

	def self.alert(msg)
		puts "[ALERT]#{time_now}| #{msg}"
	end

	def self.debug(msg)
		puts "[DEBUG]#{time_now}| #{msg}"
	end

	def self.error(msg)
		puts "[ERROR]#{time_now}| #{msg}"
	end

	def self.send(msg)
		puts "#{'[SEND]'.green}#{time_now}| #{msg} "
	end

	def self.push(msg)
		puts "#{'[PUSH]'.green}#{time_now}| #{msg} "
	end

	def self.time_now
		"[#{Time.now.strftime('%T')} #{Time.now.usec}]"
	end

end
