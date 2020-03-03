# frozen_string_literal: true

describe AuthSchServicesController do
  describe '#sync' do
    subject { get "/services/sync/#{id}" }
    before { subject }

    context 'when the id is invalid' do
      let(:id) { 'invalidid' }

      it 'returns bad request' do
        expect(response).to have_http_status :bad_request
        expect(json_body['success']).to be false
        expect(json_body['message']).to eq I18n.t(:invalid_id)
      end
    end

    context 'when the id does not exist' do
      let(:id) { 'ASDBSD' }

      it 'returns bad request' do
        expect(response).to have_http_status :not_found
        expect(json_body['success']).to be false
        expect(json_body['message']).to eq I18n.t(:non_existent_id, id: id)
      end
    end

    context 'when proper neptun code provided' do
      let(:user) { create(:user) }
      let(:id) { user.neptun }

      it 'returns the correct data' do
        expected_result = {
          'displayName'           => "#{user.lastname} #{user.firstname}",
          'mail'                  => user.email,
          'givenName'             => user.firstname,
          'sn'                    => user.lastname,
          'eduPersonNickName'     => user.nickname,
          'uid'                   => user.screen_name,
          'mobile'                => user.cell_phone,
          'schacPersonalUniqueId' => user.id
        }

        expect(response).to have_http_status :success
        expect(json_body['success']).to be true
        expect(json_body['user']).to eq expected_result
      end
    end
  end

  describe '#memberships' do
    it 'returns the correct data' do
      user       = create(:user)
      group      = create(:group)
      membership = create(:membership, group: group, user: user)

      expected_result = [
        {
          'start'      => membership.start_date.to_s,
          'end'        => membership.end_date,
          'group_name' => group.name,
          'group_id'   => group.id,
          'posts'      => ['tag']
        }
      ]
      get "/services/sync/#{user.auth_sch_id}/memberships"

      expect(response).to have_http_status :success
      expect(json_body['success']).to be true
      expect(json_body['memberships']).to eq expected_result
    end
  end

  describe '#entrants' do
    context 'by authsch id' do
      it 'returns entrants for a single semester and user' do
        user          = create(:user)
        group         = create(:group)
        membership    = create(:membership, group: group, user: user)
        evaluation    = create(:evaluation, :accepted, group: group)
        entry_request = EntryRequest.create(user: user, evaluation: evaluation)

        expected_response = [
          {
            'groupId'     => group.id,
            'groupName'   => group.name,
            'entrantType' => entry_request.entry_type
          }
        ]
        get "/services/entrants/get/#{evaluation.semester}/#{user.auth_sch_id}"

        expect(response).to have_http_status :success
        expect(json_body).to eq expected_response
      end
    end
  end
end
