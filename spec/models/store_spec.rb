require 'spec_helper'

describe Store do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :api_url  }
    it { should validate_presence_of :user  }
    it { should validate_presence_of :password  }
  end
end