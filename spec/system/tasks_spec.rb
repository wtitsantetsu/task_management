require 'rails_helper'

describe 'タスク管理機能', type: :system do
    let(:user_a) {FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')}
    let(:user_b) {FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')}
    let!(:task_a) {FactoryBot.create(:task, name: '最初のタスク', user: user_a)}


    before do

     visit login_path
     fill_in 'メールアドレス', with: login_user.email
     fill_in 'パスワード', with: login_user.password
     click_button 'ログインする'
    end

    shared_examples_for 'ユーザーAが作成したタスクが表示される' do
        it { expect(page).to have_content '最初のタスク' }
    end

    describe '一覧表示機能' do
        context 'ユーザーAがログインしているとき' do
            # before do(Bのログインと同じ作業で共通化したので無効)
            # # ユーザーAでログインする
            #  visit login_path
            #  fill_in 'メールアドレス', with: 'a@example.com'
            #  fill_in 'パスワード', with: 'password'
            #  click_button 'ログインする'
            # end

            let(:login_user) {user_a}

            it_behaves_like 'ユーザーAが作成したタスクが表示される'
        end

        context 'ユーザーBがログインしているとき' do
            let(:login_user) {user_b}
            # before do
            #     # ユーザーBを作成しておく
            #     # ユーザーBでログインする(Aと同じ作業のため、共通化したので無効)
            #     # visit login_path
            #     # fill_in 'メールアドレス', with: 'b@example.com'
            #     # fill_in 'パスワード', with: 'password'
            #     # click_button 'ログインする'
            # end

            it 'ユーザーAが作成したタスクが表示されない' do
             #ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
                 expect(page).to have_no_content '最初のタスク'
            end
        end
    end

    describe '詳細表示機能' do
        context 'ユーザーAがログインしているとき' do
            # ユーザーAでログインする
            let(:login_user) { user_a }
            
            before do
             visit task_path(task_a)
            end

            it_behaves_like 'ユーザーAが作成したタスクが表示される'

        end
    end

    describe '新規作成機能' do
        let(:login_user) { user_a }

        before do
            visit new_task_path
            fill_in 'task_name', with: task_name
            click_button '登録する'
        end

        context  '新規作成画面で名称を入力したとき' do
            let(:task_name) { '新規作成のテストを書く' }
            
            it '正常に登録される' do
                expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
            end
        end

        context '新規作成画面で名称を入力しなかったとき' do
            let(:task_name) { '' }

            it 'エラーとなる' do
                within '#error_explanation' do
                 expect(page).to have_content 'Nameを入力してください'
                end
            end
        end
    end
end