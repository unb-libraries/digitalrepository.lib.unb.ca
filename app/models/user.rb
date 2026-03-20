class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles

  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules.
  # https://github.com/heartcombo/devise
  devise :rememberable, :omniauthable, omniauth_providers: %i[saml]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def self.from_omniauth(auth)
    provider_info = auth.extra.raw_info.attributes

    user = find_by(provider: auth.provider, uid: provider_info["eduPersonPrincipalName"][0])
    if user
      user.email = auth.info.email
      user.first_name = provider_info["givenName"][0]
      user.last_name = provider_info["sn"][0]
      user.display_name = "#{user.first_name} #{user.last_name}"
      user.save
    end
    user
  end
end
