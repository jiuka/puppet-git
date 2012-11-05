# Gitconfig provider


Puppet::Type.type(:gitconfig).provide :git do
  desc "Support vis `git`."

  commands :git => "git"

  # Prefetch git config from all repositories we manage
  def self.prefetch(resources = nil)
    cache = {}
    resources.each do |name, resource|
      if repo = @resource[:repo]
        repo = :global
      end
      if cache.include?(repo)
        resource.provider.update(cache[repo])
        next
      end

      if repo == :global
        out = git(:config, "--global", "--list")
      else
        ENV['GIT_DIR'] = repo
        out = git(:config, "--local", "--list")
      end

      cache[repo] = {}
      out.each_line do |line|
        line.chomp!
        k, v = line.split('=')
        if ! cache[repo].include?(k)
          cache[repo][k] = []
        end
        cache[repo][k] << v
      end
      self.info "Cache: #{cache[repo].inspect}"
      resource.provider.update(cache[repo])
    end
  end

  def set
    if @resource[:repo]
      ENV['GIT_DIR'] = @resource[:repo]
      git(:config, "--local", @resource[:key], @resource[:value])
    else
      git(:config, "--global", @resource[:key], @resource[:value])
    end
  end

  def add
    if @resource[:repo]
      ENV['GIT_DIR'] = @resource[:repo]
      git(:config, "--local", "--add", @resource[:key], @resource[:value])
    else
      git(:config, "--global", "--add", @resource[:key], @resource[:value])
    end
  end

  def unset
    if @resource[:repo]
      ENV['GIT_DIR'] = @resource[:repo]
      if @resource[:value]
        git(:config, "--local", "--unset", @resource[:key], @resource[:value])
      else
        git(:config, "--local", "--unset-all", @resource[:key])
      end
    else
      if @resource[:value]
        git(:config, "--global", "--unset", @resource[:key], @resource[:value])
      else
        git(:config, "--global", "--unset-all", @resource[:key])
      end
    end
  end

  def update(hash)
    @property_hash.update(hash)
  end

  # Look up the current status.
  def properties
    if @property_hash.empty?
      @property_hash[:ensure] = :failed if @property_hash.empty?
    end
    @property_hash.dup
  end

  def exists?
    if ! properties.include?(@resource[:key])
      return false
    end

    case @resource[:ensure]
    when :present
      if properties[@resource[:key]] == [@resource[:value]]
        return true
      end
      return false
    when :add
      if properties[@resource[:key]].include?(@resource[:value])
        return true
      end
      return false
    when :absent
      if @resource[:value]
        return true
      else
        return properties[@resource[:key]].include?(@resource[:value])
      end
    end

    self.info "e: #{@resource[:ensure]}"
    self.info "k: #{@resource[:key]}"
    self.info "v: #{@resource[:value]}"
    self.info "p: #{properties.inspect}"
  end
end
