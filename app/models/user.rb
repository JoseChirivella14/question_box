class User < ActiveRecord::Base
	include Gravtastic
	gravtastic :default => 'identicon'

	has_many :questions
	has_many :answers

	has_many :comments
	has_many :votes

	validates :email,
	presence: true,
	uniqueness: { case_sensitive: false },
	format: { with: /\A[\w\-\.]+@[\w\-\.]+\Z/, message: "must be a valid email address" }

	validates :name, presence: true

	validates :score,
	presence: true,
	numericality: { only_integer: true, greater_than_or_equal_to: 0 }

	def so_reputation
		if !stack_overflow_url.blank?
			response = RubyStackoverflow.users({ inname: so_username })
			response.data.first.reputation
		end
	end

	def so_username
		stack_overflow_url.split("/").last
	end

	def github_repos
		return []
		if !github_username.blank?
			Github.repos.list(user: github_username, sort: updated_at, direction: 'desc', per_page: 10 ).to_a.map do |repo|
				{name: repo[:name],
				 html_url: repo[:html_url],
				 updated_at: repo[:updated_at]
				}
			end
		end
	end

has_secure_password
end
