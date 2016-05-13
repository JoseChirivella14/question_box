class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_and_belongs_to_many :tags
  has_many :votes, as: :voteable
  has_many :image

  validates :title, presence: true
  validates :text, presence: true
  validates :user, presence: true

  scope :answered, -> { where('EXISTS (SELECT null FROM answers where answers.question_id = questions.id)') }
  scope :unanswered, -> { where('NOT EXISTS (SELECT null FROM answers where answers.question_id = questions.id)') }
  scope :recently_answered, -> do
    select('questions.*, MAX(answers.created_at) AS answered_at').
    joins('INNER JOIN answers ON answers.question_id = questions.id').
    group('questions.id').
    order('answered_at DESC')
  end

  def answered?
    answers.count > 0
  end

  def unanswered?
    !answered?
  end

  def has_chosen_answer?
    answers.where(chosen: true).count > 0
  end

  def score
    votes.sum(:value)
  end

  def self.tagged_with(name)
    Tag.find_by!(name: name).questions
  end

  def self.tag_counts
    Tag.select('tags.*, count(questions_tags.tag_id) as count').
        joins(:questions).group('tags.id').order('count(questions_tags.tag_id) DESC')
  end

  def tag_names
    tags.map(&:name)
  end

  def tag_list
    tag_names.join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
