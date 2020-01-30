require 'rails_helper'

RSpec.shared_examples_for VotableActions do
  let(:user) { create(:user) }

  describe 'POST #upvote' do
    context 'Authenticated user' do
      before { login(user) }

      it 'changes the resource score' do
        expect { post :upvote, params: { id: resource } }
          .to change(resource, :score).by 1
      end

      it 'does not change the resource score more than once' do
        post :upvote, params: { id: resource, positive: true }
        expect { post :upvote, params: { id: resource } }
          .to_not change(resource, :score)
      end
    end

    context 'Resource author' do
      before { login(resource.user) }

      it 'does not change the resource score' do
        expect { post :upvote, params: { id: resource } }
          .to_not change(resource, :score)
      end
    end

    context 'Unauthenticated user' do
      it 'does not change the resource score' do
        expect { post :upvote, params: { id: resource } }
          .to_not change(resource, :score)
      end
    end
  end

  describe 'POST #downvote' do
    context 'Authenticated user' do
      before { login(user) }

      it 'changes the resource score' do
        expect { post :downvote, params: { id: resource } }
          .to change(resource, :score).by -1
      end

      it 'does not change the resource score more than once' do
        post :downvote, params: { id: resource, positive: true }
        expect { post :downvote, params: { id: resource } }
          .to_not change(resource, :score)
      end
    end

    context 'Resource author' do
      before { login(resource.user) }

      it 'does not change the resource score' do
        expect { post :downvote, params: { id: resource } }
          .to_not change(resource, :score)
      end
    end

    context 'Unauthenticated user' do
      it 'does not change the resource score' do
        expect { post :downvote, params: { id: resource } }
          .to_not change(resource, :score)
      end
    end
  end
end
