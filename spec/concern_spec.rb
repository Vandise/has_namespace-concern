require 'spec_helper'

RSpec.describe HasNamespace::Concern do

  let!(:user) { Administration::User.create(name: 'Bender', email: 'benderisgreat@futurama.com') }
  let!(:post) { Content::Post.create(user: user, title: 'The Ballad of Me: Bender', body: '"Tell my offspring I loved me."') }
  let!(:tag) { Content::Tag.create(name: 'Folk Songs', posts: [post]) }
  let!(:picture) { Profile::Picture.create(user: user, url: '/personality/me.jpg') }
  let!(:team) { Account::Team.create(name: 'MomCo Robotics', users: [user]) }

  describe 'association attributes' do
    context '.table_name' do
      it 'returns the namespaced table name' do
        expect(Administration::User.table_name).to eq('administration_users')
      end
    end

    context '.table_name_prefix' do
      it 'returns the modularized prefix' do
        expect(Administration::User.table_name_prefix('Test::Namespace')).to eq('test_namespace_')
      end
    end

    context '.module_prefix' do
      it 'returns the table namespace prefix' do
        expect(Administration::User.module_prefix).to eq('Administration')
      end      
    end
  end

  describe 'associations' do
    context 'belongs_to!' do
      it 'maps the namespaced tables' do
        expect(post.user).to eq(user)
      end
    end

    context 'has_one!' do
      it 'maps the namespaced tables' do
        expect(user.picture).to eq(picture)
      end
    end

    context 'has_many!' do
      it 'maps the namespaced tables' do
        expect(user.posts).to eq([post])
      end
    end

    context 'has_and_belongs_to_many!' do
      it 'maps the namespaced tables' do
        expect(post.tags).to eq([tag])
      end
    end

    describe 'when working with non-standard definitions' do
      it 'maps the non-standard model to the standard model' do
        expect(team.users).to eq([user])
      end

      it 'maps the standard model to the non-standard model' do
        expect(user.team).to eq(team)
      end
    end
  end
end