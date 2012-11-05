module Puppet
  newtype(:gitconfig) do
    @doc = "Manage git repositorie configuration."

    ensurable do
      desc <<-EOT
        Determin if we should set, add, remove or unset the parameter.
      EOT

      newvalue(:present) do
        provider.set
      end

      # Alias the 'present' value.
      aliasvalue(:set, :present)

      newvalue(:add) do
        provider.add
      end

      newvalue(:absent) do
        provider.unset
      end

      # Alias the 'absent' value.
      aliasvalue(:unset, :absent)
      aliasvalue(:remove, :absent)

      defaultto :present

      # Override the parent method, because we've got all kinds of
      # funky definitions of 'in sync'.
      def insync?(is)
        @should.each do |should|
          case should
          when :present
            return true unless [:absent].include?(is)
          when :add
            return true unless [:absent].include?(is)
          when :absent
            return true if [:absent].include?(is)
          end
        end
        false
      end
    end

    newparam(:name) do
      desc "Name of the config resource."

      isnamevar
    end

    newparam(:repo) do
      desc "Path of the repo."

      validate do |value|
        unless Puppet::Util.absolute_path?(value)
          fail Puppet::Error, "Repo paths must be fully qualified, not '#{value}'"
        end
        unless File.exists?("#{value}/.git/config") or 
               File.exists?("#{value}/config")
          fail Puppet::Error, "Repo path do not point to a git repo"
        end
      end

      munge do |value|
        if File.exists?("#{value}/.git/config")
          "#{value}/.git"
        else
          value
        end
      end
    end

    newparam(:key) do
      desc "Name of the config parameter to change"

      validate do |value|
        unless value =~ /^\w+\.\w+(?:\.\w+)*/
          fail Puppet::Error, "Gitconfig key don't match it's requirements. '#{value}'"
        end
      end
    end

    newparam(:value) do
      desc "Value to set the parameter to."
    end

    def exists?
      provider.exists?
    end
  end
end
