class Project
  belongs_to :user
  belongs_to :organization

  with_options :dependent => :delete_all do |delete|
    delete.has_many :people
    delete.has_many :task_lists, :conditions => { :page_id => nil }
    delete.has_many :tasks
    delete.has_many :invitations
    delete.has_many :uploads
    delete.has_many :pages
    
    delete.with_options :order => 'id DESC' do |ordered|
      ordered.has_many :conversations
      ordered.has_many :activities
      ordered.has_many :comments
    end
  end

  has_many :users, :through => :people, :order => 'users.updated_at DESC'
end