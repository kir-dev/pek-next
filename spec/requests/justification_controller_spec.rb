describe JustificationsController do
  shared_context 'current user is the group leader' do
    let(:user) { group.leader.user }
  end
  before(:each) { login_as(user) }
  let(:group) { evaluation.group }
  let(:evaluation) { create(:evaluation) }

  describe '#edit' do
    include_context 'evaluation season'
    include_context 'current user is the group leader'
    before(:each) do
      EntryRequest.create!(user: user, evaluation: evaluation, entry_type: EntryRequest::AB)
    end

    it 'is ok' do
      get "/groups/#{group.id}/evaluations/#{evaluation.id}/justifications/edit"

      expect(response).to have_http_status :ok
    end
  end
end
