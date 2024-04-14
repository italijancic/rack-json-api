# frozen_string_literal: true

require 'pstore'
require 'yaml/store'

class BaseModel
  module ClassMethods
    # Find a record bi ID
    #
    def find(id)
      db.transaction(true) do
        db[derive_db_id(self.name, id)]
      end
    end

    # Returns all records for this model
    #
    def all
      db.transaction(true) do
        ids = extract_model_ids(db)
        ids.map { |key| db[key] }
      end
    end

    # Returns first product on DB
    #
    def first
      db.transaction(true) do
        db[derive_db_id(self.name, 1)]
      end
    end

    # Returns first product on DB
    #
    def last
      last_id = next_available_id - 1
      db.transaction(true) do
        db[derive_db_id(self.name, last_id)]
      end
    end

    # Store an instance in DB
    #
    def save(object)
      db_id = derive_db_id(object.class.name, object.id)
      db.transaction do
        db[db_id] = object
      end
    end

    # Create and save a new instance in the database
    #
    def create(attributes)
      new_instance = new(**attributes)
      new_instance.save
    end

    # Delete an instance in DB
    def delete(object)
      db_id = derive_db_id(object.class.name, object.id)
      db.transaction do
        db.delete(db_id)
      end
    end

    # Scoped by class, to auto-increment the IDs
    #
    def next_available_id
      last_id = all_ids.map do |key|
        key.sub("#{self.name}_", '').to_i
      end.max.to_i

      last_id + 1
    end

    private

    # Access to the DB selected type
    #
    def db
      @db ||= case ENV['DB_TYPE']
              when 'pstore'
                PStore.new(File.expand_path("#{ENV['DB_PATH']}.pstore", __dir__))
              when 'ymlstore'
                YAML::Store.new(File.expand_path("#{ENV['DB_PATH']}.yml", __dir__))
              else
                # By default use pstore
                PStore.new(File.expand_path("#{ENV['DB_PATH']}.pstore", __dir__))
              end
    end

    # Scoped by class, so that different model classes
    # can have the same numerical IDs
    #
    def derive_db_id(model_name, object_id)
      "#{model_name}_#{object_id}"
    end

    # Get all ids for a model
    #
    def all_ids
      db.transaction(true) do |db|
        extract_model_ids(db)
      end
    end

    # Get all the PStore root keys (the DB IDs)
    # scoped for the current class
    #
    def extract_model_ids(store)
      store.roots.select do |key|
        key.start_with?(self.name)
      end
    end
  end
  extend ClassMethods

  def save
    ensure_presence_of_id
    self.class.save(self)
  end

  def ensure_presence_of_id
    self.id ||= self.class.next_available_id
  end

  def delete
    self.class.delete(self)
  end
end
