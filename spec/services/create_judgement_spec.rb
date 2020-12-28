# frozen_string_literal: true

describe CreateJudgement do
  subject { described_class.new(params, evaluation, user) }

  let(:evaluation) { create(:evaluation) }

  context 'when evaluation season' do
    include_context 'evaluation season'

    context 'and the user has no permission' do
      let(:user) { create(:user) }
      let(:params) do
        { point_request_status: Evaluation::REJECTED,
          entry_request_status: Evaluation::NOT_YET_ASSESSED }
      end

      it 'raises an error' do
        expect { subject.call }.to raise_error(CreateJudgement::UserCantMakeTheRequestedUpdates)
      end
    end

    context 'and the user is the resort leader' do
      let(:user) { evaluation.group.parent.leader.user }

      context 'and the request statuses are not changed' do
        let(:params) do
          { point_request_status: evaluation.point_request_status,
            entry_request_status: evaluation.entry_request_status }
        end

        it 'raises an error' do
          expect { subject.call }.to raise_error(CreateJudgement::NoChangeHaveBeenMade)
        end
      end

      context 'and the request statuses are changed' do
        let(:params) do
          { point_request_status: Evaluation::REJECTED,
            entry_request_status: Evaluation::NOT_YET_ASSESSED }
        end
        it 'creates message' do
          expect { subject.call }.to change { EvaluationMessage.count }.by(1)
        end

        it 'updates the attributes' do
          subject.call

          expect(evaluation).to have_attributes(params)
        end
      end

      context 'and tries to accept' do
        let(:params) do
          { point_request_status: Evaluation::ACCEPTED,
            entry_request_status: Evaluation::NOT_YET_ASSESSED }
        end

        it 'raises an error' do
          expect { subject.call }.to raise_error(CreateJudgement::UserCantMakeTheRequestedUpdates)
        end
      end

      context 'and the evaluation is accepted' do
        before(:each) do
          evaluation.update(
            point_request_status: Evaluation::ACCEPTED,
            entry_request_status: Evaluation::ACCEPTED)
        end

        context 'and tries to update it' do
          let(:params) do
            { point_request_status: Evaluation::REJECTED,
              entry_request_status: Evaluation::NOT_YET_ASSESSED }
          end

          it 'raises an error' do
            expect { subject.call }.to raise_error(CreateJudgement::UserCantMakeTheRequestedUpdates)
          end
        end
      end
    end

    context 'when the user is the RVT leader' do
      let(:user) { Group.find(Group::RVT_ID).leader.user }

      context 'and tries to accept' do
        let(:params) do
          { point_request_status: Evaluation::ACCEPTED,
            entry_request_status: Evaluation::NOT_YET_ASSESSED }
        end

        it 'updates the attributes' do
          subject.call

          expect(evaluation).to have_attributes(params)
        end
      end

      context 'and the evaluation is accepted' do
        before(:each) do
          evaluation.update(
            point_request_status: Evaluation::ACCEPTED,
            entry_request_status: Evaluation::ACCEPTED)
        end

        context 'and tries to update it' do
          let(:params) do
            { point_request_status: Evaluation::REJECTED,
              entry_request_status: Evaluation::NOT_YET_ASSESSED }
          end

          it 'updates the attributes' do
            subject.call

            expect(evaluation).to have_attributes(params)
          end
        end
      end
    end
  end
end
