# spec/factories/active_storage.rb
FactoryBot.define do
    factory :attached_file, class: 'ActiveStorage::Attachment' do
      name { 'file' }
      record_type { 'User' }  
      record { association :user }
  
      after(:build) do |attachment, evaluator|
        attachment.blob = build(:active_storage_blob)
      end
    end
  
    factory :active_storage_blob, class: 'ActiveStorage::Blob' do
      filename { 'example_file.pdf' }
      key { SecureRandom.hex(28) }
      content_type { 'application/pdf' }
      byte_size { 1000 }
      checksum { Digest::MD5.base64digest('example') }
      service_name { 'local' }
      
      after(:build) do |blob|
        blob.upload(io: StringIO.new('test'), filename: blob.filename, content_type: blob.content_type)
      end
    end
  end
  