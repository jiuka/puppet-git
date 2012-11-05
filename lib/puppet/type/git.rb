module Puppet
  newtype(:git) do
    @doc = "Manage git repositories."

    ensurable do
      desc <<-EOT
        What state the repository should be in.
      EOT

      newvalue(:present, :event => :repo_cloned) do
        provider.clone
      end

      # Alias the 'present' value.
      aliasvalue(:cloned, :present)

      newvalue(:absent, :event => :repo_removed) do
        provider.remove
      end

      newvalue(:fetched) do
        current = provider.properties[:ensure]
        self.info "Run :retched"
        provider.fetch
        self.info "End Run :retched"

        if current == :absent
          :repo_cloned
        else
          :repo_fetch
        end
      end

      defaultto :present
    end

    newparam(:name) do
      desc "Name of the resource."

      isnamevar
    end

    newparam(:source) do
      desc "Source of the repo"

      validate do |value|
        if Puppet::Util.absolute_path?(value)
          if File.exists?("#{value}/.git/config") or
              File.exists?("#{value}/config")
            fail Puppet::Error, "'#{value}' is not a Git Repositorie."
          end
        elsif value !~ /^(?:git|ssh|https?):\/\/.*$/
          fail Puppet::Error, "'#{value}' is not a Git URL."
        end
      end
    end

    newparam(:path) do
      desc "Path of the repo."

      validate do |value|
        unless Puppet::Util.absolute_path?(value)
          fail Puppet::Error, "File paths must be fully qualified, not '#{value}'"
        end
      end
    end

    newparam(:bare) do
      desc "Is the repo a brea repo or not. Defaults to `nonbare`"

      defaultto :false
      
      newvalues(:true, :false)

      # Alias the values.
      aliasvalue(:bare, :true)
      aliasvalue(:nonbare, :false)
    end

    autorequire(:file) do
      autos = []
      if path = self[:path] and absolute_path?(path)
        autos << path
      end
      autos
    end

    def exists?
      @provider.properties[:ensure] != :absent
    end
  end
end
