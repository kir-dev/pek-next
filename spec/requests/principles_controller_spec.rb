# frozen_string_literal: true

RSpec.describe PrinciplesController do
  before { login_as(user) }
  let(:principle) { create(:principle) }

  describe 'index' do
    context 'off season' do
      include_context 'off season'
      let(:user) { create(:user) }

      it 'returns forbidden' do
        get "/groups/#{principle.group.id}/evaluations/#{principle.evaluation.id}/principles"

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'application season' do
      include_context 'application season'
      let(:user) { principle.evaluation.group.leader.user }

      it 'is successful' do
        get "/groups/#{principle.group.id}/evaluations/#{principle.evaluation.id}/principles"

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'create' do
    context 'when application season' do
      include_context 'application season'

      context "when the user is the group leader" do
        let(:user) { principle.evaluation.group.leader.user }

        it 'creates the principle' do
          post "/groups/#{principle.group.id}/evaluations/#{principle.evaluation.id}/principles",
               params: { principle: principle.attributes, format: "javascript" }

          expect(response).to have_http_status(:ok)
        end
      end


      context 'when evaluation is not correct' do
        let(:user)       { principle.evaluation.group.leader.user }
        let(:evaluation) { create(:evaluation) }

        it 'returns forbidden' do
          post "/groups/#{evaluation.group.id}/evaluations/#{principle.evaluation.id}/principles"

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'the user is the leader of another group' do
        let(:user) { create(:group).leader.user }

        it 'returns forbidden' do
          post "/groups/#{principle.group.id}/evaluations/#{principle.evaluation.id}/principles"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
