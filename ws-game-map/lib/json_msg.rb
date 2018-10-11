class JsonMsg

  def self.error(detail = nil)
    create_msg('error', detail)
  end

  def self.success(detail = nil)
    create_msg('success', detail)
  end

  def self.create_msg(status, detail = nil)
    hash = {status: status}
    hash = hash.merge({detail: detail}) if detail.is_a? String
    hash = hash.merge detail if detail.is_a? Hash

    JSON.generate hash
  end

end