module Common

  extend ActiveSupport::Concern

  included do
    before_create :set_created_at, :set_updated_at
    before_update :set_updated_at
  end

  protected

  def set_created_at
    self.created_at = Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

  def set_updated_at
    self.updated_at = Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end

end