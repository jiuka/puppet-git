Puppet::Type.type(:git).provide :git do
  desc "Support via `git`."

  commands :git => "git"

  def path
    path = @resource[:path]
    if !path
      path = @resource[:name]
    end
    path
  end

  def source
    source = @resource[:source]
    if !source and @resource[:path]
      source = @resource[:name]
    end
    source
  end

  def clone
    opt = []
    if @resource[:bare] == :bare
      opt << "--bare"
    end

    if source
      git(:clone, source, path, *opt)
    else
      git(:init, path, *opt)
    end
  end

  def remove
    File.unlink(@resource[:path])
  end

  def fetch
    if properties[:ensure] == :absent
      clone
    else
      self.info "P #{properties}"
      ENV['GIT_DIR'] = properties[:gitpath]
      git(:fetch)
    end
  end

  def query
    hash = {}

    if File.exists?("#{path}/.git/config")
      hash[:ensure] = :present
      hash[:gitpath] = "#{path}/.git/"
      hash[:bare] = false
    elsif File.exists?("#{path}/config")
      hash[:ensure] = :present
      hash[:gitpath] = path
      hash[:bare]  = true
    else
      return nil
    end

    @property_hash.update(hash)
    @property_hash.dup
  end

  # Look up the current status.
  def properties
    if @property_hash.empty?
      @property_hash = query || {:ensure => :absent}
      @property_hash[:ensure] = :absent if @property_hash.empty?
    end
    @property_hash.dup
  end
end
