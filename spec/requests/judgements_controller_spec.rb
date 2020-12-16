# frozen_string_literal: true

describe JudgementsController do
  before(:each) do
    login_as(user)
  end
  let(:evaluation) { create(:evaluation) }
  context 'off season' do
    include_context 'off season'
    context 'and user is the RVT leader' do
      let(:user) { Group.find(Group::RVT_ID).leader.user }

      describe 'index' do
        it 'returns forbidden' do
          get '/judgement'

          expect(response).to have_http_status(:forbidden)
        end
      end

      describe 'update' do
        it 'returns forbidden' do
          post "/judgement/#{evaluation.id}/update"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  context 'evaluation season' do
    include_context 'evaluation season'
    context 'and the user is the RVT leader' do
      let(:user) { Group.find(Group::RVT_ID).leader.user }

      describe 'index' do
        it 'is successful' do
          get '/judgement'

          expect(response).to have_http_status(:ok)
        end
      end

      describe 'show' do
        it 'is successful' do
          get "/judgement/#{evaluation.id}"

          expect(response).to have_http_status(:ok)
        end
      end

    end

    context 'and the user is the resort leader' do
      let(:user) { evaluation.group.parent.leader.user }

      describe 'update' do
        context 'to parmited statuses' do
          let(:params) do
            { point_request_status: Evaluation::REJECTED,
              entry_request_status: Evaluation::NOT_YET_ASSESSED }
          end

          it 'redirects' do
            post "/judgement/#{evaluation.id}/update", params: params

            expect(response).to redirect_to(judgements_path)
          end

          it 'updates the attributes' do
            post "/judgement/#{evaluation.id}/update", params: params

            expect(evaluation.reload).to have_attributes(params)
          end
        end

        context 'to accepted point request' do
          let(:params) do
            { point_request_status: Evaluation::ACCEPTED }
          end

          it 'returns forbidden' do
            post "/judgement/#{evaluation.id}/update",
                 params: params
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'to accepted entry request' do
          let(:params) do
            { entry_request_status: Evaluation::ACCEPTED }
          end

          it 'returns forbidden' do
            post "/judgement/#{evaluation.id}/update",
                 params: params
            expect(response).to have_http_status(:forbidden)
          end
        end

        context "not changed" do
          let(:params) do
            { entry_request_status: Evaluation::REJECTED,
              point_request_status: Evaluation::NOT_YET_ASSESSED }
          end

          before(:each) do
            evaluation.update(point_request_status: Evaluation::REJECTED)
            evaluation.update(entry_request_status: Evaluation::NOT_YET_ASSESSED)
          end

          it 'redirects' do
            post "/judgement/#{evaluation.id}/update",
                 params: params
            expect(response).to redirect_to(judgements_path)
          end
        end

        context 'accepted evaluation to rejected' do
          let(:params) do
            { entry_request_status: Evaluation::REJECTED,
              entry_request_status: Evaluation::REJECTED }
          end

          before(:each) do
            evaluation.update(point_request_status: Evaluation::ACCEPTED)
            evaluation.update(entry_request_status: Evaluation::ACCEPTED)
          end

          it 'returns forbidden' do
            post "/judgement/#{evaluation.id}/update",
                 params: params
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end
end
