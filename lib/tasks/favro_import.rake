namespace :favro do
  namespace :import do
    task users: :environment do
      fetch_users.each do |favro_user|
        User.by_favro_ids(favro_user.userId).first_or_create do |user|
          user.email = favro_user.email
          user.name = favro_user.name
          user.service_ids = { favro: favro_user.userId }
        end
      end
    end

    task cards: :environment do
      custom_fields = fetch_custom_fields

      if timesheets_field = custom_fields.detect{|cf| cf['name'] == 'Time sheets'}
        timesheets_field_id = timesheets_field['customFieldId']
      end

      fetch_cards.each do |favro_card|
        card = Card.where("service_ids ->> 'favro' = ?", favro_card.cardCommonId).first_or_create do |c|
          c.title       = favro_card.name
          c.service_ids = { favro: favro_card.cardCommonId }
        end

        data = {
          start_date: favro_card.startDate,
          due_date:   favro_card.dueDate
        }

        card.update(
          data: data,
          description: favro_card.detailedDescription,
          archived: favro_card.archived,
          member_ids: User.by_favro_ids(favro_card.assignments.map(&:userId)).pluck(:id)
        )

        if sheets = favro_card.customFields.detect{|x| x.customFieldId == timesheets_field_id }
          sheets.reports.each do |userId, reports|
            user = User.by_favro_ids(userId).first
            next unless user
            reports.each do |report|
              next if report['value'].to_i < 1000
              card.timesheets.where(
                user: user,
                created_at: Time.parse(report['createdAt'])
              ).first_or_create do |timesheet|
                timesheet.time = report['value'] / 1000
              end
            end
          end
        end
      end
    end

    task all: :environment do
      Rake::Task['favro:import:users'].invoke
      Rake::Task['favro:import:cards'].invoke
    end

    def fetch_users
      auth

      output   = []
      page     = 0
      pages    = 1
      response = nil
      while page < pages
        response = FavroApi.users(
          page: page,
          last_response: response,
          organization_id: ENV['FAVRO_ORGANIZATION_ID']
        )
        output += response.entities
        page  = response.page + 1
        pages = response.pages
      end
      output
    end

    def fetch_cards
      auth

      output   = []
      page     = 0
      pages    = 1
      response = nil
      while page < pages
        response = FavroApi.cards(
          page: page,
          last_response: response,
          organization_id: ENV['FAVRO_ORGANIZATION_ID'],
          collectionId: ENV['FAVRO_COLLECTION_ID'],
          unique: true
        )
        output += response.entities
        page  = response.page + 1
        pages = response.pages
      end
      output
    end

    def fetch_custom_fields
      auth
      response = FavroApi.custom_fields(
        organization_id: ENV['FAVRO_ORGANIZATION_ID'],
        collectionId: ENV['FAVRO_COLLECTION_ID']
      )
      response.entities
    end

    def auth
      FavroApi.auth = { email: 'kr3ssh@gmail.com', token: 'EGi00vLxUZjdp6RQd-QDYcyLpNew75rsB6ynVJVzXcA' }
    end
  end
end
