describe Evaluation do
  let(:evaluation) { create(:evaluation) }

  context 'when evaluation season' do
    include_context "evaluation season"

    it 'accepting the evaluation notifies only the group leader' do
      expect {
        evaluation.update(point_request_status: Evaluation::ACCEPTED)
      }.to change {
        evaluation.group.leader.user.notifications.count
      }.by(1).and change {
        User.includes(:notifications).all.map(&:notifications).flatten.count
      }.by(1)
    end

    it 'rejecting the evaluation notifies only the group leader' do
      expect {
        evaluation.update(point_request_status: Evaluation::REJECTED)
      }.to change {
        evaluation.group.leader.user.notifications.count
      }.by(1).and change {
        User.includes(:notifications).all.map(&:notifications).flatten.count
      }.by(1)
    end

    it 'submitting a point request notifies only the resort leader' do
      expect {
        evaluation.update(point_request_status: Evaluation::NOT_YET_ASSESSED)
      }.to change {
        evaluation.group.parent.leader.user.notifications.count
      }.by(1).and change {
        User.includes(:notifications).all.map(&:notifications).flatten.count
      }.by(1)
    end

    context 'the group parent does not have a leader' do
      before(:each) do
        evaluation.group.parent.leader.delete
      end

      it 'submitting a point request does not notify the resort leader' do
        expect {
          evaluation.update(point_request_status: Evaluation::NOT_YET_ASSESSED)
        }.to change {
          User.includes(:notifications).all.map(&:notifications).flatten.count
        }.by(0)
      end
    end
  end

  context "when application season" do
    include_context "application season"

    it 'submitting a point request does not send a notification' do
      expect {
        evaluation.update(point_request_status: Evaluation::NOT_YET_ASSESSED)
      }.to change {
        User.includes(:notifications).all.map(&:notifications).flatten.count
      }.by(0)
    end
  end
end
