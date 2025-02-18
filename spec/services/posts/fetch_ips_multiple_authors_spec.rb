require 'rails_helper'

RSpec.describe Posts::FetchIpsMultipleAuthors, type: :service do
  describe '.call' do
    subject(:fetch_ips_multiple_authors) { described_class.call }

    context 'when no posts exist' do
      it 'returns an empty array' do
        expect(fetch_ips_multiple_authors).to eq([])
      end
    end

    context 'when there are posts but no IP has multiple distinct authors' do
      let!(:user) { create(:user) }

      before do
        create(:post, user: user, ip: '1.1.1.1')
        create(:post, user: user, ip: '2.2.2.2')
      end

      it 'returns an empty array' do
        expect(fetch_ips_multiple_authors).to eq([])
      end
    end

    context 'when there is at least one IP with multiple distinct authors' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }

      before do
        create(:post, user: user1, ip: '1.2.3.4')
        create(:post, user: user2, ip: '1.2.3.4')

        create(:post, user: user1, ip: '9.9.9.9')

        create(:post, user: user3, ip: '3.3.3.3')
      end

      it 'returns an array of IPs (and logins) that have multiple authors' do
        result = fetch_ips_multiple_authors

        expect(result).to contain_exactly(
          {
            ip: '1.2.3.4',
            logins: match_array([user1.login, user2.login])
          }
        )
      end
    end

    context 'when multiple IPs each have multiple distinct authors' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:user4) { create(:user) }

      before do
        create(:post, user: user1, ip: '1.2.3.4')
        create(:post, user: user2, ip: '1.2.3.4')

        create(:post, user: user3, ip: '2.2.2.2')
        create(:post, user: user4, ip: '2.2.2.2')

        create(:post, user: user1, ip: '3.3.3.3')
      end

      it 'returns all IPs with multiple authors and their logins' do
        result = fetch_ips_multiple_authors

        expect(result).to contain_exactly(
          {
            ip: '1.2.3.4',
            logins: match_array([user1.login, user2.login])
          },
          {
            ip: '2.2.2.2',
            logins: match_array([user3.login, user4.login])
          }
        )
      end
    end
  end
end
