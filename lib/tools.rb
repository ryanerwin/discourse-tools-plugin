module Tools

  class << self

    # child theme
    def add_child_theme(*args)
      parent, child = args.map { |theme_name| find_theme(theme_name) }

      child_ids = parent.child_theme_relation.pluck(:child_theme_id)

      if !child_ids.include?(child.id)
        parent.add_child_theme!(child)
      end
    end

    def remove_child_theme(*args)
      parent, child = args.map { |theme_name| find_theme(theme_name) }

      parent.child_theme_relation.find_by(child_theme_id: child.id)&.destroy
    end

    # disable users
    def disable_users_except_group(group_name, till)
      raise "'till' argument is not a 'Time' object" if !till.is_a?(Time)
      raise "'till' argument can't be in the past" if Time.now > till

      group = Group.find_by(name: group_name)

      raise "Group not found: #{group_name}" if !group

      group_user_ids = group.group_users.pluck(:user_id)
      user_ids = User.not_suspended.where.not(id: group_user_ids).order(:id).pluck(:id)

      # disable user in chunk so your server not blown up
      loop {

        User.where(id: user_ids.shift(100)).each do |user|
          user.suspended_till = till
          user.custom_fields["temp_disabled"] = "t"
          user.save!
        end

        break if user_ids.length < 1
      }

    end

    def enable_users_except_group
      user_ids = UserCustomField.where(name: "temp_disabled", value: "t").pluck(:user_id)

      loop {

        User.where(id: user_ids.shift(100)).each do |user|
          user.suspended_till = nil
          user._custom_fields.where(name: "temp_disabled").first.destroy
          user.save!
        end

        break if user_ids.length < 1
      }
    end

    private

    def find_theme(theme_name)
      theme_count = Theme.where(name: theme_name).count

      raise "Theme not found: #{theme_name}" if theme_count < 1
      raise "Found more than 1 theme named '#{theme_name}'" if theme_count > 1

      Theme.find_by(name: theme_name)
    end

  end

end
