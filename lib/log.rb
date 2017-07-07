class Log

	def self.log(msg)
		puts "#{time_now} #{msg}"
	end

	def self.alert(msg)
		puts "#{time_now} #{'ALERT'.red} #{msg}"
	end

	def self.debug(msg)
		puts "#{time_now} #{'DEBUG'.blue}  #{msg}"
	end

	def self.send(msg)
		puts "#{time_now} #{'SEND'.green} #{msg} "
	end

	def self.push(msg)
		puts "#{time_now} #{'PUSH'.green} #{msg} "
	end

	def self.time_now
		"#{Time.now.strftime('%T')} #{Time.now.usec}"
	end

end