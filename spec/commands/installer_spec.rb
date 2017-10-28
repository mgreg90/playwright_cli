RSpec.describe Playwright::Commands::Installer do
  before do
    MemFs.activate!
  end
  after { MemFs.deactivate! }
  
  describe '#create_file_structure' do
    
    it "creates bin folder" do
      subject.create_file_structure
      expect(Dir.exists?("#{Dir.home}/.playwright/bin")).to be true
    end
    
    it "creates plays folder" do
      subject.create_file_structure
      expect(Dir.exists?("#{Dir.home}/.playwright/plays")).to be true
    end
    
  end
  
  describe '#create_if_exists' do
    let(:bin_path) { subject.class.const_get('BIN_PATH') }
    context "when directory doesn't exist" do
      it 'outputs created msg' do
        expect { subject.create_if_exists(bin_path) }.to output("#{bin_path} created!\n").to_stdout
      end
      it 'creates the file' do
        subject.create_if_exists(bin_path)
        expect(Dir.exists?(bin_path)).to be true
      end
    end
    context "when directory already exists" do
      before { FileUtils.mkpath(bin_path) }
      it 'outputs created msg' do
        expect { subject.create_if_exists(bin_path) }.to output("#{bin_path} already exists!\n").to_stdout
      end
    end
  end
end