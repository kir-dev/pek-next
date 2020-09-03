require 'rails_helper'

RSpec.describe PointDetailPolicy, type: :policy do
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
    context "when current_user is the group leader" do
      include_context "application season"
      it "requiers group leader" do
        expect(subject).to permit(user, point_detail.destroy!)
      end
    end
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
