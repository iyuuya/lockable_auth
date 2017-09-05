# frozen_string_literal: true

require 'spec_helper'
require 'active_model'

class KnockLockableDummyBaseModel
  include ActiveModel::Model

  attr_accessor :failed_attempts, :locked_at

  def save(*args)
    true
  end

  def persisted?
    true
  end

  def authenticate(unencrypted_password)
    self
  end
end

class KnockLockableDummyModel < KnockLockableDummyBaseModel
  include KnockLockable::Model
end

RSpec.describe KnockLockableDummyModel do
  describe 'class accessor' do
    describe '.maximum_attempts' do
      it 'should default value is 5' do
        expect(KnockLockableDummyModel.maximum_attempts).to eq 5
      end
    end

    describe '.unlock_in' do
      it 'should default vlaue is 1 hour' do
        expect(KnockLockableDummyModel.unlock_in).to eq 1.hour
      end
    end
  end

  describe '#lock_access!' do
    let(:dummy) { KnockLockableDummyModel.new }

    before { Timecop.freeze }
    after { Timecop.return }

    it 'should set the current time to locked_at' do
      expect(dummy).to receive(:save).with(validate: false)
      dummy.lock_access!
      expect(dummy.locked_at).to eq Time.now.utc
    end
  end

  describe '#unlock_access!' do
    let(:dummy) { KnockLockableDummyModel.new(locked_at: Time.now, failed_attempts: 5) }

    it 'should reset the locked_at and failed_attempts column' do
      expect(dummy).to receive(:save).with(validate: false)
      dummy.unlock_access!
      expect(dummy.locked_at).to be_nil
      expect(dummy.failed_attempts).to be_zero
    end
  end

  describe '#access_locked?' do
    subject { dummy.access_locked? }

    let(:dummy) { KnockLockableDummyModel.new(locked_at: locked_at) }

    context 'when locked_at is nil' do
      let(:locked_at) { nil }

      it { is_expected.to be_falsy }
    end

    context 'when locked_at is before locked_in.ago' do
      let(:locked_at) { Time.now.utc }

      before { KnockLockableDummyModel.unlock_in = 1.second }

      it { is_expected.to be_truthy }
    end

    context 'when locked_at is on locked_in.ago' do
      let(:locked_at) { Time.now.utc }

      before { KnockLockableDummyModel.unlock_in = 0.second }

      it { is_expected.to be_falsy }
    end

    context 'when locked_at is after locked_in.ago' do
      let(:locked_at) { Time.now.utc }

      before { KnockLockableDummyModel.unlock_in = -1.second }

      it { is_expected.to be_falsy }
    end
  end

  describe '#authenticate(unencrypted_password)' do
    subject { dummy.authenticate('password') }

    let(:dummy) { KnockLockableDummyModel.new(failed_attempts: 0) }

    context 'when not persisted' do
      before { expect(dummy).to receive(:persisted?).and_return(false) }

      it { is_expected.to be_truthy }
    end

    context 'when persisted' do
      before { expect(dummy).to receive(:persisted?).and_return(true) }

      context 'when lock expired' do
        it do
          expect(dummy).to receive(:lock_expired?).and_return(true)
          expect(dummy).to receive(:unlock_access!)
          subject
        end
      end

      context 'when not lock expired' do
        it do
          expect(dummy).to receive(:lock_expired?).and_return(false)
          expect(dummy).to_not receive(:unlock_access!)
          subject
        end
      end

      context 'when not access locked' do
        before { expect(dummy).to receive(:access_locked?).and_return(false) }

        it { is_expected.to be_truthy }
      end

      context 'when access locked' do
        before do
          expect(dummy).to receive(:access_locked?).and_return(true)
          expect(dummy).to receive(:save).with(validate: false)
        end

        it { is_expected.to be_falsy }
        it { expect { subject }.to change(dummy, :failed_attempts).by(1) }

        context 'when attempts exceeded' do
          before { expect(dummy).to receive(:attempts_exceeded?).and_return(true) }

          it do
            expect(dummy).to receive(:lock_access!).and_call_original
            is_expected.to be_falsy
          end
        end

        context 'when not attempts_exceeded' do
          before { expect(dummy).to receive(:attempts_exceeded?).and_return(false) }

          it do
            expect(dummy).not_to receive(:lock_access!)
            is_expected.to be_falsy
          end
        end
      end
    end
  end

  describe '#attempts_exceeded?' do
    subject { dummy.send(:attempts_exceeded?) }

    let(:dummy) { KnockLockableDummyModel.new(failed_attempts: failed_attempts) }

    context 'when failed_attempts is greater than maximum_attempts' do
      let(:failed_attempts) { KnockLockableDummyModel.maximum_attempts + 1 }

      it { is_expected.to be_truthy }
    end

    context 'when failed_attempts equals maximum_attempts' do
      let(:failed_attempts) { KnockLockableDummyModel.maximum_attempts }

      it { is_expected.to be_truthy }
    end

    context 'when failed_attempts is less than maximum_attempts' do
      let(:failed_attempts) { KnockLockableDummyModel.maximum_attempts - 1 }

      it { is_expected.to be_falsy }
    end
  end
end
