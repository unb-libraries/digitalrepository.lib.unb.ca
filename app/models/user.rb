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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[saml]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def self.from_omniauth(auth)
    provider_info = auth.extra.raw_info.attributes

    user = find_or_initialize_by(provider: auth.provider, uid: provider_info["eduPersonPrincipalName"][0])
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.first_name = provider_info["givenName"][0]
    user.last_name = provider_info["sn"][0]
    user.display_name = "#{user.first_name} #{user.last_name}"
    user.department = provider_info["l"][0]
    user.title = provider_info["title"][0]
    user.telephone = provider_info["telephoneNumber"][0]

    user.save
    user
  end
end
