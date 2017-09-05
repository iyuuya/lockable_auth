# frozen_string_literal: true

require 'active_support/all'

module LockableAuth
  DEFAULT_MAXIMUM_ATTEMPTS = 5
  DEFAULT_UNLOCK_IN = 1.hour

  extend ActiveSupport::Concern

  included do
    class << self
      attr_accessor :maximum_attempts, :unlock_in
    end

    self.instance_eval do
      @maximum_attempts = DEFAULT_MAXIMUM_ATTEMPTS
      @unlock_in = DEFAULT_UNLOCK_IN
    end
  end

  def lock_access!
    self.locked_at = Time.now.utc
    save(validate: false)
  end

  def unlock_access!
    self.locked_at = nil
    self.failed_attempts = 0
    save(validate: false)
  end

  def access_locked?
    locked_at.present? && !lock_expired?
  end

  def authenticate(unencrypted_password)
    return super unless persisted?

    unlock_access! if lock_expired?

    if super && !access_locked?
      unlock_access!
      self
    else
      self.failed_attempts ||= 0
      self.failed_attempts += 1
      if attempts_exceeded?
        lock_access!
      else
        save(validate: false)
      end
      false
    end
  end

  protected

  def attempts_exceeded?
    (self.class.maximum_attempts != 0) and (self.failed_attempts >= self.class.maximum_attempts)
  end

  def lock_expired?
    (self.class.unlock_in.to_i == 0) or (locked_at && locked_at < self.class.unlock_in.ago)
  end
end
