require "rails_helper"

Fabricator(:theme) {
  user
  name { sequence(:name) { |i| "theme#{i}" } }
}

describe(Tools) {
  context("add/remove child theme") {
    let(:parent_theme) { Fabricate(:theme) }
    let(:child_theme) { Fabricate(:theme) }

    it("should success") {
      Tools.add_child_theme(parent_theme.name, child_theme.name)
      parent_theme.reload
      expect(parent_theme.child_themes.map(&:id).include?(child_theme.id)).to eq(true)

      Tools.remove_child_theme(parent_theme.name, child_theme.name)
      parent_theme.reload
      expect(parent_theme.child_themes.map(&:id).include?(child_theme.id)).to eq(false)
    }
  }

  context("disable/enable users") {
    let!(:group_users) { 5.times.map { Fabricate(:user) } }
    let!(:other_users) { 10.times.map { Fabricate(:user) } }
    let(:group) { Fabricate(:group) }

    before {
      group.bulk_add(group_users.map(&:id))
      Tools.disable_users_except_group(group.name, 1.day.from_now)
    }

    context("disable") {
      it("should not disable member of group") {
        group_users.each do |user|
          user.reload
          expect(user.suspended?).to eq(false)
        end
      }

      it("should disable users not member of group") {
        other_users.each do |user|
          user.reload
          expect(user.suspended?).to eq(true)
        end
      }
    }

    context("enable") {
      before {
        Tools.enable_users_except_group
      }

      it("should not disable users not member of group") {
        other_users.each do |user|
          user.reload
          expect(user.suspended?).to eq(false)
        end
      }
    }

  }
}
