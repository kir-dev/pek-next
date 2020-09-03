require 'rails_helper'

RSpec.describe EvaluationPolicy, type: :policy do
  let(:point_detail) { create(:point_detail) }
  let(:user) { point_detail.point_request.evaluation.group.leader.user }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do

    it "requires group leader" do
      expect(subject).to permit(user, point_detail.destroy!)
    end
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
