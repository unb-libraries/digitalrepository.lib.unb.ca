namespace :roles do
  desc "Sync roles from config/role_map.yml"
  task sync: :environment do
    Rails.logger.info "Syncing roles from config/role_map.yml"
    map = YAML.load_file(Rails.root.join("config/role_map.yml"))

    roles = map[Rails.env] || {}
    roles.each do |role_name, users|
      r = Role.find_or_create_by(name: role_name)
      unless Rails.env.production?
        users.each do |uid|
          u = User.find_or_create_by(uid: uid, provider: "saml")
          u.roles << r unless u.roles.include?(r)
        end
      end
    end
  end
end
