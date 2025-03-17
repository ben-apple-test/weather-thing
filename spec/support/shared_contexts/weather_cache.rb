RSpec.shared_context "weather cache" do
  let(:cache_store) { ActiveSupport::Cache::MemoryStore.new }

  before do
    allow(Rails).to receive(:cache).and_return(cache_store)
  end

  def cache_key_for(type, zip)
    "#{type}_#{zip}"
  end
end
